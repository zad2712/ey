output "app_service_id" {
  value       = azurerm_windows_web_app.this.id
  description = "App Service ID"
}

output "id" {
  value       = azurerm_windows_web_app.this.id
  description = "The resource ID of the Windows Web App"
}

output "name" {
  value       = azurerm_windows_web_app.this.name
  description = "The name of the Windows Web App"
}

output "default_hostname" {
  value       = azurerm_windows_web_app.this.default_hostname
  description = "Default Hostname"
}

output "default_hostname_fqdn" {
  value       = "https://${azurerm_windows_web_app.this.default_hostname}"
  description = "The fully qualified domain name of the default hostname"
}

output "identity" {
  value       = azurerm_windows_web_app.this.identity
  description = "The managed identity block from the Web App"
}

output "principal_id" {
  value       = try(azurerm_windows_web_app.this.identity[0].principal_id, null)
  description = "The Principal ID associated with the Managed Service Identity of this App Service"
}

output "tenant_id" {
  value       = try(azurerm_windows_web_app.this.identity[0].tenant_id, null)
  description = "The Tenant ID associated with the Managed Service Identity of this App Service"
}