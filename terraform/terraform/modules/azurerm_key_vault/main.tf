resource "azurerm_key_vault" "this" {
  name                        = var.name
  location                    = var.location
  resource_group_name         = var.resource_group_name
  tenant_id                   = var.tenant_id

  sku_name                        = var.sku_name
  soft_delete_retention_days      = var.soft_delete_retention_days
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  enabled_for_template_deployment = var.enabled_for_template_deployment
  public_network_access_enabled   = var.public_network_access_enabled
  purge_protection_enabled        = var.purge_protection_enabled

  dynamic "network_acls" {
    for_each = var.network_acls != null ? [var.network_acls] : []
    content {
      bypass              = network_acls.value.bypass
      default_action      = network_acls.value.default_action
      ip_rules            = network_acls.value.ip_rules
      virtual_network_subnet_ids = network_acls.value.virtual_network_subnet_ids
    }
  }

  tags = var.tags
}

###########################
## Legacy Access Policies #
###########################
resource "azurerm_key_vault_access_policy" "this" {
  for_each     = var.legacy_access_policies
  key_vault_id = azurerm_key_vault.this.id
  tenant_id    = coalesce(each.value.tenant_id, var.tenant_id)
  object_id    = each.value.object_id

  key_permissions         = each.value.key_permissions
  secret_permissions      = each.value.secret_permissions
  certificate_permissions = each.value.certificate_permissions
  storage_permissions     = each.value.storage_permissions
}

##########################
##### Keys ###############
##########################
resource "azurerm_key_vault_key" "keys" {
  for_each     = var.keys
  name         = each.key
  key_vault_id = azurerm_key_vault.this.id
  key_type     = each.value.key_type
  key_size     = each.value.key_size
  curve        = lookup(each.value, "curve", null)
  expiration_date = lookup(each.value, "expiration_date", null)
  not_before_date = lookup(each.value, "not_before_date", null)
  key_opts     = each.value.key_opts
}

##########################
###### Secrets ###########
##########################
resource "azurerm_key_vault_secret" "secrets" {
  for_each        = var.secrets
  name            = each.key
  value           = var.secrets_value[each.key]
  key_vault_id    = azurerm_key_vault.this.id
  content_type    = lookup(each.value, "content_type", null)
  expiration_date = lookup(each.value, "expiration_date", null)
  not_before_date = lookup(each.value, "not_before_date", null)
  tags            = lookup(each.value, "tags", null)
}

###########################
# RBAC Role Assignments ###
###########################
resource "azurerm_role_assignment" "rbac_roles" {
  for_each           = var.role_assignments
  scope              = azurerm_key_vault.this.id
  role_definition_id = each.value.role_definition_id
  principal_id       = each.value.principal_id
}

###########################
## Diagnostic Settings ####
###########################
resource "azurerm_monitor_diagnostic_setting" "diagnostic_setting" {
  for_each                   = var.diagnostic_settings
  name                       = each.key
  target_resource_id         = azurerm_key_vault.this.id
  log_analytics_workspace_id = each.value.workspace_id

  enabled_log {
    category = "AuditEvent"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}

###########################
########## Lock ###########
###########################
resource "azurerm_management_lock" "management_lock" {
  count      = var.lock != null ? 1 : 0
  name       = var.lock.name
  scope      = azurerm_key_vault.this.id
  lock_level = var.lock.level
  notes      = lookup(var.lock, "notes", null)
}
