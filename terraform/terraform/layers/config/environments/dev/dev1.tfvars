################
### GENERAL ####
################
# tags = {
#   DEPLOYMENT_ID = "CXS05H"
#   ENGAGEMENT_ID = "I-69197406"
#   OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
#   ENVIRONMENT   = "Development"
# }
# hidden_title_tag_env = "Dev-1"
env = "DEV"

######################
### SHARED DATA ######
######################
# DEV doesn't use admin resources - these will be automatically ignored by the shared module
resource_group_name_admin                 = null
log_analytics_workspace_admin_name        = null
vnet_admin_name_01                        = null
kv_shared_admin                           = null
shared_rg_admin_dev = false

resource_group_name_app                   = "USEDCXS05HRSG04"
log_analytics_workspace_app_name          = "USEDCXS05HLAW03"
vnet_app_name_01                          = "USEDCXS05HVNT04" # Frontend VNET
vnet_app_name_02                          = "USEDCXS05HVNT05" # Backend VNET
subnet1_name_app_02                       = "USEDCXS05HSBN12" # Subnet for Backend Layer
kv_shared_app                             = "USEDCXS05HAKV03"
storage_account_app_name_01               = "usedcxs05hsta04"





# #####################################################
# #### RANDOM PASSWORD KEY VAULT  #####################
# #####################################################



secret_name = "A-secret-1"



# ################################################
# #### STORAGE ACCOUNT CONTAINERS ################
# ################################################



resource_group_name = "USEDCXS05HRSG04"
storage_account_name = "usedcxs05hsta04"
container_names = ["test1", "test3", "agent-testing-transactions", "agenttestsuite"]






# #####################################
# #### COSMOS DB ######################
# #####################################

cosmosdb_account_name = "usedcxs05hcdb03"

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