#### Resource group ##########
# For QA, UAT, PROD - Admin RG is in default subscription
# For DEV - uses shared_rg_admin_dev (defined later with dev_integration provider)
data "azurerm_resource_group" "shared_rg_admin" {
  count = var.env != null && !contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) && var.resource_group_name_admin != null ? 1 : 0
  name  = var.resource_group_name_admin
}

data "azurerm_resource_group" "shared_rg_app" {
  count = var.resource_group_name_app != null ? 1 : 0
  name  = var.resource_group_name_app
}

data "azurerm_resource_group" "shared_rg_app_pilot" {
  count = var.resource_group_name_app_pilot != null ? 1 : 0
  name  = var.resource_group_name_app_pilot
}

data "azurerm_resource_group" "shared_rg_app_prod" {
  count = var.resource_group_name_app_prod != null ? 1 : 0
  name  = var.resource_group_name_app_prod
}



#### Key vaults ######
data "azurerm_key_vault" "shared_kv_admin" {
  count               = var.kv_shared_admin != null ? 1 : 0
  name                = var.kv_shared_admin
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

data "azurerm_key_vault" "shared_kv_app" {
  count               = var.kv_shared_app != null && length(data.azurerm_resource_group.shared_rg_app) > 0 ? 1 : 0
  name                = var.kv_shared_app
  resource_group_name = data.azurerm_resource_group.shared_rg_app[0].name
}

data "azurerm_key_vault_secret" "storage_connection_string" {
  count        = var.kv_secret_storage_connection_string_name != null ? 1 : 0
  name         = var.kv_secret_storage_connection_string_name
  key_vault_id = data.azurerm_key_vault.shared_kv_app[0].id
}

#### Log analytics workspace #######
data "azurerm_log_analytics_workspace" "shared_admin_law" {
  count               = var.log_analytics_workspace_admin_name != null ? 1 : 0
  name                = var.log_analytics_workspace_admin_name
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}


data "azurerm_log_analytics_workspace" "shared_app_law" {
  count               = var.log_analytics_workspace_app_name != null ? 1 : 0
  name                = var.log_analytics_workspace_app_name
  resource_group_name = data.azurerm_resource_group.shared_rg_app[0].name
}

data "azurerm_application_insights" "shared_app_insights" {
  count               = var.app_insights_name != null && var.app_insights_name != "" ? 1 : 0
  name                = var.app_insights_name
  resource_group_name = data.azurerm_resource_group.shared_rg_app[0].name
}

# Optional Application Insights for Pilot environment
data "azurerm_application_insights" "shared_app_insights_app_pilot" {
  count               = var.app_insights_app_pilot_name != null && var.app_insights_app_pilot_name != "" ? 1 : 0
  name                = var.app_insights_app_pilot_name
  resource_group_name = data.azurerm_resource_group.shared_rg_app_pilot[0].name
}

# Optional Application Insights for Prod environment
data "azurerm_application_insights" "shared_app_insights_app_prod" {
  count               = var.app_insights_app_prod_name != null && var.app_insights_app_prod_name != "" ? 1 : 0
  name                = var.app_insights_app_prod_name
  resource_group_name = data.azurerm_resource_group.shared_rg_app_prod[0].name
}

#### vnets #####
# Admin VNet for DEV environments (dev_integration subscription, RG: USEDCXS05HRSG01)
data "azurerm_virtual_network" "shared_vnet_admin_01_dev" {
  provider            = azurerm.dev_integration
  count               = var.env != null && contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) && var.vnet_admin_name_01 != null ? 1 : 0
  name                = var.vnet_admin_name_01
  resource_group_name = "USEDCXS05HRSG01"  # Admin RG in dev_integration subscription
}

# Admin VNet for QA/UAT/PROD environments (default subscription)
data "azurerm_virtual_network" "shared_vnet_admin_01" {
  count               = var.env != null && !contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) && var.vnet_admin_name_01 != null && local.shared_rg_admin_name != null ? 1 : 0
  name                = var.vnet_admin_name_01
  resource_group_name = local.shared_rg_admin_name
}

#### vnet app_01 (frontend) #####
data "azurerm_virtual_network" "shared_vnet_app_01" {
  count               = var.vnet_app_name_01 != null ? 1 : 0
  name                = var.vnet_app_name_01
  resource_group_name = data.azurerm_resource_group.shared_rg_app[0].name
}

#### vnet app_02 (backend) #####
data "azurerm_virtual_network" "shared_vnet_app_02" {
  count               = var.vnet_app_name_02 != null ? 1 : 0
  name                = var.vnet_app_name_02
  resource_group_name = data.azurerm_resource_group.shared_rg_app[0].name
}

#### subnets ####
# Admin Subnet for DEV environments (dev_integration subscription)
data "azurerm_subnet" "shared_subnet_admin_01_dev" {
  provider             = azurerm.dev_integration
  count                = var.env != null && contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) && var.subnet_admin_name_01 != null && length(data.azurerm_virtual_network.shared_vnet_admin_01_dev) > 0 ? 1 : 0
  name                 = var.subnet_admin_name_01
  virtual_network_name = data.azurerm_virtual_network.shared_vnet_admin_01_dev[0].name
  resource_group_name  = "USEDCXS05HRSG01"  # Admin RG in dev_integration subscription
}

# Admin Subnet for QA/UAT/PROD environments (default subscription)
data "azurerm_subnet" "shared_subnet_admin_01" {
  count                = var.env != null && !contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) && var.subnet_admin_name_01 != null && length(data.azurerm_virtual_network.shared_vnet_admin_01) > 0 ? 1 : 0
  name                 = var.subnet_admin_name_01
  virtual_network_name = data.azurerm_virtual_network.shared_vnet_admin_01[0].name
  resource_group_name  = local.shared_rg_admin_name
}

#### subnets app_01 (frontend) ####
data "azurerm_subnet" "shared_subnet_app_01" {
  count                = var.subnet_app_name_01 != null ? 1 : 0
  name                 = var.subnet_app_name_01
  virtual_network_name = data.azurerm_virtual_network.shared_vnet_app_01[0].name
  resource_group_name  = data.azurerm_resource_group.shared_rg_app[0].name
}

data "azurerm_subnet" "shared_subnet_app_02" {
  count                = var.subnet_app_name_02 != null ? 1 : 0
  name                 = var.subnet_app_name_02
  virtual_network_name = data.azurerm_virtual_network.shared_vnet_app_01[0].name
  resource_group_name  = data.azurerm_resource_group.shared_rg_app[0].name
}

data "azurerm_subnet" "shared_subnet_app_03" {
  count                = var.subnet_app_name_03 != null ? 1 : 0
  name                 = var.subnet_app_name_03
  virtual_network_name = data.azurerm_virtual_network.shared_vnet_app_01[0].name
  resource_group_name  = data.azurerm_resource_group.shared_rg_app[0].name
}

#### subnets app_02 (backend) ####
data "azurerm_subnet" "shared_subnet1_name_app_02" {
  count                = var.subnet1_name_app_02 != null ? 1 : 0
  name                 = var.subnet1_name_app_02
  virtual_network_name = data.azurerm_virtual_network.shared_vnet_app_02[0].name
  resource_group_name  = data.azurerm_resource_group.shared_rg_app[0].name
}

data "azurerm_subnet" "shared_subnet2_name_app_02" {
  count                = var.subnet2_name_app_02 != null ? 1 : 0
  name                 = var.subnet2_name_app_02
  virtual_network_name = data.azurerm_virtual_network.shared_vnet_app_02[0].name
  resource_group_name  = data.azurerm_resource_group.shared_rg_app[0].name
}

data "azurerm_subnet" "shared_subnet3_name_app_02" {
  count                = var.subnet3_name_app_02 != null ? 1 : 0
  name                 = var.subnet3_name_app_02
  virtual_network_name = data.azurerm_virtual_network.shared_vnet_app_02[0].name
  resource_group_name  = data.azurerm_resource_group.shared_rg_app[0].name
}

#### Storage account ######

data "azurerm_storage_account" "shared_storage_account_app_01" {
  count               = var.storage_account_app_name_01 != null ? 1 : 0
  name                = lower(var.storage_account_app_name_01)
  resource_group_name = data.azurerm_resource_group.shared_rg_app[0].name
}
################################
#### PRIVATE DNS ZONES #########
################################
#### Private DNS Zones - Dev Integration Subscription ####
data "azurerm_resource_group" "shared_rg_admin_dev" {
  provider = azurerm.dev_integration
  count    = var.resource_group_name_admin_dev != null && var.resource_group_name_admin_dev != "" ? 1 : 0
  name     = var.resource_group_name_admin_dev
}

# Storage Blob Private DNS Zone - Dev Integration
data "azurerm_private_dns_zone" "dev_storage_blob_private_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_app, "storage_blob", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "storage_blob", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

# Storage Queue Private DNS Zone - Dev Integration
data "azurerm_private_dns_zone" "dev_storage_queue_private_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_app, "storage_queue", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "storage_queue", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

# Storage Table Private DNS Zone - Dev Integration
data "azurerm_private_dns_zone" "dev_storage_table_private_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_app, "storage_table", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "storage_table", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

# App Service Private DNS Zone - Dev Integration
data "azurerm_private_dns_zone" "dev_app_service_private_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_app, "app_service", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "app_service", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

# SignalR Private DNS Zone - Dev Integration
data "azurerm_private_dns_zone" "dev_signalr_private_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_app, "signalr", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "signalr", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

# Speech Private DNS Zone - Dev Integration
data "azurerm_private_dns_zone" "dev_speech_private_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_app, "speech", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "speech", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

# Document Intelligence Private DNS Zone - Dev Integration
data "azurerm_private_dns_zone" "dev_document_intelligence_private_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_app, "document_intelligence", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "document_intelligence", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

data "azurerm_private_dns_zone" "dev_container_registry_private_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_app, "container_registry", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "container_registry", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

# Container App Environment Private DNS Zone - Dev Integration
data "azurerm_private_dns_zone" "dev_container_app_environment_private_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_app, "container_app_environment", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "container_app_environment", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

# QA App Layer - Private DNS Zones (All)
data "azurerm_private_dns_zone" "qa_app_dns_zones" {
  for_each = var.env == "QA" && length(data.azurerm_resource_group.shared_rg_app) > 0 ? local.qa_app_dns_zone_map : {}
  name                = each.value
  resource_group_name = data.azurerm_resource_group.shared_rg_app[0].name
}

# QA Backend Layer - Private DNS Zones (All)
data "azurerm_private_dns_zone" "qa_backend_dns_zones" {
  for_each = var.env == "QA" && length(data.azurerm_resource_group.shared_rg_app) > 0 ? local.qa_backend_dns_zone_map : {}
  name                = each.value
  resource_group_name = data.azurerm_resource_group.shared_rg_app[0].name
}

# Redis Cache Private DNS Zone - Dev Integration
data "azurerm_private_dns_zone" "dev_redis_cache_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_backend, "redis", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_backend, "redis", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

# Service Bus Private DNS Zone - Dev Integration
data "azurerm_private_dns_zone" "dev_servicebus_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_backend, "servicebus", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_backend, "servicebus", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

# CosmosDB Private DNS Zone - Dev Integration
data "azurerm_private_dns_zone" "dev_cosmosdb_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_backend, "cosmosdb", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_backend, "cosmosdb", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

# CosmosDB PostgreSQL Private DNS Zone - Dev Integration
data "azurerm_private_dns_zone" "dev_cosmosdb_postgresql_dns_zone" {
  provider            = azurerm.dev_integration
  count               = lookup(var.private_dns_zones_names_backend, "postgresql", null) != null && length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? 1 : 0
  name                = lookup(var.private_dns_zones_names_backend, "postgresql", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin_dev[0].name
}

### Backend Layer - Private DNS Zones
# Redis Cache Private DNS Zone
data "azurerm_private_dns_zone" "redis_cache_dns_zone" {
  count               = lookup(var.private_dns_zones_names_backend, "redis", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_backend, "redis", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

# Service Bus Private DNS Zone
data "azurerm_private_dns_zone" "servicebus_dns_zone" {
  count               = lookup(var.private_dns_zones_names_backend, "servicebus", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_backend, "servicebus", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

# CosmosDB Private DNS Zone
data "azurerm_private_dns_zone" "cosmosdb_dns_zone" {
  count               = lookup(var.private_dns_zones_names_backend, "cosmosdb", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_backend, "cosmosdb", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

# CosmosDB PostgreSQL Private DNS Zone
data "azurerm_private_dns_zone" "cosmosdb_postgresql_dns_zone" {
  count               = lookup(var.private_dns_zones_names_backend, "postgresql", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_backend, "postgresql", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

### App Layer - Private DNS Zones
# Storage Blob Private DNS Zone
data "azurerm_private_dns_zone" "storage_blob_private_dns_zone" {
  # Only attempt admin RG lookups when we're NOT in QA (QA uses app RG)
  count               = lookup(var.private_dns_zones_names_app, "storage_blob", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "storage_blob", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

# Storage Queue Private DNS Zone
data "azurerm_private_dns_zone" "storage_queue_private_dns_zone" {
  # Only attempt admin RG lookups when we're NOT in QA (QA uses app RG)
  count               = lookup(var.private_dns_zones_names_app, "storage_queue", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "storage_queue", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

# Storage Table Private DNS Zone
data "azurerm_private_dns_zone" "storage_table_private_dns_zone" {
  # Only attempt admin RG lookups when we're NOT in QA (QA uses app RG)
  count               = lookup(var.private_dns_zones_names_app, "storage_table", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "storage_table", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

# App Service Private DNS Zone
data "azurerm_private_dns_zone" "app_service_private_dns_zone" {
  # Only attempt admin RG lookups when we're NOT in QA (QA uses app RG)
  count               = lookup(var.private_dns_zones_names_app, "app_service", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "app_service", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

# SignalR Private DNS Zone
data "azurerm_private_dns_zone" "signalr_private_dns_zone" {
  # Only attempt admin RG lookups when we're NOT in QA (QA uses app RG)
  count               = lookup(var.private_dns_zones_names_app, "signalr", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "signalr", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

# Speech Private DNS Zone
data "azurerm_private_dns_zone" "speech_private_dns_zone" {
  # Only attempt admin RG lookups when we're NOT in QA (QA uses app RG)
  count               = lookup(var.private_dns_zones_names_app, "speech", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "speech", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

# Document Intelligence Private DNS Zone
data "azurerm_private_dns_zone" "document_intelligence_private_dns_zone" {
  # Only attempt admin RG lookups when we're NOT in QA (QA uses app RG)
  count               = lookup(var.private_dns_zones_names_app, "document_intelligence", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "document_intelligence", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

data "azurerm_private_dns_zone" "container_registry_private_dns_zone" {
  # Only attempt admin RG lookups when we're NOT in QA (QA uses app RG)
  count               = lookup(var.private_dns_zones_names_app, "container_registry", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "container_registry", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}

# Container App Environment Private DNS Zone - UAT and Prod
data "azurerm_private_dns_zone" "container_app_environment_private_dns_zone" {
  # Only attempt admin RG lookups when we're NOT in QA (QA uses app RG)
  count               = lookup(var.private_dns_zones_names_app, "container_app_environment", null) != null && length(data.azurerm_resource_group.shared_rg_admin) > 0 && var.env != "QA" ? 1 : 0
  name                = lookup(var.private_dns_zones_names_app, "container_app_environment", null)
  resource_group_name = data.azurerm_resource_group.shared_rg_admin[0].name
}