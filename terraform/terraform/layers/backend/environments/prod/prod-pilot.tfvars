################
### GENERAL ####
################
# tags = {
#   DEPLOYMENT_ID = "EYXP01"
#   ENGAGEMENT_ID = "I-69197406"
#   OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
#   ENVIRONMENT   = "Production"
# }
hidden_title_tag_env = "Prod-Pilot"
env = "PROD"

######################
### SHARED DATA ######
######################
# DEV doesn't use admin resources - these will be automatically ignored by the shared module
resource_group_name_admin                 = "USEPEYXP01RSG01"
resource_group_name_app                   = "USEPEYXP01RSG03"
log_analytics_workspace_admin_name        = "USEPEYXP01LAW01"
log_analytics_workspace_app_name          = "USEPEYXP01LAW03"
vnet_admin_name_01                        = "USEPEYXP01VNT01" # Admin VNET
vnet_app_name_01                          = "USEPEYXP01VNT04" # Frontend VNET
vnet_app_name_02                          = "USEPEYXP01VNT05" # Backend VNET
subnet1_name_app_02                       = "USEPEYXP01SBN12" # Subnet for Backend Layer
kv_shared_app                             = "USEPEYXP01AKV03"

#####################################
#### REDIS CACHE ####################
#####################################
redis_cache_name                = "USEPEYXP01RDC03"
redis_cache_capacity            = 1
redis_cache_family              = "C"
redis_cache_sku_name            = "Standard"
redis_cache_enable_non_ssl_port = false
redis_cache_minimum_tls_version = "1.2"
redis_cache_configuration = {
  maxmemory_policy = "volatile-lru"
}
redis_cache_tags = {
  "hidden-title" = "EYX - Prod-Pilot - Redis Cache",
  "ROLE_PURPOSE" =  "EYX - Prod-Pilot - Redis Cache"
}

#####################################
#### SERVICE BUS ####################
#####################################
servicebus_namespace_name    = "USEPEYXP01SB03"
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
servicebus_tags = {
  "hidden-title" = "EYX - Prod-Pilot - Service Bus",
  "ROLE_PURPOSE" =  "EYX - Prod-Pilot - Service Bus"
}

#####################################
#### COSMOS DB ######################
#####################################
cosmosdb_account_name = "usepeyxp01cdb05"
cosmosdb_tags = {
  "hidden-title" = "EYX - Prod-Pilot - Cosmos DB NoSQL",
  "ROLE_PURPOSE" =  "EYX - Prod-Pilot - Cosmos DB NoSQL"
}

######################################
#### COSMOS DB POSTGRESQL CLUSTER ####
######################################
cosmosdb_postgresql_name                         = "usepeyxp01cdb06"
cosmosdb_postgresql_administrator_login          = "citus"
cosmosdb_postgresql_administrator_login_password = "P@ssw0rd1234!!"
cosmosdb_postgresql_tags = {
  "hidden-title" = "EYX - Prod-Pilot - PostgreSQL",
  "ROLE_PURPOSE" =  "EYX - Prod-Pilot - PostgreSQL"
}

######################################
#### PRIVATE ENDPOINTS NAMES #########
######################################
service_bus_pep_name         = "USEPEYXP01PEP05"
redis_cache_pep_name         = "USEPEYXP01PEP06"
cosmosdb_pep_name            = "USEPEYXP01PEP07"
cosmosdb_postgresql_pep_name = "USEPEYXP01PEP08"