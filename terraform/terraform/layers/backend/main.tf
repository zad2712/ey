####################
#### SHARED DATA ###
####################
module "shared_data" {
  source                             = "../shared"
  resource_group_name_admin_dev      = local.resource_group_name_admin_dev
  private_dns_zones_names_backend    = local.private_dns_zones_names_backend
  resource_group_name_admin          = var.resource_group_name_admin
  resource_group_name_app            = var.resource_group_name_app
  log_analytics_workspace_app_name   = var.log_analytics_workspace_app_name
  log_analytics_workspace_admin_name = var.log_analytics_workspace_admin_name
  vnet_admin_name_01                 = var.vnet_admin_name_01 # Admin VNET
  vnet_app_name_01                   = var.vnet_app_name_01   # Frontend VNET
  subnet_app_name_01                 = var.subnet_app_name_01
  vnet_app_name_02                   = var.vnet_app_name_02 # Backend VNET
  subnet1_name_app_02                = var.subnet1_name_app_02
  kv_shared_app                      = var.kv_shared_app
  env                                 = var.env
  

  providers = {
    azurerm.dev_integration = azurerm.dev_integration
  }
}

#####################################
#### STORAGE ACCOUNT ################
#####################################
module "storage_account_admin_01" {
  count                           = var.storage_account_admin_01 != null ? 1 : 0
  source                          = "../../modules/storage_account"
  name                            = lower(var.storage_account_admin_01)
  location                        = module.shared_data.resource_group_admin[0].location
  resource_group_name             = module.shared_data.resource_group_admin[0].name
  account_tier                    = var.account_tier_storage_account_admin_01
  account_replication_type        = var.account_replication_type_storage_account_admin_01
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public_storage_account_admin_01
  log_analytics_workspace_id      = module.shared_data.law_shared_admin[0].id
  tags                            = local.merged_tags.storage_account_admin_tags
}

#####################################
#### STORAGE ACCOUNT APP 01 #########
#####################################
# Conditionally creates the storage account for the application.
# The storage account will be created if the `storage_account_app_01` variable is not null.
module "storage_account_app_01" {
  count                           = var.enable_storage_account_app_01 != null ? 1 : 0
  source                          = "../../modules/storage_account"
  name                            = lower(var.storage_account_app_01)
  location                        = module.shared_data.resource_group_app[0].location
  resource_group_name             = module.shared_data.resource_group_app[0].name
  account_tier                    = var.account_tier_storage_account_app_01
  account_replication_type        = var.account_replication_type_storage_account_app_01
  allow_nested_items_to_be_public = var.allow_nested_items_to_be_public_storage_account_app_01
  log_analytics_workspace_id      = module.shared_data.law_shared_app[0].id
  tags                            = local.merged_tags.storage_account_app_tags
}

#####################################
#### REDIS CACHE ####################
#####################################
module "redis_cache" {
  source                     = "../../modules/redis_cache"
  name                       = var.redis_cache_name
  location                   = module.shared_data.resource_group_app[0].location
  resource_group_name        = module.shared_data.resource_group_app[0].name
  capacity                   = var.redis_cache_capacity
  family                     = var.redis_cache_family
  sku_name                   = var.redis_cache_sku_name
  enable_non_ssl_port        = var.redis_cache_enable_non_ssl_port
  minimum_tls_version        = var.redis_cache_minimum_tls_version
  log_analytics_workspace_id = module.shared_data.law_shared_app[0].id
  tags                       = local.merged_tags.redis_tags
}

# Store Redis Connection String in Key Vault with custom format
# Format: rediss://:{primary_access_key}=@{hostname}:6380
resource "azurerm_key_vault_secret" "redis_connection_string" {
  name         = "Redis--ConnectionString--Custom"
  value        = "rediss://:${module.redis_cache.primary_access_key}=@${module.redis_cache.hostname}:6380"
  key_vault_id = module.shared_data.kv_shared_app[0].id
  content_type = "Redis Custom Connection String"
}


#####################################
#### SERVICE BUS ####################
#####################################

module "service_bus" {
  # Conditionally creates the resource. The resource will be created if the `servicebus_namespace_name` variable is not null.
  # If `servicebus_namespace_name` is null, the count will be 0, and the resource will not be created.
  count = var.servicebus_namespace_name != null ? 1 : 0

  source                       = "../../modules/service_bus"
  namespace_name               = var.servicebus_namespace_name
  location                     = module.shared_data.resource_group_app[0].location
  resource_group_name          = module.shared_data.resource_group_app[0].name
  sku                          = var.servicebus_sku
  capacity                     = var.servicebus_capacity
  premium_messaging_partitions = var.premium_messaging_partitions
  queues                       = var.servicebus_queues
  log_analytics_workspace_id   = module.shared_data.law_shared_app[0].id
  tags                         = local.merged_tags.servicebus_tags
  

}
#####################################
#### COSMOS DB ######################
#####################################

module "cosmosdb" {
  # Conditionally creates the resource. The resource will be created if the `cosmosdb_account_name` variable is not null.
  # If `cosmosdb_account_name` is null, the count will be 0, and the resource will not be created.
  count = var.cosmosdb_account_name != null ? 1 : 0

  source                     = "../../modules/cosmosdb"
  account_name               = var.cosmosdb_account_name
  location                   = module.shared_data.resource_group_app[0].location
  resource_group_name        = module.shared_data.resource_group_app[0].name
  log_analytics_workspace_id = module.shared_data.law_shared_app[0].id
  tags                       = local.merged_tags.cosmosdb_tags
}


#####################################
#### COSMOS DB POSTGRESQL ###########
#####################################

module "cosmosdb_postgresql" {
  # Conditionally creates the resource. The resource will be created if the `cosmosdb_postgresql_name` variable is not null.
  # If `cosmosdb_postgresql_name` is null, the count will be 0, and the resource will not be created.
  count = var.cosmosdb_postgresql_name != null ? 1 : 0

  source                       = "../../modules/cosmosdb_postgresql"
  name                         = var.cosmosdb_postgresql_name
  location                     = module.shared_data.resource_group_app[0].location
  resource_group_name          = module.shared_data.resource_group_app[0].name
  administrator_login          = var.cosmosdb_postgresql_administrator_login
  administrator_login_password = module.random_pass_keyvault.secret_id
  database_name                = var.cosmosdb_postgresql_database_name
  log_analytics_workspace_id   = module.shared_data.law_shared_app[0].id
  tags                         = local.merged_tags.cosmosdb_postgresql_tags
}


#######################################################
##### Random PASS KEYVAULT for COSMOSDB POSTGRESQL ####
#######################################################



module "random_pass_keyvault" {
  source = "../../modules/random_pass_keyvault"

  key_vault_id = module.shared_data.kv_shared_app[0].id
  

  secret_name     = "cosmosbdb-postgresql-admin-password"
  password_length = 24
}

###########################
#### PRIVATE ENDPOINTS ####
###########################
module "backend_private_endpoints" {
  source              = "../../modules/private_endpoint"
  for_each            = local.backend_private_endpoints
  name                = each.value.name
  location            = module.shared_data.resource_group_app[0].location
  resource_group_name = module.shared_data.resource_group_app[0].name
  subnet_id           = each.value.subnet_id
  connection_name     = each.value.connection_name
  resource_id         = each.value.resource_id
  subresource_names   = each.value.subresource_names
  private_dns_zone_id = each.value.private_dns_zone_id
  tags                = each.value.tags
}