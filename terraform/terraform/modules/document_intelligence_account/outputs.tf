output "id" {
  description = "The ID of the Azure Document Intelligence account."
  value       = azurerm_cognitive_account.doc_intelligence_account.id
}

output "name" {
  description = "The name of the Azure Document Intelligence account."
  value       = azurerm_cognitive_account.doc_intelligence_account.name
}

output "endpoint" {
  description = "The endpoint of the Azure Document Intelligence account."
  value       = azurerm_cognitive_account.doc_intelligence_account.endpoint
}

output "primary_key" {
  description = "The primary key for the Azure Document Intelligence account."
  value       = azurerm_cognitive_account.doc_intelligence_account.primary_access_key
  sensitive   = true
}

output "secondary_key" {
  description = "The secondary key for the Azure Document Intelligence account."
  value       = azurerm_cognitive_account.doc_intelligence_account.secondary_access_key
  sensitive   = true
}

output "identity_principal_id" {
  description = "The Principal ID of the System Assigned Managed Identity for the Document Intelligence account."
  value       = azurerm_cognitive_account.doc_intelligence_account.identity[0].principal_id
}

output "identity_tenant_id" {
  description = "The Tenant ID of the System Assigned Managed Identity for the Document Intelligence account."
  value       = azurerm_cognitive_account.doc_intelligence_account.identity[0].tenant_id
}