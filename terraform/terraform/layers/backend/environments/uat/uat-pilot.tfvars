################
### GENERAL ####
################
hidden_title_tag_env = "UAT-Pilot"
env = "UAT"

######################
### SHARED DATA ######
######################
resource_group_name_admin                 = "USEUEYXU01RSG01"
resource_group_name_app                   = "USEUEYXU01RSG03"
log_analytics_workspace_admin_name        = "USEUEYXU01LAW01"
log_analytics_workspace_app_name          = "USEUEYXU01LAW03"
vnet_admin_name_01                        = "USEUEYXU01VNT01" # Admin VNET
vnet_app_name_01                          = "USEUEYXU01VNT04" # Frontend VNET
vnet_app_name_02                          = "USEUEYXU01VNT05" # Backend VNET
subnet1_name_app_02                       = "USEUEYXU01SBN12" # Subnet for Backend Layer
kv_shared_app                             = "USEUEYXU01AKV03" # keyvault app

#####################################
#### REDIS CACHE ####################
#####################################
redis_cache_name                = "USEUEYXU01RDC02"
redis_cache_capacity            = 1
redis_cache_family              = "C"
redis_cache_sku_name            = "Standard"
redis_cache_enable_non_ssl_port = false
redis_cache_minimum_tls_version = "1.2"
redis_cache_configuration = {
  maxmemory_policy = "volatile-lru"
}

#####################################
#### SERVICE BUS ####################
#####################################
servicebus_namespace_name    = "USEUEYXU01SB02"
servicebus_sku               = "Premium"
servicebus_capacity          = 1
premium_messaging_partitions = 1
servicebus_queues = [
  
  {
    name= "agentpromotion"
  },
  {
    name= "geney-docprocessor"
  }
]

#####################################
#### COSMOS DB ######################
#####################################
cosmosdb_account_name = "useueyxu01cdb03"

######################################
#### COSMOS DB POSTGRESQL CLUSTER ####
######################################
cosmosdb_postgresql_name                         = "useueyxu01cdb04"
cosmosdb_postgresql_administrator_login          = "citus"
cosmosdb_postgresql_administrator_login_password = "P@ssw0rd1234!!"

######################################
#### PRIVATE ENDPOINTS NAMES #########
######################################
service_bus_pep_name         = "USEUEYXU01PEP05"
redis_cache_pep_name         = "USEUEYXU01PEP06"
cosmosdb_pep_name            = "USEUEYXU01PEP07"
cosmosdb_postgresql_pep_name = "USEUEYXU01PEP08"