output "id" {
  description = "The ID of the private endpoint."
  value       = azurerm_private_endpoint.pep.id
}

output "name" {
  description = "The name of the private endpoint."
  value       = azurerm_private_endpoint.pep.name
}
