




resource "random_password" "generated" {
  #for_each = toset(var.secret_name)
  length           = 12
  special          = true
}


resource "azurerm_key_vault_secret" "password" {
  #for_each = toset(var.secret_name)
  name         = var.secret_name
  value        = random_password.generated.result
  key_vault_id = var.key_vault_id
  content_type = "text/plain"

  lifecycle {
    ignore_changes = [value]
  }
}