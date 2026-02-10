output "vnet_name" {
  value = azurerm_virtual_network.azure_vnet.name
}

output "vnet_id" {
  value = azurerm_virtual_network.azure_vnet.id
}

output "subnet_ids" {
  value = { for k, s in azurerm_subnet.azure_subnet : k => s.id }
}