################
### GENERAL ####
################
tags = {
  DEPLOYMENT_ID = "CXS05H"
  ENGAGEMENT_ID = "I-69197406"
  OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT   = "Development"
}

deploy_resource           = true
env                       = "DEV"
hidden_title_tag_env      = "Dev-2"
inactive_agent_purge_days = 30

######################
### SHARED DATA ######
######################
resource_group_name_admin             = "USEDCXS05HRSG02" # That resource group belongs to Dev Integration because it has the private DNS zones
resource_group_name_app               = "USEDCXS05HRSG05"
# log_analytics_workspace_admin_name  = "USEDCXS05HLAW01"
log_analytics_workspace_app_name      = "USEDCXS05HLAW04"
vnet_admin_name_01                    = "USEDCXS05HVNT99" # Admin VNET
subnet_admin_name_01                  = "USEDCXS05HSBN99" # Admin Subnet1
vnet_app_name_01                      = "USEDCXS05HVNT06" # Frontend VNET
subnet_app_name_01                    = "USEDCXS05HSBN15"
subnet_app_name_02                    = "USEDCXS05HSBN16"
subnet_app_name_03                    = "USEDCXS05HSBN17"
vnet_app_name_02                      = "USEDCXS05HVNT07" # Backend VNet
subnet1_name_app_02                   = "USEDCXS05HSBN18" # Backend Subnet1 /27
subnet2_name_app_02                   = "USEDCXS05HSBN19" # Backend Subnet2 /27
subnet3_name_app_02                   = "USEDCXS05HSBN20" # Backend Subnet3 /27
storage_account_app_name_01           = ""
app_insights_name                     = "USEDCXS05HAAI02"
key_vault_name                        = "USEDCXS05HAKV04"

#####################################
#### STORAGE ACCOUNT ################
#####################################
# General Storage Account setting
account_infra_encryption_enabled  = false
blob_delete_retention_policy_days = 365

####### storage_account_app_01
storage_account_app_01                                 = "USEDCXS05HSTA06"
account_tier_storage_account_app_01                    = "Standard"
account_replication_type_storage_account_app_01        = "LRS"
allow_nested_items_to_be_public_storage_account_app_01 = false
storage_public_network_access_enabled                  = true

####### storage_account_app_02
storage_account_app_02                                 = "USEDCXS05HSTA07"
account_tier_storage_account_app_02                    = "Standard"
account_replication_type_storage_account_app_02        = "LRS"
allow_nested_items_to_be_public_storage_account_app_02 = false

#########################
#### SERVICE PLAN ######
#########################
### app_service_plan_ui ########
app_service_plan_name_app_01 = "USEDCXS05HASP07"
os_type_service_plan_app_01  = "Windows"
sku_name_service_plan_app_01 = "P1v3"

### app_service_plan_apis ########
app_service_plan_name_app_02 = "USEDCXS05HASP08"
os_type_service_plan_app_02  = "Windows"
sku_name_service_plan_app_02 = "P1v3"

### app_service_plan_functions ########
app_service_plan_name_app_03 = "USEDCXS05HASP09"
os_type_service_plan_app_03  = "Windows"
sku_name_service_plan_app_03 = "P1v3"

######################
#### WEB APPS ########
######################
app_service_kind                      = "webapp"
enable_telemetry                      = false
enable_application_insights           = false
https_only                            = true
minimum_tls_version                   = "1.2"
diagnostic_settings_log_groups        = ["allLogs"]
diagnostic_settings_metric_categories = ["AllMetrics"]
app_service_logs_config = {
  web_app_logs = { # Arbitrary map key
    detailed_error_messages = true
    failed_requests_tracing = true

    application_logs = {
      app_file_system = { # Arbitrary map key
        file_system_level = "Off"
      }
    }
    http_logs = {
      http_file_system = { # Arbitrary map key
        file_system = {
          retention_in_days = 0
          retention_in_mb   = 35
        }
      }
    }
  }
}

### app_service_windows_ui #####
web_app_name_app_01                     = "USEDCXS05HWAP09"
web_app_https_only_app_01               = true
web_app_always_on_app_01                = true
web_app_ftps_state_app_01               = "FtpsOnly"
web_app_scm_type_app_01                 = "None"
web_app_use_32_bit_worker_app_01        = true
web_app_websockets_enabled_app_01       = false
web_app_managed_pipeline_mode_app_01    = "Integrated"
web_app_remote_debugging_enabled_app_01 = false
web_app_current_stack_app_01            = "dotnet"
web_app_dotnet_version_app_01           = "v6.0"
web_app_identity_type_app_01            = "SystemAssigned"
site_config_app_01                      = {}
app_service_windows_ui_cors = {
  allowed_origins = [
    "https://apim.eyx-dev2-use.ey.com",
    "https://eyqdev2.eyfabric.ey.com",
    "https://eyx-dev2-use.ey.com",
    "https://usedcxs05hwap0b.azurewebsites.net"
  ]
  # support_credentials = true
}

### app_service_windows_web_api #####
web_app_name_app_02                     = "USEDCXS05HWAP0A"
web_app_https_only_app_02               = true
web_app_always_on_app_02                = true
web_app_ftps_state_app_02               = "FtpsOnly"
web_app_scm_type_app_02                 = "None"
web_app_use_32_bit_worker_app_02        = true
web_app_websockets_enabled_app_02       = false
web_app_managed_pipeline_mode_app_02    = "Integrated"
web_app_remote_debugging_enabled_app_02 = false
web_app_current_stack_app_02            = "dotnet"
web_app_dotnet_version_app_02           = "v6.0"
web_app_identity_type_app_02            = "SystemAssigned"
site_config_app_02                      = {}

### app_service_windows_notice_api #####
web_app_name_app_03                     = "USEDCXS05HWAP0B"
web_app_https_only_app_03               = true
web_app_always_on_app_03                = true
web_app_ftps_state_app_03               = "FtpsOnly"
web_app_scm_type_app_03                 = "None"
web_app_use_32_bit_worker_app_03        = true
web_app_websockets_enabled_app_03       = false
web_app_managed_pipeline_mode_app_03    = "Integrated"
web_app_remote_debugging_enabled_app_03 = false
web_app_current_stack_app_03            = "dotnet"
web_app_dotnet_version_app_03           = "v6.0"
web_app_identity_type_app_03            = "SystemAssigned"
site_config_app_03                      = {}

### app_service_windows_kernel_memory #####
web_app_name_app_04                     = "USEDCXS05HWAP0C"
web_app_https_only_app_04               = true
web_app_always_on_app_04                = true
web_app_ftps_state_app_04               = "FtpsOnly"
web_app_scm_type_app_04                 = "None"
web_app_use_32_bit_worker_app_04        = true
web_app_websockets_enabled_app_04       = false
web_app_managed_pipeline_mode_app_04    = "Integrated"
web_app_remote_debugging_enabled_app_04 = false
web_app_current_stack_app_04            = "dotnet"
web_app_dotnet_version_app_04           = "v6.0"
web_app_identity_type_app_04            = "SystemAssigned"
site_config_app_04                      = {}

#####################################
#### VNET WEBAPP INTEGRATION ########
#####################################


#####################################
#### FUNCTION APP  ################
#####################################
function_app_name_app_01                 = "USEDCXS05HAZF03"
dotnet_version_funct_app_01              = "v8.0"
function_current_stack_app_01            = "dotnet"
function_app_01_app_settings             = {}
kv_secret_storage_connection_string_name = "FuncAppStorageConnectionString"
function_ftp_publish_basic_authentication_enabled = true
function_public_network_access_enabled            = true
function_ip_restriction_default_action            = "Allow"
function_scm_ip_restriction_default_action        = "Allow"

################
#### SIGNALR  ##
################
#### signalr_name_app_01
signalr_name_app_01 = "USEDCXS05HSNR03"
sku_name_app_01     = "Standard_S1"
sku_capacity_app_01 = 1

######################
# CONTAINER REGISTRY #
######################
acr_name                                          = "usedcxs05hacr03"
acr_sku                                           = "Standard"
acr_admin_enabled                                 = true
acr_zone_redundancy_enabled                       = false
container_registry_public_network_access_enabled  = true

############################
# CONTAINER APP ENVIRONMENT#
############################
cae_name                      = "usedcxs05hcae03"
cae_zone_redundancy_enabled   = false
public_network_access_enabled = "Disabled"
cae_workload_profile_enabled  = true
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
container_app_name = "usedcxs05haca03"
container_name     = "app-container"
container_image    = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
container_cpu      = 0.5
container_memory   = "1Gi"

#########################
# AZURE OPENAI SERVICE #
#########################
# openai_account_name = "usedcxs05hoai03"
openai_sku_name                      = "S0"
openai_custom_subdomain_name         = "usedcxs05hoai03"
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
    tags = {
      "hidden-title" = "EYX - Dev-2 - GPT-4o Deployment",
      "ROLE_PURPOSE" = "Dev-2 - GPT-4o Deployment"
    }
  },
  embedding-ada-deployment = {
    deployment_name = "text-embedding-ada-002"
    model_format    = "OpenAI"
    model_name      = "text-embedding-ada-002"
    model_version   = "2"
    sku_name        = "Standard"
    sku_capacity    = 10
    tags = {
      "hidden-title" = "EYX - Dev-2 - Text Embedding ADA Deployment",
      "ROLE_PURPOSE" = "Dev-2 - Text Embedding ADA Deployment"
    }
  }
}

##################################
# AZURE COGNITIVE SPEECH SERVICE #
##################################
speech_account_name                  = "USEDCXS05HSPC03"
speech_service_custom_subdomain_name = "USEDCXS05HSPC03"
speech_sku_name                      = "S0"
speech_public_network_access_enabled = true

#######################################
# AZURE DOCUMENT INTELLIGENCE SERVICE #
#######################################
document_intelligence_account_name                  = "USEDCXS05HADI03"
document_intelligence_custom_subdomain_name         = "USEDCXS05HADI03"
document_intelligence_sku_name                      = "S0"
document_intelligence_public_network_access_enabled = true

######################################
#### PRIVATE ENDPOINTS NAMES #########
######################################
web_app_ui_pep_name                     = "USEDCXS05HPEP0Q"
web_app_api_pep_name                    = "USEDCXS05HPEP0R"
web_app_notice_api_pep_name             = "USEDCXS05HPEP0S"
web_app_kernel_memory_pep_name          = "USEDCXS05HPEP0T"
function_app_pep_name                   = "USEDCXS05HPEP0U"
storage_account_app_logs_pep_name_queue = "USEDCXS05HPEP0V"
storage_account_app_pep_name_blob       = "USEDCXS05HPEP0W"
storage_account_app_pep_name_table      = "USEDCXS05HPEP0X"
storage_account_app_pep_name_queue      = "USEDCXS05HPEP0Y"
storage_account_app_logs_pep_name_blob  = "USEDCXS05HPEP0M"
speech_account_pep_name                 = "USEDCXS05HPEP10"
document_intelligence_pep_name          = "USEDCXS05HPEP11"
container_registry_pep_name             = "USEDCXS05HPEP12"
container_app_environment_pep_name      = "USEDCXS05HPEP0Z"
