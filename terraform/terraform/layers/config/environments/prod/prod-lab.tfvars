################
### GENERAL ####
################
#tags = {
#  DEPLOYMENT_ID = "EYXP01"
#  ENGAGEMENT_ID = "I-69197406"
#  OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
#  ENVIRONMENT   = "Production"
#}
#hidden_title_tag_env = "Prod-1"
env = "PROD"

######################
### SHARED DATA ######
######################
# DEV doesn't use admin resources - these will be automatically ignored by the shared module
resource_group_name_admin                 = null
log_analytics_workspace_admin_name        = null
vnet_admin_name_01                        = null
#kv_shared_admin                           = null
shared_rg_admin_dev = false

resource_group_name_app                   = "USEPEYXP01RSG02"
log_analytics_workspace_app_name          = "USEPEYXP01LAW02"
vnet_app_name_01                          = "USEPEYXP01VNT02" # Frontend VNET
vnet_app_name_02                          = "USEPEYXP01VNT03" # Backend VNET
subnet1_name_app_02                       = "USEPEYXP01SBN06" # Subnet for Backend Layer
kv_shared_app                             = "USEPEYXP01AKV02"
storage_account_app_name_01               = "usepeyxp01sta04"




# #####################################################
# #### RANDOM PASSWORD KEY VAULT  #####################
# #####################################################



secret_name = "A-secret-1"



# ################################################
# #### STORAGE ACCOUNT CONTAINERS ################
# ################################################



resource_group_name = "USEPEYXP01RSG02"
storage_account_name = "usepeyxp01sta04"
container_names = ["avatars", "docstorage", "notices", "openapipluginspecifications", "smemory", "templates", "vision-assets", "agent-testing-transactions", "agenttestsuite"]






# #####################################
# #### COSMOS DB ######################
# #####################################

cosmosdb_account_name = "usepeyxp01cdb03"

cosmosdb_database_name = "EYX-Copilot"
cosmosdb_containers  = {
  "testCase" = {
    partition_key_path = "/id"
    throughput         = 400
  }
  "testSuite" = {
    partition_key_path = "/id"
    throughput         = 400
  }
  "testResult" = {
    partition_key_path = "/testCaseId"
    throughput         = 400
  }
} 