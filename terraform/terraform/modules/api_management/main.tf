resource "azurerm_api_management" "apim" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  publisher_name      = var.publisher_name
  publisher_email     = var.publisher_email
  sku_name            = var.sku_name
  tags                = var.tags

  dynamic "virtual_network_configuration" {
    for_each = var.subnet_id != null ? [1] : []
    content {
      subnet_id = var.subnet_id
    }
  }

  virtual_network_type = var.virtual_network_type

  zones = var.zones
  
  ### Activate Managed Identity
  identity {
    type = "SystemAssigned"
  }
}

resource "azurerm_monitor_diagnostic_setting" "apim" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${azurerm_api_management.apim.name}-diagnostic"
  target_resource_id         = azurerm_api_management.apim.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "GatewayLogs"
  }

}
