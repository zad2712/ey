# output "secret_id" {
#   value = azurerm_key_vault_secret.this.id
#   description = "The ID of the Key Vault Secret containing the generated password."
# }



output "secret_id" {
 value = azurerm_key_vault_secret.password.id
}
# output "secret_name" {
#   value = azurerm_key_vault_secret.this.name
# }

# output "secret_id" {
#   value = azurerm_key_vault_secret.this.id
# }

# output "generated_password" {
#   value     = random_password.this.result
#   sensitive = true
# }