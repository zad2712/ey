resource "azurerm_linux_web_app" "app_service_linux" {
  name                = var.app_service_name
  location            = var.location
  resource_group_name = var.resource_group_name
  service_plan_id     = var.app_service_plan_id

  site_config {
    always_on = true
  }

  dynamic "app_settings" {
    for_each = var.app_settings
    content {
      name  = app_settings.key
      value = app_settings.value
    }
  }

   ### Activate Managed Identity
  identity {
    type = "SystemAssigned"
  }
  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "diagnostic" {
  count               = var.enable_diagnostics ? 1 : 0
  name                = "${var.app_service_name}-diagnostic"
  target_resource_id  = azurerm_linux_web_app.app.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AppServiceHTTPLogs"
    retention_policy {
      enabled = true
      days    = 365
    }
  }
  
  enabled_log {
    category = "AppServiceConsoleLogs"
  }

  enabled_log {
    category = "AppServiceAppLogs"
  }

  enabled_log {
    category = "AppServiceAuditLogs"
  }

  enabled_log {
    category = "AppServiceIPSecAuditLogs"
  }

  enabled_log {
    category = "AppServicePlatformLogs"
  }

  enabled_log {
    category = "AppServiceAntivirusAuditLogs"
  }

  enabled_log {
    category = "AppServiceSiteContentChangeAuditLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

# Auth
resource "azurerm_app_service_auth_settings_v2" "auth" {
  count              = var.enable_auth ? 1 : 0
  name               = azurerm_linux_web_app.app.name
  resource_group_name = var.resource_group_name
  site_config {
    default_provider = var.auth_settings.default_provider
    facebook {
      app_id     = lookup(var.auth_settings, "facebook_app_id", null)
      app_secret_setting_name = lookup(var.auth_settings, "facebook_app_secret", null)
    }
  }
  auth_enabled = true
}


resource "azurerm_monitor_autoscale_setting" "autoscale" {
  count               = var.enable_autoscale ? 1 : 0
  name                = "${var.app_service_name}-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = var.app_service_plan_id

  profile {
    name = "default"

    capacity {
      minimum = var.autoscale_settings.min
      maximum = var.autoscale_settings.max
      default = var.autoscale_settings.default
    }

    rule {
      metric_trigger {
        metric_name        = "CpuPercentage"
        metric_resource_id = var.app_service_plan_id
        time_grain         = "PT1M"
        statistic          = "Average"
        time_window        = "PT5M"
        time_aggregation   = "Average"
        operator           = "GreaterThan"
        threshold          = 70
      }

      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = "1"
        cooldown  = "PT1M"
      }
    }
  }
}