output "id" {
  description = "The ID of the Container App Environment."
  value       = azurerm_container_app_environment.cae.id
}

output "name" {
  description = "The name of the Container App Environment."
  value       = azurerm_container_app_environment.cae.name
}

output "default_domain" {
  description = "The default domain of the Container App Environment."
  value       = azurerm_container_app_environment.cae.default_domain
}

output "static_ip_address" {
  description = "The Static IP address of the Container App Environment (if applicable, typically for environments with an infrastructure subnet)."
  value       = azurerm_container_app_environment.cae.static_ip_address
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace used by the Container App Environment."
  value       = azurerm_container_app_environment.cae.log_analytics_workspace_id
}