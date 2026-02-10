##############################
# Module: azure_function_app
##############################

# Variables:
# - function_app_name
# - location
# - resource_group_name
# - storage_account_name
# - storage_account_access_key (or connection string)
# - app_service_plan_id (optional if not using Consumption or Premium)
# - os_type (Linux/Windows)
# - functions_version
# - auth_settings (opcional)
# - app_settings (opcional)
# - site_config (opcional)

resource "azurerm_linux_function_app" "function_app" {
  name                       = var.function_app_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  service_plan_id            = var.service_plan_id
  storage_account_name       = var.storage_account_name
  storage_account_access_key = var.storage_account_access_key
  functions_version          = var.functions_version
  https_only                 = true

  os_type = var.os_type

  identity {
    type = "SystemAssigned"
  }

  dynamic "auth_settings" {
    for_each = var.auth_settings != null ? [var.auth_settings] : []
    content {
      enabled                       = auth_settings.value.enabled
      default_provider              = auth_settings.value.default_provider
      issuer                        = lookup(auth_settings.value, "issuer", null)
      runtime_version               = lookup(auth_settings.value, "runtime_version", null)
      unauthenticated_client_action = lookup(auth_settings.value, "unauthenticated_client_action", null)

      dynamic "microsoft" {
        for_each = contains(["AzureActiveDirectory", "Microsoft"], auth_settings.value.default_provider) ? [1] : []
        content {
          client_id     = auth_settings.value.microsoft.client_id
          client_secret = auth_settings.value.microsoft.client_secret
        }
      }
    }
  }

  dynamic "app_settings" {
    for_each = var.app_settings != null ? [1] : []
    content {
      for key, value in var.app_settings :
      key => value
    }
  }

  dynamic "site_config" {
    for_each = var.site_config != null ? [1] : []
    content {
      always_on                 = lookup(var.site_config, "always_on", false)
      use_32_bit_worker_process = lookup(var.site_config, "use_32_bit_worker_process", true)
      ftps_state                = lookup(var.site_config, "ftps_state", "Disabled")

      dynamic "application_stack" {
        for_each = lookup(var.site_config, "application_stack", null) != null ? [1] : []
        content {
          python_version = lookup(var.site_config.application_stack, "python_version", null)
          dotnet_version = lookup(var.site_config.application_stack, "dotnet_version", null)
          node_version   = lookup(var.site_config.application_stack, "node_version", null)
        }
      }
    }
  }

  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "function_app_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.function_app_name}-diagnostic"
  target_resource_id         = azurerm_linux_function_app.function_app.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AllLogs"
    retention_policy {
      enabled = true
      days    = 365
    }
  }

  enabled_metric {
    category = "AllMetrics"
    
  }
}

