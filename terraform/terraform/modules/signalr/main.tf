# filepath: c:\Users\XG573ZM\OneDrive - EY\Documents\EYX\Repos\il-eyx-iac\terraform\modules\signalr\main.tf
resource "azurerm_signalr_service" "signalr" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  sku {
    name     = var.sku_name
    # If autoscale enabled, start at autoscale_default_capacity to avoid immediate adjustment
    capacity = var.enable_autoscale ? var.autoscale_default_capacity : var.sku_capacity
  }

  tags = var.tags

  dynamic "identity" {
    for_each = var.identity != null ? [1] : []
    content {
      type         = var.identity.type
      identity_ids = lookup(var.identity, "identity_ids", null)
    }
  }

  dynamic "cors" {
    for_each = var.cors != null ? [1] : []
    content {
      allowed_origins = var.cors.allowed_origins
    }
  }

  lifecycle {
    # When autoscaling is enabled, Azure's autoscale engine continuously adjusts capacity
    # based on external metrics (e.g., App Service Plan CPU/load). Since capacity changes
    # are managed by autoscaling rather than Terraform, we ignore capacity drift to prevent
    # constant plan changes. Terraform still manages autoscale rules (thresholds, cooldown,
    # scale amounts), but not the real-time capacity fluctuations.
    ignore_changes = [sku[0].capacity]
  }
}

resource "azurerm_monitor_diagnostic_setting" "signalr_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.name}-diagnostic"
  target_resource_id         = azurerm_signalr_service.signalr.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "AllLogs"
  }
  
  enabled_metric {
    category = "AllMetrics"
  }
}

############################
# Azure Monitor Autoscale (Premium tier only)
# Creates metric-based autoscale rules for SignalR units.
# Metrics commonly used: "Connection Quota Utilization", "Server Load"
# Only provisioned when var.enable_autoscale = true
############################
resource "azurerm_monitor_autoscale_setting" "signalr_autoscale" {
  count               = var.enable_autoscale ? 1 : 0
  name                = "${var.name}-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_signalr_service.signalr.id
  enabled             = true
  tags                = var.tags

  profile {
    name = "default"

    capacity {
      minimum = tostring(var.autoscale_min_capacity)
      maximum = tostring(var.autoscale_max_capacity)
      default = tostring(var.autoscale_default_capacity)
    }

    # Scale OUT rule (Increase by autoscale_scale_out_change_count when selected metric statistic > threshold)
    rule {
      metric_trigger {
        metric_name        = var.autoscale_metric_name
        metric_resource_id = var.autoscale_external_metric_enabled ? var.autoscale_external_metric_resource_id : azurerm_signalr_service.signalr.id
        metric_namespace   = var.autoscale_external_metric_enabled ? var.autoscale_external_metric_namespace : "Microsoft.SignalRService/SignalR"
        time_grain         = "PT1M"
        statistic          = var.autoscale_scale_out_statistic
        time_window        = "PT5M" # short window for responsiveness
        time_aggregation   = var.autoscale_scale_out_statistic == "Min" ? "Minimum" : var.autoscale_scale_out_statistic == "Max" ? "Maximum" : var.autoscale_scale_out_statistic
        operator           = "GreaterThan"
        threshold          = var.autoscale_scale_out_threshold
      }
      scale_action {
        direction = "Increase"
        type      = "ChangeCount"
        value     = tostring(var.autoscale_scale_out_change_count)
        cooldown  = format("PT%02dM", var.autoscale_scale_out_cooldown_minutes)
      }
    }

    # Scale IN rule (Decrease by autoscale_scale_in_change_count when selected metric statistic < threshold)
    rule {
      metric_trigger {
        metric_name        = var.autoscale_metric_name
        metric_resource_id = var.autoscale_external_metric_enabled ? var.autoscale_external_metric_resource_id : azurerm_signalr_service.signalr.id
        metric_namespace   = var.autoscale_external_metric_enabled ? var.autoscale_external_metric_namespace : "Microsoft.SignalRService/SignalR"
        time_grain         = "PT1M"
        statistic          = var.autoscale_scale_in_statistic
        time_window        = "PT10M" # longer window for stable scale-in
        time_aggregation   = var.autoscale_scale_in_statistic == "Min" ? "Minimum" : var.autoscale_scale_in_statistic == "Max" ? "Maximum" : var.autoscale_scale_in_statistic
        operator           = "LessThan"
        threshold          = var.autoscale_scale_in_threshold
      }
      scale_action {
        direction = "Decrease"
        type      = "ChangeCount"
        value     = tostring(var.autoscale_scale_in_change_count)
        cooldown  = format("PT%02dM", var.autoscale_scale_in_cooldown_minutes)
      }
    }
  }
  depends_on = [azurerm_signalr_service.signalr]
}
