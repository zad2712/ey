output "resource_group" {
  description = "This is the full output for the resource group created by the module. This is the default output for the module following AVM standards. Review the examples below for the correct output to use in your module. Examples: - module.resource_group.resource.id - module.resource_group.resource.name"
  value       = module.resource_group.resource
}

output "resource_group_name" {
  description = "The name of the resource group created by the module."
  value       = module.resource_group.resource.name
}

output "resource_group_id" {
  description = "The ID of the resource group created by the module."
  value       = module.resource_group.resource.id
}

output "log_analytics_workspace" {
  description = "This is the full output for the Log Analytics resource. This is the default output for the module following AVM standards. Review the examples below for the correct output to use in your module. Examples: - module.log_analytics.resource.id - module.log_analytics.resource.name"
  value       = module.avm-res-operationalinsights-workspace.resource
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace created by the module."
  value       = module.avm-res-operationalinsights-workspace.resource.id
  sensitive   = true
}

output "key_vault_keys" {
  description = "The keys stored in the Key Vault created by the core module."
  value       = module.avm-res-keyvault-vault.key_vault_keys
}

output "key_vault_keys_ids" {
  description = "The IDs of the keys stored in the Key Vault created by the core module."
  value       = module.avm-res-keyvault-vault.key_vault_keys_ids
}

output "key_vault_name" {
  description = "The name of the Key Vault created by the core module."
  value       = module.avm-res-keyvault-vault.key_vault_name
}

output "key_vault_id" {
  description = "The ID of the Key Vault created by the core module."
  value       = module.avm-res-keyvault-vault.key_vault_id
}

output "key_vault_secrets" {
  description = "The secrets stored in the Key Vault created by the core module."
  value       = module.avm-res-keyvault-vault.key_vault_secrets
}

output "key_vault_secrets_ids" {
  description = "The IDs of the secrets stored in the Key Vault."
  value       = module.avm-res-keyvault-vault.key_vault_secrets_resource_ids
}

output "key_vault_uri" {
  description = "The URI of the Key Vault."
  value       = module.avm-res-keyvault-vault.key_vault_uri
}


output "app_insights_id" {
  description = "The ID of the Application Insights component."
  value       = var.app_insights_name != null ? module.application_insights[0].id : null
}

output "app_insights_instrumentation_key" {
  description = "The instrumentation key of the Application Insights component."
  value       = var.app_insights_name != null ? module.application_insights[0].instrumentation_key : null
  sensitive   = true
}

output "app_insights_connection_string" {
  description = "The connection string of the Application Insights component."
  value       = var.app_insights_name != null ? module.application_insights[0].connection_string : null
  sensitive   = true
}

output "user_assigned_identity_client_id" {
  description = "The client ID of the User Assigned Identity."
  value       = var.user_assigned_identity_name != null ? module.avm-res-userassignedidentity[0].resource.client_id : null
}