output "app_service_vnet_integration_id" {
  description = "App Service integration ID with VNet"
  value       = azurerm_app_service_virtual_network_swift_connection.integration.id
}