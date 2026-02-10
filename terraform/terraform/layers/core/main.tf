module "shared_data" {
  source = "../shared"

  env                       = var.env
  resource_group_name_admin = var.resource_group_name_admin
  resource_group_name_app   = var.resource_group_name_app
  vnet_admin_name_01        = var.vnet_admin_name_01
  subnet_admin_name_01      = var.subnet_admin_name_01
  vnet_app_name_01          = var.vnet_app_name_01
  subnet_app_name_01        = var.subnet_app_name_01
  subnet_app_name_02        = var.subnet_app_name_02
  subnet_app_name_03        = var.subnet_app_name_03
  vnet_app_name_02          = var.vnet_app_name_02
  subnet1_name_app_02       = var.subnet1_name_app_02
  subnet2_name_app_02       = var.subnet2_name_app_02
  subnet3_name_app_02       = var.subnet3_name_app_02

  # Dev-specific admin resources for Private DNS (cross-subscription)
  resource_group_name_admin_dev = var.resource_group_name_admin_dev
  vnet_name_admin_dev           = var.vnet_name_admin_dev

  providers = {
    azurerm.dev_integration = azurerm.dev_integration
  }
}



module "core" {
  source                                    = "../../modules/core"
  resource_group_name                       = var.resource_group_name
  location                                  = var.location
  resource_group_tags                       = var.resource_group_tags
  log_analytics_workspace_name              = var.log_analytics_workspace_name
  log_analytics_workspace_tags              = var.log_analytics_workspace_tags
  key_vault_diagnostic_settings             = var.key_vault_diagnostic_settings
  key_vault_name                            = var.key_vault_name
  key_vault_legacy_access_policies          = merge(var.key_vault_legacy_access_policies, local.key_vault_legacy_access_policies)
  key_vault_enabled_for_template_deployment = var.key_vault_enabled_for_template_deployment
  resource_group_role_assignments           = merge(var.resource_group_role_assignments, local.default_role_assignments)
  enabled_for_deployment                    = var.enabled_for_deployment
  enabled_for_disk_encryption               = var.enabled_for_disk_encryption
  key_vault_public_network_access_enabled   = var.key_vault_public_network_access_enabled
  key_vault_tags                            = var.key_vault_tags
  key_vault_network_acls                    = local.key_vault_network_acls_final

  user_assigned_identity_name               = var.user_assigned_identity_name
  user_assigned_identity_tags               = var.user_assigned_identity_tags
  app_insights_name                         = var.app_insights_name
  app_insights_application_type             = var.app_insights_application_type
  app_insights_retention_in_days            = var.app_insights_retention_in_days
  app_insights_sampling_percentage          = var.app_insights_sampling_percentage
  app_insights_tags                         = var.app_insights_tags
  workbook_display_name                     = var.workbook_display_name
  workbook_tags                             = var.workbook_tags
  log_analytics_workspace_retention_in_days = local.log_analytics_workspace_retention_in_days
  tags                                      = var.tags
}



resource "azurerm_management_lock" "core_resource_group_delete" {
  count      = var.create_delete_lock ? 1 : 0
  name       = var.resource_group_name_app
  scope      = module.core.resource_group_id
  lock_level = "CanNotDelete"
  notes      = "Enforced by Core layer when environment "
}