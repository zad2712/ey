output "function_app_id" {  
  description = "Azure Function App ID."
  value       = azurerm_linux_function_app.function_app.id
}

output "function_app_name" {
  description = "Name of the Azure Function App."
  value       = azurerm_linux_function_app.function_app.name
}

output "function_app_default_hostname" {
  description = "Default hostname of the Azure Function App."
  value       = azurerm_linux_function_app.function_app.default_hostname
}

output "function_app_identity" {
  description = "Managed identity assigned to the Function App (if applicable)."
  value       = azurerm_linux_function_app.function_app.identity
}