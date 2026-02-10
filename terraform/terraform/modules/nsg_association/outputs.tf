output "nsg_association_id" {
  description = "The ID of the NSG association to the subnet"
  value       = azurerm_subnet_network_security_group_association.apim_subnet_nsg.id
}