output "resource_group_name" {
  description = "The name of the resource group created by this module."
  value       = module.core.resource_group_name
}

output "resource_group_id" {
  description = "The ID of the resource group created by this module."
  value       = module.core.resource_group_id
}

output "resource_group_location" {
  description = "The location of the resource group created by this module."
  value       = module.core.resource_group.location
}

output "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace created by this module."
  value       = module.core.log_analytics_workspace_id
  sensitive   = true
}

output "key_vault_keys" {
  description = "The keys stored in the Key Vault created by the core module."
  value       = module.core.key_vault_keys
}

output "key_vault_keys_ids" {
  description = "The IDs of the keys stored in the Key Vault created by the core module."
  value       = module.core.key_vault_keys_ids
}

output "key_vault_name" {
  description = "The name of the Key Vault created by the core module."
  value       = module.core.key_vault_name
}

output "key_vault_id" {
  description = "The ID of the Key Vault created by the core module."
  value       = module.core.key_vault_id
}

output "key_vault_secrets" {
  description = "The secrets stored in the Key Vault created by the core module."
  value       = module.core.key_vault_secrets
}

output "key_vault_secrets_ids" {
  description = "The IDs of the secrets stored in the Key Vault."
  value       = module.core.key_vault_secrets_ids
}

output "key_vault_uri" {
  description = "The URI of the Key Vault."
  value       = module.core.key_vault_uri
}

output "user_assigned_identity_client_id" {
  description = "The client ID of the user-assigned managed identity created or referenced by the core module."
  value       = module.core.user_assigned_identity_client_id
}

output "app_insights_id" {
  description = "The ID of the Application Insights component."
  value       = module.core.app_insights_id
}

output "app_insights_instrumentation_key" {
  description = "The instrumentation key of the Application Insights component."
  value       = module.core.app_insights_instrumentation_key
  sensitive   = true
}

output "app_insights_connection_string" {
  description = "The connection string of the Application Insights component."
  value       = module.core.app_insights_connection_string
  sensitive   = true
}

