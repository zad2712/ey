output "frontdoor_hostname" {
  value = azurerm_frontdoor.azure_frontdoor.frontend_endpoints[0].host_name
}

output "frontdoor_id" {
  value = azurerm_frontdoor.azure_frontdoor.id
}