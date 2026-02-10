################
### GENERAL ####
################
# tags = {
#   DEPLOYMENT_ID = "EYXP01"
#   ENGAGEMENT_ID = "I-69197406"
#   OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
#   ENVIRONMENT   = "Production"
# }

deploy_resource           = true
env                       = "PROD"
hidden_title_tag_env      = "Prod-Pilot"
inactive_agent_purge_days = 90

######################
### SHARED DATA ######
######################
resource_group_name_admin             = "USEPEYXP01RSG01"
resource_group_name_app               = "USEPEYXP01RSG03"
# log_analytics_workspace_admin_name  = "USEPEYXP01LAW01"
log_analytics_workspace_app_name      = "USEPEYXP01LAW03"
vnet_admin_name_01                    = "USEPEYXP01VNT01" # Admin VNET
subnet_admin_name_01                  = "USEPEYXP01SBN01" # Admin Subnet1
vnet_app_name_01                      = "USEPEYXP01VNT04" # Admin Subnet1
subnet_app_name_01                    = "USEPEYXP01SBN09"
subnet_app_name_02                    = "USEPEYXP01SBN10"
subnet_app_name_03                    = "USEPEYXP01SBN11"
vnet_app_name_02                      = "USEPEYXP01VNT05" # Backend VNet
subnet1_name_app_02                   = "USEPEYXP01SBN12" # Backend Subnet1 /27
subnet2_name_app_02                   = "USEPEYXP01SBN13" # Backend Subnet2 /27
subnet3_name_app_02                   = "USEPEYXP01SBN14" # Backend Subnet3 /27
storage_account_app_name_01           = ""
app_insights_name                     = "USEPEYXP01AAI02"
key_vault_name                        = "USEPEYXP01AKV03"

#####################################
#### STORAGE ACCOUNT ################
#####################################
# General Storage Account setting
account_infra_encryption_enabled = true

####### storage_account_app_01
storage_account_app_01                                 = "USEPEYXP01STA06"
account_tier_storage_account_app_01                    = "Standard"
account_replication_type_storage_account_app_01        = "LRS"
allow_nested_items_to_be_public_storage_account_app_01 = false

####### storage_account_app_02
storage_account_app_02                                 = "USEPEYXP01STA07"
account_tier_storage_account_app_02                    = "Standard"
account_replication_type_storage_account_app_02        = "LRS"
allow_nested_items_to_be_public_storage_account_app_02 = false

#########################
#### SERVICE PLAN ######
#########################
### app_service_plan_ui ########
app_service_plan_name_app_01 = "USEPEYXP01ASP07"
os_type_service_plan_app_01  = "Windows"
sku_name_service_plan_app_01 = "P1v3"

### app_service_plan_apis ########
app_service_plan_name_app_02 = "USEPEYXP01ASP08"
os_type_service_plan_app_02  = "Windows"
sku_name_service_plan_app_02 = "P2v3"

# API App Service Plan Autoscaling Configuration
enable_autoscale_app_02 = true

### app_service_plan_functions ########
app_service_plan_name_app_03 = "USEPEYXP01ASP09"
os_type_service_plan_app_03  = "Windows"
sku_name_service_plan_app_03 = "P1v3"

######################
#### WEB APPS ########
######################
x_azure_fdid                          = "1df2680c-a09b-4526-a390-d8f4b97aa29f" # Replace with the FrontDoor ID for Prod
app_service_kind                      = "webapp"
enable_telemetry                      = false
enable_application_insights           = false
https_only                            = true
minimum_tls_version                   = "1.2"
diagnostic_settings_log_groups        = ["allLogs"]
diagnostic_settings_metric_categories = ["AllMetrics"]
# app_service_logs_config = {
#   web_app_logs = { # Arbitrary map key
#     detailed_error_messages = true
#     failed_requests_tracing = true

#     application_logs = {
#       app_file_system = { # Arbitrary map key
#         file_system_level = "Off"
#       }
#     }
#     http_logs = {
#       http_file_system = { # Arbitrary map key
#         file_system = {
#           retention_in_days = 0
#           retention_in_mb   = 35
#         }
#       }
#     }
#   }
# }

### app_service_windows_ui #####
web_app_name_app_01                     = "USEPEYXP01WAP09"
web_app_https_only_app_01               = true
web_app_always_on_app_01                = true
web_app_ftps_state_app_01               = "FtpsOnly"
web_app_scm_type_app_01                 = "None"
web_app_use_32_bit_worker_app_01        = true
web_app_websockets_enabled_app_01       = false
web_app_managed_pipeline_mode_app_01    = "Integrated"
web_app_remote_debugging_enabled_app_01 = false
web_app_current_stack_app_01            = "dotnet"
web_app_dotnet_version_app_01           = "v8.0"
web_app_identity_type_app_01            = "SystemAssigned"
site_config_app_01                      = {}
app_service_windows_ui_app_settings     = {}
app_service_windows_ui_cors = {
  allowed_origins = [
    # Update values with prod ones
    "https://api.eyq.eyfabric.ey.com",
    "https://eyx-prod-pilot-use.ey.com",
    "https://eyq.eyfabric.ey.com",
  ]
  support_credentials = true
}

### app_service_windows_web_api #####
web_app_name_app_02                     = "USEPEYXP01WAP0A"
web_app_https_only_app_02               = true
web_app_always_on_app_02                = true
web_app_ftps_state_app_02               = "FtpsOnly"
web_app_scm_type_app_02                 = "None"
web_app_use_32_bit_worker_app_02        = true
web_app_websockets_enabled_app_02       = false
web_app_managed_pipeline_mode_app_02    = "Integrated"
web_app_remote_debugging_enabled_app_02 = false
web_app_current_stack_app_02            = "dotnet"
web_app_dotnet_version_app_02           = "v8.0"
web_app_identity_type_app_02            = "SystemAssigned"
site_config_app_02                      = {}
app_service_windows_api_app_settings    = {}
app_service_windows_api_cors = {
  allowed_origins = [
    # Update values with prod ones
    "https://api.eyq.eyfabric.ey.com",
    "https://usepeyxp01wap0c.azurewebsites.net",
    "https://eyx-prod-pilot-use.ey.com",
    "https://apim.eyx-prod-pilot-use.ey.com",
    "https://eyq.eyfabric.ey.com"
  ]
  support_credentials = true
}

### app_service_windows_notice_api #####
web_app_name_app_03                         = "USEPEYXP01WAP0B"
web_app_https_only_app_03                   = true
web_app_always_on_app_03                    = true
web_app_ftps_state_app_03                   = "FtpsOnly"
web_app_scm_type_app_03                     = "None"
web_app_use_32_bit_worker_app_03            = true
web_app_websockets_enabled_app_03           = false
web_app_managed_pipeline_mode_app_03        = "Integrated"
web_app_remote_debugging_enabled_app_03     = false
web_app_current_stack_app_03                = "dotnet"
web_app_dotnet_version_app_03               = "v8.0"
web_app_identity_type_app_03                = "SystemAssigned"
site_config_app_03                          = {}
app_service_windows_notice_api_app_settings = {}

### app_service_windows_kernel_memory #####
web_app_name_app_04                            = "USEPEYXP01WAP0C"
web_app_https_only_app_04                      = true
web_app_always_on_app_04                       = true
web_app_ftps_state_app_04                      = "FtpsOnly"
web_app_scm_type_app_04                        = "None"
web_app_use_32_bit_worker_app_04               = true
web_app_websockets_enabled_app_04              = false
web_app_managed_pipeline_mode_app_04           = "Integrated"
web_app_remote_debugging_enabled_app_04        = false
web_app_current_stack_app_04                   = "dotnet"
web_app_dotnet_version_app_04                  = "v8.0"
web_app_identity_type_app_04                   = "SystemAssigned"
site_config_app_04                             = {}
app_service_windows_kernel_memory_app_settings = {}

#####################################
#### VNET WEBAPP INTEGRATION ########
#####################################


#####################################
#### FUNCTION APP  ################
#####################################
function_app_name_app_01                 = "USEPEYXP01AZF03"
dotnet_version_funct_app_01              = "v8.0"
function_current_stack_app_01            = "dotnet"
function_app_01_app_settings             = {}
kv_secret_storage_connection_string_name = "FuncAppStorageConnectionString"

################
#### SIGNALR  ##
################
#### signalr_name_app_01
signalr_name_app_01      = "USEPEYXP01SNR03"
sku_name_app_01          = "Premium_P1"
sku_capacity_app_01      = 1
signalr_enable_autoscale = true

######################
# CONTAINER REGISTRY #
######################
acr_name                    = "usepeyxp01acr03"
acr_sku                     = "Premium"
acr_admin_enabled           = false
acr_zone_redundancy_enabled = false

############################
# CONTAINER APP ENVIRONMENT#
############################
cae_name                      = "usepeyxp01cae03"
cae_zone_redundancy_enabled   = false
public_network_access_enabled = "Disabled"
# Enable workload profiles for session pool support
cae_workload_profile_enabled = true
cae_workload_profiles = [
  {
    name                  = "Consumption"
    workload_profile_type = "Consumption"
    minimum_count         = 1 # At least 1 to avoid scale-to-zero issues
    maximum_count         = 10
  }
]

#################
# CONTAINER APP #
#################
container_app_name = "usepeyxp01aca03"
container_name     = "app-container"
container_image    = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
container_cpu      = 0.5
container_memory   = "1Gi"

###########################
# SESSION POOL SETTINGS
#########################
session_pool_enabled                 = true
session_pool_name                    = "usepeyxp01aca03-python-pool"
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
  "USEPEYXP01WAP0A" # Web API app service
  # "USEQCXS05HWAP01"  # Uncomment to include UI app service
  # "USEQCXS05HWAP03",  # Uncomment to include Notice API app service
  # "USEQCXS05HWAP04"   # Uncomment to include Kernel Memory app service
]

#########################
# AZURE OPENAI SERVICE #
#########################
# openai_account_name = "usepeyxp01oai03"
openai_sku_name                      = "S0"
openai_custom_subdomain_name         = "usepeyxp01oai03"
openai_public_network_access_enabled = true
# Override the default network_acls_default_action from "Deny" to "Allow"

#############################
# OPENAI MODEL DEPLOYMENTS  #
#############################
deployments = {
  gpt-4o-deployment = {
    deployment_name = "gpt-4o"
    model_format    = "OpenAI"
    model_name      = "gpt-4o"
    model_version   = "2024-08-06"
    sku_name        = "GlobalStandard"
    sku_capacity    = 10
  },
  embedding-ada-deployment = {
    deployment_name = "text-embedding-ada-002"
    model_format    = "OpenAI"
    model_name      = "text-embedding-ada-002"
    model_version   = "2"
    sku_name        = "Standard"
    sku_capacity    = 10
  }
}

##################################
# AZURE COGNITIVE SPEECH SERVICE #
##################################
speech_account_name                  = "USEPEYXP01SPC03"
speech_service_custom_subdomain_name = "USEPEYXP01SPC03"
speech_sku_name                      = "S0"

#######################################
# AZURE DOCUMENT INTELLIGENCE SERVICE #
#######################################
document_intelligence_account_name          = "USEPEYXP01ADI03"
document_intelligence_custom_subdomain_name = "USEPEYXP01ADI03"
document_intelligence_sku_name              = "S0"

######################################
#### PRIVATE ENDPOINTS NAMES #########
######################################
web_app_ui_pep_name                     = "USEPEYXP01PEP0Q"
web_app_api_pep_name                    = "USEPEYXP01PEP0R"
web_app_notice_api_pep_name             = "USEPEYXP01PEP0S"
web_app_kernel_memory_pep_name          = "USEPEYXP01PEP0T"
function_app_pep_name                   = "USEPEYXP01PEP0U"
storage_account_app_logs_pep_name_queue = "USEPEYXP01PEP0W"
storage_account_app_pep_name_blob       = "USEPEYXP01PEP0X"
storage_account_app_pep_name_table      = "USEPEYXP01PEP0Y"
storage_account_app_pep_name_queue      = "USEPEYXP01PEP0Z"
storage_account_app_logs_pep_name_blob  = "USEPEYXP01PEP1A"
speech_account_pep_name                 = "USEPEYXP01PEP10"
document_intelligence_pep_name          = "USEPEYXP01PEP11"
container_registry_pep_name             = "USEPEYXP01PEP12"
container_app_environment_pep_name      = "USEPEYXP01PEP2B"