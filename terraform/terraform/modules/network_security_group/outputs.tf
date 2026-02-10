output "id" {
  description = "ID del NSG"
  value       = azurerm_network_security_group.azure_nsg.id
}

output "name" {
  description = "NSG name"
  value       = azurerm_network_security_group.azure_nsg.name
}