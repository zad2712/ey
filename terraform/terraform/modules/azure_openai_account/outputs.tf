// filepath: c:\Users\XG573ZM\OneDrive - EY\Documents\EYX\IaC\il-eyx-iac\terraform\modules\azure_openai_account\outputs.tf
output "id" {
  description = "The ID of the Azure OpenAI account."
  value       = azurerm_cognitive_account.openai_account.id // Ensure this refers to the correct resource name 'openai_account'
}

output "name" {
  description = "The name of the Azure OpenAI account."
  value       = azurerm_cognitive_account.openai_account.name // Ensure this refers to the correct resource name 'openai_account'
}

output "endpoint" {
  description = "The endpoint of the Azure OpenAI account."
  value       = azurerm_cognitive_account.openai_account.endpoint // Ensure this refers to the correct resource name 'openai_account'
}

output "identity_principal_id" {
  description = "The Principal ID of the System Assigned Managed Identity for the OpenAI account."
  value       = azurerm_cognitive_account.openai_account.identity[0].principal_id
}

output "identity_tenant_id" {
  description = "The Tenant ID of the System Assigned Managed Identity for the OpenAI account."
  value       = azurerm_cognitive_account.openai_account.identity[0].tenant_id
}