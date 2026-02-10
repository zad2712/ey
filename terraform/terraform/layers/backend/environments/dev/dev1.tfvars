################
### GENERAL ####
################
tags = {
  DEPLOYMENT_ID = "CXS05H"
  ENGAGEMENT_ID = "I-69197406"
  OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT   = "Development"
}
hidden_title_tag_env = "Dev-1"
env = "DEV"

######################
### SHARED DATA ######
######################
# DEV doesn't use admin resources - these will be automatically ignored by the shared module
resource_group_name_admin                 = null
log_analytics_workspace_admin_name        = null
vnet_admin_name_01                        = null
kv_shared_admin                           = null

resource_group_name_app                   = "USEDCXS05HRSG04"
log_analytics_workspace_app_name          = "USEDCXS05HLAW03"
vnet_app_name_01                          = "USEDCXS05HVNT04" # Frontend VNET
vnet_app_name_02                          = "USEDCXS05HVNT05" # Backend VNET
subnet1_name_app_02                       = "USEDCXS05HSBN12" # Subnet for Backend Layer
kv_shared_app                             = "USEDCXS05HAKV03"

#####################################
#### REDIS CACHE ####################
#####################################
redis_cache_name                = "USEDCXS05HRDC02"
redis_cache_capacity            = 1
redis_cache_family              = "C"
redis_cache_sku_name            = "Standard"
redis_cache_enable_non_ssl_port = false
redis_cache_minimum_tls_version = "1.2"
redis_cache_configuration = {
  maxmemory_policy = "volatile-lru"
}
redis_cache_tags = {
  "hidden-title" = "EYX - Dev-1 - Redis Cache"
}

#####################################
#### SERVICE BUS ####################
#####################################
servicebus_namespace_name    = "USEDCXS05HSB02"
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
  "hidden-title" = "EYX - Dev-1 - Service Bus"
}

#####################################
#### COSMOS DB ######################
#####################################
cosmosdb_account_name = "usedcxs05hcdb03"
cosmosdb_tags = {
  "hidden-title" = "EYX - Dev-1 - Cosmos DB NoSQL"
}

######################################
#### COSMOS DB POSTGRESQL CLUSTER ####
######################################
cosmosdb_postgresql_name                         = "usedcxs05hcdb04"
cosmosdb_postgresql_administrator_login          = "citus"
cosmosdb_postgresql_administrator_login_password = "P@ssw0rd1234!!"
cosmosdb_postgresql_tags = {
  "hidden-title" = "EYX - Dev-1 - PostgreSQL"
}

######################################
#### PRIVATE ENDPOINTS NAMES #########
######################################
service_bus_pep_name         = "USEDCXS05HPEP01"
redis_cache_pep_name         = "USEDCXS05HPEP02"
cosmosdb_pep_name            = "USEDCXS05HPEP03"
cosmosdb_postgresql_pep_name = "USEDCXS05HPEP04"