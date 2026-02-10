# Custom Resource Group Module
module "resource_group" {
  source           = "../resource_group"
  name             = var.resource_group_name
  location         = var.location
  role_assignments = var.resource_group_role_assignments
  lock             = var.lock
  tags             = merge(var.tags, var.resource_group_tags)
}

# AVM Log Analytics Workspace Module
# https://registry.terraform.io/modules/Azure/avm-res-operationalinsights-workspace/azurerm/latest
module "avm-res-operationalinsights-workspace" {
  source                                              = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version                                             = "0.4.2"
  name                                                = var.log_analytics_workspace_name
  location                                            = module.resource_group.resource.location
  resource_group_name                                 = module.resource_group.resource.name
  log_analytics_workspace_identity                    = var.log_analytics_workspace_identity
  log_analytics_workspace_retention_in_days           = var.log_analytics_workspace_retention_in_days
  log_analytics_workspace_sku                         = var.log_analytics_workspace_sku
  role_assignments                                    = var.log_analytics_workspace_role_assignments
  lock                                                = var.lock
  enable_telemetry                                    = var.enable_telemetry
  log_analytics_workspace_internet_ingestion_enabled  = var.log_analytics_workspace_internet_ingestion_enabled
  log_analytics_workspace_internet_query_enabled      = var.log_analytics_workspace_internet_query_enabled
  tags                                                = merge(var.tags, var.log_analytics_workspace_tags)
}

module "application_insights" {
  count = var.app_insights_name != null ? 1 : 0
  source                = "../application_insights"
  name                  = var.app_insights_name
  location              = module.resource_group.resource.location
  resource_group_name   = module.resource_group.resource.name
  workspace_id          = module.avm-res-operationalinsights-workspace.resource.id
  application_type      = var.app_insights_application_type
  retention_in_days     = var.app_insights_retention_in_days
  sampling_percentage   = var.app_insights_sampling_percentage
  tags                  = merge(var.tags, var.app_insights_tags)
}

# AVM Key Vault Module
# https://registry.terraform.io/modules/Azure/avm-res-keyvault-vault/azurerm/latest
data "azurerm_client_config" "current" {
  # This data source is used to get the current Azure client configuration
}

locals {
  key_vault_diagnostic_settings_final = {
    for k, v in var.key_vault_diagnostic_settings : k => {
      workspace_id = coalesce(
        try(v.workspace_resource_id, null),
        module.avm-res-operationalinsights-workspace.resource.id
      )

      logs = [
        for category in v.log_categories : {
          category = category
          enabled  = true
          retention_policy = {
            enabled = true
            days    = v.retention_days
          }
        }
      ]

      metrics = [
        for category in v.metric_categories : {
          category = category
          enabled  = true
          retention_policy = {
            enabled = false
            days    = 0
          }
        }
      ]
    }
  }
}

module "avm-res-keyvault-vault" {
  source = "./../azurerm_key_vault"

  name                            = var.key_vault_name
  location                        = module.resource_group.resource.location
  resource_group_name             = module.resource_group.resource.name
  tenant_id                       = data.azurerm_client_config.current.tenant_id
  diagnostic_settings             = local.key_vault_diagnostic_settings_final
  enabled_for_template_deployment = var.key_vault_enabled_for_template_deployment
  enabled_for_deployment          = var.enabled_for_deployment
  enabled_for_disk_encryption     = var.enabled_for_disk_encryption
  keys                            = var.key_vault_keys
  secrets                         = var.key_vault_secrets
  secrets_value                   = var.key_vault_secrets_value
  network_acls                    = var.key_vault_network_acls
  public_network_access_enabled   = var.key_vault_public_network_access_enabled
  purge_protection_enabled        = var.key_vault_purge_protection_enabled
  sku_name                        = var.key_vault_sku_name
  soft_delete_retention_days      = var.key_vault_soft_delete_retention_days
  role_assignments                = var.key_vault_role_assignments
  legacy_access_policies          = var.key_vault_legacy_access_policies
  tags                            = merge(var.tags, var.key_vault_tags)
}

# Generate a random UUID for the workbook name
resource "random_uuid" "workbook" {}

# Azure Workbook
resource "azurerm_application_insights_workbook" "this" {
  count = var.app_insights_name != null && var.workbook_display_name != null ? 1 : 0

  name                = random_uuid.workbook.result
  resource_group_name = module.resource_group.resource.name
  location            = module.resource_group.resource.location
  source_id           = lower(module.application_insights[0].id)
  display_name        = var.workbook_display_name
  category            = "workbook"
  data_json           = <<JSON
    {
      "version": "1.0",
      "items": []
    }
    JSON
  tags                = merge(var.tags, var.workbook_tags)

  lifecycle {
    ignore_changes = [data_json]
  }
}


# Azure User Assigned Managed Identity
# Required for environments with Skills Plugins (Dev-1, Dev/Dev-Integration, and higher environments)
# Skills Plugins use Azure Container Apps (ACA) to pull images from ACR using Managed Identity
# instead of ACR admin credentials. Not required for dev2/dev3 as they don't have Skills Plugins.
module "avm-res-userassignedidentity" {
  count                   = var.user_assigned_identity_name != null ? 1 : 0
  source                  = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version                 = "0.3.4"
  name                    = var.user_assigned_identity_name
  location                = module.resource_group.resource.location
  resource_group_name     = module.resource_group.resource.name

  lock                    = var.lock
  enable_telemetry        = var.enable_telemetry
  tags                    = merge(var.tags, var.user_assigned_identity_tags)
}