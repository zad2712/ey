resource "azurerm_resource_group" "this" {
  name     = var.name
  location = var.location
  tags     = var.tags

  lifecycle {
    ignore_changes = [
      tags["created_date"],
      tags["created_by"]
    ]
  }
}

# Role Assignments for Resource Group
resource "azurerm_role_assignment" "this" {
  for_each = var.role_assignments

  scope                                  = azurerm_resource_group.this.id
  role_definition_id                     = can(regex("^[0-9a-fA-F-]{36}$", each.value.role_definition_id_or_name)) ? each.value.role_definition_id_or_name : null
  role_definition_name                   = can(regex("^[0-9a-fA-F-]{36}$", each.value.role_definition_id_or_name)) ? null : each.value.role_definition_id_or_name
  principal_id                           = each.value.principal_id
  description                            = each.value.description
  skip_service_principal_aad_check       = each.value.skip_service_principal_aad_check
  condition                              = each.value.condition
  condition_version                      = each.value.condition_version
  delegated_managed_identity_resource_id = each.value.delegated_managed_identity_resource_id
}

# Management Lock for Resource Group
resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0

  name       = coalesce(var.lock.name, "${var.name}-${var.lock.kind}-lock")
  scope      = azurerm_resource_group.this.id
  lock_level = var.lock.kind
  notes      = var.lock.notes

  depends_on = [
    azurerm_role_assignment.this
  ]
}
