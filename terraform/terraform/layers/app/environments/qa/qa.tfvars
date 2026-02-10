################
### GENERAL ####
################
# tags = {
#   DEPLOYMENT_ID = "CXS05H"
#   ENGAGEMENT_ID = "I-69197406"
#   OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
#   ENVIRONMENT   = "QA"
# }

deploy_resource           = true
env                       = "QA"
hidden_title_tag_env      = "QA"
inactive_agent_purge_days = 30

######################
### BACKEND CONFIG ###
######################
backend_resource_group_name  = "USEQCXS05HRSG02"
backend_storage_account_name = "useqcxs05hsta01"
backend_container_name       = "terraform"
backend_subscription_id      = "bcff8cd6-13ff-48f9-8a70-2e5478106b1a"

######################
### SHARED DATA ######
######################
resource_group_name_admin        = "USEQCXS05HRSG02"
resource_group_name_app          = "USEQCXS05HRSG03"
log_analytics_workspace_app_name = "USEQCXS05HLAW02"
vnet_admin_name_01               = "USEQCXS05HVNT01" # Admin VNET
subnet_admin_name_01             = "USEQCXS05HSBN01" # Admin Subnet1
vnet_app_name_01                 = "USEQCXS05HVNT02" # Frontend VNET
subnet_app_name_01               = "USEQCXS05HSBN03"
subnet_app_name_02               = "USEQCXS05HSBN04"
subnet_app_name_03               = "USEQCXS05HSBN05"
vnet_app_name_02                 = "USEQCXS05HVNT03" # Backend VNET
subnet1_name_app_02              = "USEQCXS05HSBN06" # Backend Subnet1 /27
subnet2_name_app_02              = "USEQCXS05HSBN07" # Backend Subnet2 /27
subnet3_name_app_02              = "USEQCXS05HSBN08" # Backend Subnet3 /26
app_insights_name                = "USEQCXS05HAAI01"
key_vault_name                   = "USEQCXS05HAKV02"

#####################################
#### STORAGE ACCOUNT ################
#####################################
# General Storage Account setting
account_infra_encryption_enabled = false

####### storage_account_app_01 - in QA this is the App one
storage_account_app_01                                 = "useqcxs05hsta03"
account_tier_storage_account_app_01                    = "Standard"
account_replication_type_storage_account_app_01        = "LRS"
allow_nested_items_to_be_public_storage_account_app_01 = false

####### storage_account_app_02 - in QA this is the Logs one.
storage_account_app_02                                 = "useqcxs05hsta02"
account_tier_storage_account_app_02                    = "Standard"
account_replication_type_storage_account_app_02        = "LRS"
allow_nested_items_to_be_public_storage_account_app_02 = false

#########################
#### SERVICE PLAN ######
#########################
### app_service_plan_ui ########
app_service_plan_name_app_01 = "USEQCXS05HASP01"
os_type_service_plan_app_01  = "Windows"
sku_name_service_plan_app_01 = "P1v3"

### app_service_plan_apis ########
app_service_plan_name_app_02 = "USEQCXS05HASP02"
os_type_service_plan_app_02  = "Windows"
sku_name_service_plan_app_02 = "P1v3"

### app_service_plan_functions ########
app_service_plan_name_app_03 = "USEQCXS05HASP03"
os_type_service_plan_app_03  = "Windows"
sku_name_service_plan_app_03 = "P1v3"

######################
#### WEB APPS ########
######################
x_azure_fdid                          = "a30eeed0-80de-4e64-83f5-14847927e016"
enable_telemetry                      = false
enable_application_insights           = false
https_only                            = true
minimum_tls_version                   = "1.2"
diagnostic_settings_log_groups        = ["allLogs"]
diagnostic_settings_metric_categories = ["AllMetrics"]

### app_service_windows_ui #####
web_app_name_app_01                 = "USEQCXS05HWAP01"
web_app_current_stack_app_01        = "dotnet"
web_app_dotnet_version_app_01       = "v6.0"
site_config_app_01                  = {}
app_service_windows_ui_app_settings = {}
app_service_windows_ui_cors = {
  allowed_origins = [
    "https://eyx-qa-use.ey.com",
    "https://eyqqa.eyfabric.ey.com"
  ]
  support_credentials = true
}

### app_service_windows_web_api #####
web_app_name_app_02                  = "USEQCXS05HWAP02"
web_app_current_stack_app_02         = "dotnet"
web_app_dotnet_version_app_02        = "v6.0"
site_config_app_02                   = {}
app_service_windows_api_app_settings = {}
app_service_windows_api_cors = {
  allowed_origins = [
    "https://eyx-qa-use.ey.com",
    "https://apim.eyx-qa-use.ey.com",
    "https://eyqqa.eyfabric.ey.com",
    "https://useqcxs05hwap03.azurewebsites.net"
  ]
  support_credentials = true
}

### app_service_windows_notice_api #####
web_app_name_app_03                         = "USEQCXS05HWAP03"
web_app_current_stack_app_03                = "dotnet"
web_app_dotnet_version_app_03               = "v6.0"
site_config_app_03                          = {}
app_service_windows_notice_api_app_settings = {}

### app_service_windows_kernel_memory #####
web_app_name_app_04                            = "USEQCXS05HWAP04"
web_app_current_stack_app_04                   = "dotnet"
web_app_dotnet_version_app_04                  = "v6.0"
site_config_app_04                             = {}
app_service_windows_kernel_memory_app_settings = {}


#####################################
#### VNET WEBAPP INTEGRATION ########
#####################################


#####################################
#### FUNCTION APP  ################
#####################################
function_app_name_app_01      = "USEQCXS05HAZF01"
dotnet_version_funct_app_01   = "v8.0"
function_current_stack_app_01 = "dotnet"
function_app_01_app_settings = {
  "AzureWebJobs.AgentPromoteFiles_Activity.Disabled"  = "1"
  "AzureWebJobs.AgentPromoteVector_Activity.Disabled" = "1"
  "AzureWebJobs.AgentPromote_Activity.Disabled"       = "1"
  "AzureWebJobs.AgentPromote_Orchestrator.Disabled"   = "1"
  "AzureWebJobs.AgentPromote_Queue.Disabled"          = "1"
  "AzureWebJobs.StatelessWatcher_Timer.Disabled"      = "1"
}
kv_secret_storage_connection_string_name = "FuncAppStorageConnectionString"


################
#### SIGNALR  ##
################
#### signalr_name_app_01
signalr_name_app_01      = "USEQCXS05HSNR01"
sku_name_app_01          = "Premium_P1"
sku_capacity_app_01      = 1
signalr_enable_autoscale = true

######################
# CONTAINER REGISTRY #
######################
acr_name                                         = "useqacxs05hacr01"
acr_sku                                          = "Premium"
acr_admin_enabled                                = true
acr_zone_redundancy_enabled                      = false
container_registry_public_network_access_enabled = true

#############################
# CCONTAINER APP ENVIRONMENT#
#############################
cae_name                    = "useqacxs05hcae01"
cae_zone_redundancy_enabled = false

# Enable workload profiles for session pool support
cae_workload_profile_enabled = true
cae_workload_profiles = [
  {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count         = 0
    maximum_count         = 10
  }
]

#################
# CONTAINER APP #
#################
container_app_name = "useqacxs05haca01"
container_name     = "app-container"
container_image    = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
container_cpu      = 0.5
container_memory   = "1Gi"


###########################
# SESSION POOL SETTINGS
#########################
session_pool_enabled                 = true
session_pool_name                    = "useqacxs05h-python-pool"
session_pool_max_concurrent_sessions = 600
session_pool_ready_instances         = 5
session_pool_cooldown_period_seconds = 3600
session_pool_target_port             = 80
session_pool_network_status          = "EgressDisabled"
session_pool_container_type          = "PythonLTS"

# Container configuration (not needed for PythonLTS type)
# session_pool_container_name              = "app-container"
# session_pool_container_image             = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
session_pool_container_cpu    = 0.25
session_pool_container_memory = "0.5Gi"

# Optional: Registry authentication (uncomment if using private registry)
# session_pool_registry_server            = "myregistry.azurecr.io"
# session_pool_registry_username          = "myregistry"
# session_pool_registry_password_secret   = "registry-password"

# Optional: Environment variables for sessions
# session_pool_environment_variables = {
#   API_BASE_URL = "https://api.example.com"
#   LOG_LEVEL    = "INFO"
# }

# Role assignments for session pool access
session_pool_enable_default_roles = true


session_pool_app_service_managed_identities = [
  "USEQCXS05HWAP02" # Web API app service
  # "USEQCXS05HWAP01"  # Uncomment to include UI app service
  # "USEQCXS05HWAP03",  # Uncomment to include Notice API app service
  # "USEQCXS05HWAP04"   # Uncomment to include Kernel Memory app service
]



# #########################
# # AZURE OPENAI SERVICE #
# #########################
# openai_account_name                  = "useqacxs05hoai01"
# openai_sku_name                      = "S0"
# openai_custom_subdomain_name         = "useqacxs05hoai01"
# openai_public_network_access_enabled = true
# # Override the default network_acls_default_action from "Deny" to "Allow"

# #############################
# # OPENAI MODEL DEPLOYMENTS  #
# #############################
# deployments = {
#   gpt-4o-deployment = {
#     deployment_name = "gpt-4o"
#     model_format    = "OpenAI"
#     model_name      = "gpt-4o"
#     model_version   = "2024-08-06"
#     sku_name        = "GlobalStandard"
#     sku_capacity    = 10
#   },
#   embedding-ada-deployment = {
#     deployment_name = "text-embedding-ada-002"
#     model_format    = "OpenAI"
#     model_name      = "text-embedding-ada-002"
#     model_version   = "2"
#     sku_name        = "Standard"
#     sku_capacity    = 10
#   }
# }

##################################
# AZURE COGNITIVE SPEECH SERVICE #
##################################
speech_account_name                  = "useqcxs05hspc01"
speech_service_custom_subdomain_name = "useqcxs05hspc01"
speech_sku_name                      = "S0"

#######################################
# AZURE DOCUMENT INTELLIGENCE SERVICE #
#######################################
document_intelligence_account_name          = "USEQCXS05HADI01"
document_intelligence_custom_subdomain_name = "useqcxs05hadi01"
document_intelligence_sku_name              = "S0"

######################################
#### PRIVATE ENDPOINTS NAMES #########
######################################
web_app_ui_pep_name                     = "USEQCXS05HPEP01"
web_app_api_pep_name                    = "USEQCXS05HPEP02"
web_app_notice_api_pep_name             = "USEQCXS05HPEP03"
web_app_kernel_memory_pep_name          = "USEQCXS05HPEP04"
function_app_pep_name                   = "USEQCXS05HPEP05"
storage_account_app_logs_pep_name_queue = "USEQCXS05HPEP16"
storage_account_app_pep_name_blob       = "USEQCXS05HPEP07"
storage_account_app_pep_name_table      = "USEQCXS05HPEP08"
storage_account_app_pep_name_queue      = "USEQCXS05HPEP09"
storage_account_app_logs_pep_name_blob  = "USEQCXS05HPEP06"
speech_account_pep_name                 = "USEQCXS05HPEP14"
document_intelligence_pep_name          = "USEQCXS05HPEP15"
container_registry_pep_name             = "USEQCXS05HPEP18"