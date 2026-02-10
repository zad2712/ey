output "key_vault_keys" {
  description = "The keys stored in the Key Vault created by the module."
  value = {
    for k, v in azurerm_key_vault_key.keys :
    k => {
      id      = v.id
      name    = v.name
      version = v.version
    }
  }
}

output "key_vault_keys_ids" {
  description = "The IDs of the keys stored in the Key Vault created by the module."
  value = {
    for k, v in azurerm_key_vault_key.keys :
    k => v.id
  }
}

output "key_vault_name" {
  description = "The name of the Key Vault created by the module."
  value       = azurerm_key_vault.this.name
}

output "key_vault_id" {
  description = "The ID of the Key Vault created by the module."
  value       = azurerm_key_vault.this.id
}

output "key_vault_secrets" {
  description = "The secrets stored in the Key Vault created by the module."
  value = {
    for s, v in azurerm_key_vault_secret.secrets :
    s => {
      id      = v.id
      name    = v.name
      version = v.version
    }
  }
}

output "key_vault_secrets_resource_ids" {
  description = "The IDs of the secrets stored in the Key Vault created by the module."
  value = {
    for s, v in azurerm_key_vault_secret.secrets :
    s => v.id
  }
}

output "key_vault_uri" {
  description = "The URI of the Key Vault created by the module."
  value       = azurerm_key_vault.this.vault_uri
}
