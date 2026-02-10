################
### GENERAL ####
################
# tags = {
#   DEPLOYMENT_ID = "EYXP01"
#   ENGAGEMENT_ID = "I-69197406"
#   OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
#   ENVIRONMENT   = "Production"
# }
hidden_title_tag_env = "Prod-Lab"
env = "PROD"

######################
### SHARED DATA ######
######################
resource_group_name_admin                 = "USEPEYXP01RSG01"
resource_group_name_app                   = "USEPEYXP01RSG02"
log_analytics_workspace_admin_name        = "USEPEYXP01LAW01"
log_analytics_workspace_app_name          = "USEPEYXP01LAW02"
vnet_admin_name_01                        = "USEPEYXP01VNT01" # Admin VNET
vnet_app_name_01                          = "USEPEYXP01VNT02" # Frontend VNET
vnet_app_name_02                          = "USEPEYXP01VNT03" # Backend VNET
subnet1_name_app_02                       = "USEPEYXP01SBN06" # Subnet for Backend Layer
kv_shared_app                             = "USEPEYXP01AKV02" # keyvault app

#####################################
#### REDIS CACHE ####################
#####################################
redis_cache_name                = "USEPEYXP01RDC02"
redis_cache_capacity            = 1
redis_cache_family              = "C"
redis_cache_sku_name            = "Standard"
redis_cache_enable_non_ssl_port = false
redis_cache_minimum_tls_version = "1.2"
redis_cache_configuration = {
  maxmemory_policy = "volatile-lru"
}
redis_cache_tags = {
  "ROLE_PURPOSE" =  "EYX - Prod-Lab - Redis Cache"
}

#####################################
#### SERVICE BUS ####################
#####################################
servicebus_namespace_name    = "USEPEYXP01SB02"
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


servicebus_tags = {
  "hidden-title" = "EYX - Prod-Lab - Service Bus",
  "ROLE_PURPOSE" =  "EYX - Prod-Lab - Service Bus"

}

#####################################
#### COSMOS DB ######################
#####################################
cosmosdb_account_name = "usepeyxp01cdb03"
cosmosdb_tags = {
  "hidden-title" = "EYX - Prod-Lab - Cosmos DB NoSQL",
  "ROLE_PURPOSE" =  "EYX - Prod-Lab - Cosmos DB NoSQL"
}

######################################
#### COSMOS DB POSTGRESQL CLUSTER ####
######################################
cosmosdb_postgresql_name                         = "usepeyxp01cdb04"
cosmosdb_postgresql_administrator_login          = "citus"
cosmosdb_postgresql_administrator_login_password = "P@ssw0rd1234!!"
cosmosdb_postgresql_tags = {
  "hidden-title" = "EYX - Prod-Lab - PostgreSQL",
  "ROLE_PURPOSE" =  "EYX - Prod-Lab - PostgreSQL"
}

######################################
#### PRIVATE ENDPOINTS NAMES #########
######################################
service_bus_pep_name         = "USEPEYXP01PEP01"
redis_cache_pep_name         = "USEPEYXP01PEP02"
cosmosdb_pep_name            = "USEPEYXP01PEP03"
cosmosdb_postgresql_pep_name = "USEPEYXP01PEP04"