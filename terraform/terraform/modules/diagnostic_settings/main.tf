resource "azurerm_monitor_diagnostic_setting" "azure_diagnostic" {
  name                       = var.azure_diagnostic_name
  target_resource_id         = var.target_resource_id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  dynamic "enabled_log" {
    for_each = var.log_categories
    content {
      category = enabled_log.value.category

      retention_policy {
        enabled = enabled_log.value.retention_enabled
        days    = enabled_log.value.retention_days
      }
    }
  }

  enabled_metric {
    category = "AllMetrics"
  }

  
}