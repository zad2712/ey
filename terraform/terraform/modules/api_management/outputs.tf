output "apim_name" {
  description = "Nombre del recurso de API Management"
  value       = azurerm_api_management.apim.name
}

output "apim_id" {
  description = "ID completo del recurso de API Management"
  value       = azurerm_api_management.apim.id
}

output "apim_hostname" {
  description = "Nombre del host de APIM"
  value       = azurerm_api_management.apim.gateway_url
}

output "apim_management_endpoint" {
  description = "URL de administración del APIM"
  value       = azurerm_api_management.apim.management_api_url
}

output "apim_location" {
  description = "Ubicación del recurso"
  value       = azurerm_api_management.apim.location
}

output "apim_resource_group" {
  description = "Grupo de recursos donde está el APIM"
  value       = azurerm_api_management.apim.resource_group_name
}