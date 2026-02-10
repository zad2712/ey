data "azurerm_client_config" "current" {}

##############################################
# Remote State Data Sources for Other Layers
##############################################

# Core Layer - Resource Groups, Key Vaults, Log Analytics, App Insights
data "terraform_remote_state" "core" {
  count   = var.backend_resource_group_name != null && var.backend_storage_account_name != null ? 1 : 0
  backend = "azurerm"

  config = {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = "layers/core/${lower(var.env)}/terraform.tfstate"
    subscription_id      = coalesce(var.backend_subscription_id, data.azurerm_client_config.current.subscription_id)
  }
}

# Network Layer - VNets and Subnets
data "terraform_remote_state" "network" {
  count   = var.backend_resource_group_name != null && var.backend_storage_account_name != null ? 1 : 0
  backend = "azurerm"

  config = {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = "layers/network/${lower(var.env)}/terraform.tfstate"
    subscription_id      = coalesce(var.backend_subscription_id, data.azurerm_client_config.current.subscription_id)
  }
}

# Admin Layer - Private DNS Zones (UAT and PROD only)
data "terraform_remote_state" "admin" {
  count   = contains(["UAT", "PROD"], var.env) && var.backend_resource_group_name != null && var.backend_storage_account_name != null ? 1 : 0
  backend = "azurerm"

  config = {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    # Admin layer state is shared across sub-environments (lab/pilot/prod) within UAT or PROD
    key             = "layers/admin/${lower(replace(var.env, "-", ""))}/terraform.tfstate"
    subscription_id = coalesce(var.backend_subscription_id, data.azurerm_client_config.current.subscription_id)
  }
}

##############################################
# Data Sources for Resources Outside Terraform
##############################################

# Admin Resource Group (outside TF) - For DEV environments
# This RG is in the dev_integration subscription (bcff8cd6-13ff-48f9-8a70-2e5478106b1a)
data "azurerm_resource_group" "admin_dev" {
  provider = azurerm.dev_integration
  count    = contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) && var.resource_group_name_admin != null ? 1 : 0
  name     = var.resource_group_name_admin
}

# Admin Resource Group (outside TF) - For QA, UAT, PROD environments
data "azurerm_resource_group" "admin" {
  count = !contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) && var.resource_group_name_admin != null ? 1 : 0
  name  = var.resource_group_name_admin
}

# Admin VNet (outside TF) - For DEV
# VNet is in USEDCXS05HRSG01 (admin RG), not USEDCXS05HRSG02 (DNS zones RG)
data "azurerm_virtual_network" "admin_vnet_dev" {
  provider            = azurerm.dev_integration
  count               = contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) && var.vnet_admin_name_01 != null ? 1 : 0
  name                = var.vnet_admin_name_01
  resource_group_name = "USEDCXS05HRSG01"  # Admin RG in dev_integration subscription
}

# Admin VNet (outside TF) - For QA, UAT, PROD
data "azurerm_virtual_network" "admin_vnet" {
  count               = !contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) && var.vnet_admin_name_01 != null && local.admin_rg_name != null ? 1 : 0
  name                = var.vnet_admin_name_01
  resource_group_name = local.admin_rg_name
}

# Admin Subnet (outside TF) - For DEV
# Subnet is in USEDCXS05HRSG01 (admin RG), not USEDCXS05HRSG02 (DNS zones RG)
data "azurerm_subnet" "admin_subnet_dev" {
  provider             = azurerm.dev_integration
  count                = contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) && var.subnet_admin_name_01 != null && local.admin_vnet_name != null ? 1 : 0
  name                 = var.subnet_admin_name_01
  virtual_network_name = local.admin_vnet_name
  resource_group_name  = "USEDCXS05HRSG01"  # Admin RG in dev_integration subscription
}

# Admin Subnet (outside TF) - For QA, UAT, PROD
data "azurerm_subnet" "admin_subnet" {
  count                = !contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) && var.subnet_admin_name_01 != null && local.admin_vnet_name != null && local.admin_rg_name != null ? 1 : 0
  name                 = var.subnet_admin_name_01
  virtual_network_name = local.admin_vnet_name
  resource_group_name  = local.admin_rg_name
}

##############################################
# Private DNS Zones for DEV/QA Environments (outside TF)
##############################################

# For DEV environment - DNS zones outside TF (RG: USEDCXS05HRSG02)
# These zones are in the dev_integration subscription (bcff8cd6-13ff-48f9-8a70-2e5478106b1a)
data "azurerm_private_dns_zone" "dev_dns_zones" {
  provider            = azurerm.dev_integration
  for_each            = contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) ? local.dev_dns_zone_names : {}
  name                = each.value
  resource_group_name = "USEDCXS05HRSG02"
}

# For QA environment - DNS zones outside TF (RG: USEQCXS05HRSG03)
data "azurerm_private_dns_zone" "qa_dns_zones" {
  for_each            = upper(var.env) == "QA" ? local.qa_dns_zone_names : {}
  name                = each.value
  resource_group_name = "USEQCXS05HRSG03"
}

##############################################
# App Layer Self-Reference (for session pool)
##############################################

# Use terraform_remote_state to fetch app service data from current app layer state (for refresh scenarios)
data "terraform_remote_state" "app" {
  count   = var.session_pool_enabled && var.backend_resource_group_name != null && var.backend_storage_account_name != null ? 1 : 0
  backend = "azurerm"

  config = {
    resource_group_name  = var.backend_resource_group_name
    storage_account_name = var.backend_storage_account_name
    container_name       = var.backend_container_name
    key                  = "layers/app/${lower(var.env)}/terraform.tfstate"
    subscription_id      = coalesce(var.backend_subscription_id, data.azurerm_client_config.current.subscription_id)
  }
}

