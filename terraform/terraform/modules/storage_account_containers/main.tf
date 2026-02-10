
resource "azurerm_storage_container" "container" {
  for_each             = toset(var.container_names)
  name                 = each.value
  storage_account_id   = var.storage_account_id
  
  container_access_type = "private" # # Only private access is allowed
}
