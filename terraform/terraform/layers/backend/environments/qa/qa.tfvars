################
### GENERAL ####
################
tags = {
  DEPLOYMENT_ID = "CXS05H"
  ENGAGEMENT_ID = "I-68403024"
  OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT   = "QA"
}

######################
### SHARED DATA ######
######################
resource_group_name_admin          = "USEQCXS05HRSG02"
resource_group_name_app            = "USEQCXS05HRSG03"
log_analytics_workspace_app_name   = "USEQCXS05HLAW02"
log_analytics_workspace_admin_name = "USEQCXS05HLAW01"
vnet_app_name_01                   = "USEQCXS05HVNT02"
subnet_app_name_01                 = "USEQCXS05HSBN03"

#####################################
#### STORAGE ACCOUNT ################
#####################################
####### storage_account_admin_01
storage_account_admin_01                                 = "USEQCXS05STA01"
account_tier_storage_account_admin_01                    = "Standard"
account_replication_type_storage_account_admin_01        = "LRS"
allow_nested_items_to_be_public_storage_account_admin_01 = false

####### storage_account_app_01
storage_account_app_01                                 = "USEQCXS05HDL201"
account_tier_storage_account_app_01                    = "Standard"
account_replication_type_storage_account_app_01        = "LRS"
allow_nested_items_to_be_public_storage_account_app_01 = false
enable_storage_account_app_01                          = true

#####################################
#### REDIS CACHE ####################
#####################################
redis_cache_name                = "USEQCXS05HRDC01"
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
servicebus_namespace_name = "USEQCXS05HASB01"
servicebus_sku            = "Standard"
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
cosmosdb_account_name = "useqcxs05hcdb01"

######################################
#### COSMOS DB POSTGRESQL CLUSTER ####
######################################
cosmosdb_postgresql_name                         = "useqcxs05hcdb02"
cosmosdb_postgresql_administrator_login          = "citus"
cosmosdb_postgresql_administrator_login_password = "P@ssw0rd1234!!"