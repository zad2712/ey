output "function_app_name" {
  description = "Function App name"
  value       = azurerm_windows_function_app.this.name
}

output "function_app_id" {
  description = "Function App resource ID"
  value       = azurerm_windows_function_app.this.id
}

output "function_app_default_hostname" {
  description = "Function App default hostname"
  value       = azurerm_windows_function_app.this.default_hostname
}

output "identity" {
  description = "Managed identity configuration"
  value       = try(azurerm_windows_function_app.this.identity[0], null)
}

output "principal_id" {
  description = "Managed identity principal ID"
  value       = try(azurerm_windows_function_app.this.identity[0].principal_id, null)
}