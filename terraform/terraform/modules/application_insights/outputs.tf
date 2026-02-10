output "id" {
  description = "The ID of the Application Insights component."
  value       = azurerm_application_insights.this.id
}

output "app_id" {
  description = "The App ID of the Application Insights component."
  value       = azurerm_application_insights.this.app_id
}

output "instrumentation_key" {
  description = "The instrumentation key of the Application Insights component."
  value       = azurerm_application_insights.this.instrumentation_key
  sensitive   = true
}

output "connection_string" {
  description = "The connection string of the Application Insights component."
  value       = azurerm_application_insights.this.connection_string
  sensitive   = true
}

output "name" {
  description = "The name of the Application Insights component."
  value       = azurerm_application_insights.this.name
}
