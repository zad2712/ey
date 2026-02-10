################
### GENERAL ####
################
hidden_title_tag_env = "UAT-Lab"
env = "UAT"

######################
### SHARED DATA ######
######################
resource_group_name_admin                 = "USEUEYXU01RSG01"
resource_group_name_app                   = "USEUEYXU01RSG02"
log_analytics_workspace_admin_name        = "USEUEYXU01LAW01"
log_analytics_workspace_app_name          = "USEUEYXU01LAW02"
vnet_admin_name_01                        = "USEUEYXU01VNT01" # Admin VNET
vnet_app_name_01                          = "USEUEYXU01VNT02" # Frontend VNET
vnet_app_name_02                          = "USEUEYXU01VNT03" # Backend VNET
subnet1_name_app_02                       = "USEUEYXU01SBN06" # Subnet for Backend Layer
kv_shared_app                             = "USEUEYXU01AKV02" # keyvault app

#####################################
#### REDIS CACHE ####################
#####################################
redis_cache_name                = "USEUEYXU01RDC01"
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
servicebus_namespace_name    = "USEUEYXU01SB01"
servicebus_sku               = "Premium"
servicebus_capacity          = 1
premium_messaging_partitions = 1
servicebus_queues = [

  {
    name= "agentpromotion"
  },
  {
    name= "geney-docprocessor"
  },
  {
    name = "agenttestactivequeue"
    lock_duration = "PT5M"  # 5 minutes
  },
  {
    name = "agenttestwaitqueue"
    lock_duration = "PT1M"  # 1 minute
  }
]

#####################################
#### COSMOS DB ######################
#####################################
cosmosdb_account_name = "useueyxu01cdb01"

######################################
#### COSMOS DB POSTGRESQL CLUSTER ####
######################################
cosmosdb_postgresql_name                         = "useueyxu01cdb02"
cosmosdb_postgresql_administrator_login          = "citus"
cosmosdb_postgresql_administrator_login_password = "P@ssw0rd1234!!"

######################################
#### PRIVATE ENDPOINTS NAMES #########
######################################
service_bus_pep_name         = "USEUEYXU01PEP01"
redis_cache_pep_name         = "USEUEYXU01PEP02"
cosmosdb_pep_name            = "USEUEYXU01PEP03"
cosmosdb_postgresql_pep_name = "USEUEYXU01PEP04"