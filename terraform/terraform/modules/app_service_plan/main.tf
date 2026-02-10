resource "azurerm_service_plan" "app_service_plan" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  os_type             = var.os_type
  sku_name            = var.sku_name



  tags = var.tags
}

resource "azurerm_monitor_diagnostic_setting" "service_plan_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.name}-diagnostic"
  target_resource_id         = azurerm_service_plan.app_service_plan.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_metric {
    category = "AllMetrics"
  }
}

############################
# AUTOSCALE CONFIGURATION
# Only provisioned when var.enable_autoscale = true
############################
resource "azurerm_monitor_autoscale_setting" "app_service_plan_autoscale" {
  count               = var.enable_autoscale ? 1 : 0
  name                = "${var.name}-autoscale"
  resource_group_name = var.resource_group_name
  location            = var.location
  target_resource_id  = azurerm_service_plan.app_service_plan.id
  enabled             = true
  tags                = var.tags

  profile {
    name = "default"

    capacity {
      minimum = tostring(var.autoscale_min_capacity)
      maximum = tostring(var.autoscale_max_capacity)
      default = tostring(var.autoscale_default_capacity)
    }

    # Scale OUT rule (Increase instances when CPU > threshold)
    rule {
      metric_trigger {
        metric_name        = var.autoscale_metric_name
        metric_resource_id = azurerm_service_plan.app_service_plan.id
        metric_namespace   = "Microsoft.Web/serverfarms"
        time_grain         = "PT1M"
        statistic          = var.autoscale_scale_out_statistic
        time_window        = format("PT%02dM", var.autoscale_scale_out_duration_minutes)
        time_aggregation   = "Average"
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

    # Scale IN rule (Decrease instances when CPU < threshold)
    rule {
      metric_trigger {
        metric_name        = var.autoscale_metric_name
        metric_resource_id = azurerm_service_plan.app_service_plan.id
        metric_namespace   = "Microsoft.Web/serverfarms"
        time_grain         = "PT1M"
        statistic          = var.autoscale_scale_in_statistic
        time_window        = format("PT%02dM", var.autoscale_scale_in_duration_minutes)
        time_aggregation   = "Minimum"
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

  depends_on = [azurerm_service_plan.app_service_plan]
}