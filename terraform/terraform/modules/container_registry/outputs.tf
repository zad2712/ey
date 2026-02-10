output "id" {
  description = "The ID of the Container Registry."
  value       = azurerm_container_registry.acr.id
}

output "name" {
  description = "The name of the Container Registry."
  value       = azurerm_container_registry.acr.name
}

output "login_server" {
  description = "The login server to be used with Docker."
  value       = azurerm_container_registry.acr.login_server
}

output "admin_username" {
  description = "The Username for Authentication against the Admin User of the Container Registry."
  value       = azurerm_container_registry.acr.admin_username
  sensitive   = true
}

output "admin_password" {
  description = "The Password for Authentication against the Admin User of the Container Registry."
  value       = azurerm_container_registry.acr.admin_password
  sensitive   = true
}