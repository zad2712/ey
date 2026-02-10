################
### GENERAL ####
################
deploy_resource           = true
env                       = "UAT"
hidden_title_tag_env      = "UAT-Lab"
inactive_agent_purge_days = 90

######################
### BACKEND CONFIG ###
######################
backend_resource_group_name  = "USEUEYXU01RSG01"
backend_storage_account_name = "useueyxu01sta01"
backend_container_name       = "terraform"
backend_subscription_id      = "bcff8cd6-13ff-48f9-8a70-2e5478106b1a"

######################
### SHARED DATA ######
######################
resource_group_name_admin             = "USEUEYXU01RSG01"
resource_group_name_app               = "USEUEYXU01RSG02"
# log_analytics_workspace_admin_name  = "USEUEYXU01LAW01"
log_analytics_workspace_app_name      = "USEUEYXU01LAW02"
vnet_admin_name_01                    = "USEUEYXU01VNT01" # Admin VNET
subnet_admin_name_01                  = "USEUEYXU01SBN01" # Admin Subnet1
vnet_app_name_01                      = "USEUEYXU01VNT02" # Frontend VNET
subnet_app_name_01                    = "USEUEYXU01SBN03"
subnet_app_name_02                    = "USEUEYXU01SBN04"
subnet_app_name_03                    = "USEUEYXU01SBN05"
vnet_app_name_02                      = "USEUEYXU01VNT03" # Backend VNET
subnet1_name_app_02                   = "USEUEYXU01SBN06" # Backend Subnet1 /27
subnet2_name_app_02                   = "USEUEYXU01SBN07" # Backend Subnet2 /27
subnet3_name_app_02                   = "USEUEYXU01SBN08" # Backend Subnet3 /27
storage_account_app_name_01           = ""
app_insights_name                     = "USEUEYXU01AAI01"
app_insights_app_pilot_name           = "USEUEYXU01AAI02"
app_insights_app_prod_name            = "USEUEYXU01AAI03"
resource_group_name_app_pilot         = "USEUEYXU01RSG03"
resource_group_name_app_prod          = "USEUEYXU01RSG04"
key_vault_name                        = "USEUEYXU01AKV02"

#####################################
#### STORAGE ACCOUNT ################
#####################################
# General Storage Account setting
account_infra_encryption_enabled = true

####### storage_account_app_01
storage_account_app_01                                 = "USEUEYXU01STA02"
account_tier_storage_account_app_01                    = "Standard"
account_replication_type_storage_account_app_01        = "LRS"
allow_nested_items_to_be_public_storage_account_app_01 = false

####### storage_account_app_02
storage_account_app_02                                 = "USEUEYXU01STA05"
account_tier_storage_account_app_02                    = "Standard"
account_replication_type_storage_account_app_02        = "LRS"
allow_nested_items_to_be_public_storage_account_app_02 = false

#########################
#### SERVICE PLAN ######
#########################
### app_service_plan_ui ########
app_service_plan_name_app_01 = "USEUEYXU01ASP01"
os_type_service_plan_app_01  = "Windows"
sku_name_service_plan_app_01 = "P1v3"

### app_service_plan_apis ########
app_service_plan_name_app_02 = "USEUEYXU01ASP02"
os_type_service_plan_app_02  = "Windows"
sku_name_service_plan_app_02 = "P2v3"

# API App Service Plan Autoscaling Configuration
enable_autoscale_app_02 = true

### app_service_plan_functions ########
app_service_plan_name_app_03 = "USEUEYXU01ASP03"
os_type_service_plan_app_03  = "Windows"
sku_name_service_plan_app_03 = "P1v3"

######################
#### WEB APPS ########
######################
x_azure_fdid                          = "1df2680c-a09b-4526-a390-d8f4b97aa29f"
app_service_kind                      = "webapp"
enable_telemetry                      = false
enable_application_insights           = false
https_only                            = true
minimum_tls_version                   = "1.2"
diagnostic_settings_log_groups        = ["allLogs"]
diagnostic_settings_metric_categories = ["AllMetrics"]

### app_service_windows_ui #####
web_app_name_app_01                     = "USEUEYXU01WAP01"
web_app_https_only_app_01               = true
web_app_always_on_app_01                = true
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
    "https://api.eyquat.eyfabric.ey.com",
    "https://eyq-uat2.eyfabric.ey.com",
    "https://eyx-uat-lab-use.ey.com",
  ]
  support_credentials = true
}

### app_service_windows_web_api #####
web_app_name_app_02                     = "USEUEYXU01WAP02"
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
    "http://localhost:3000",
    "https://api.eyquat.eyfabric.ey.com",
    "https://apim.eyx-uat-lab-use.ey.com",
    "https://eyq-uat2.eyfabric.ey.com",
    "https://eyx-uat-lab-use.ey.com",
    "https://localhost:3000",
    "https://useueyxu01wap04.azurewebsites.net",
  ]
  support_credentials = true
}

### app_service_windows_notice_api #####
web_app_name_app_03                         = "USEUEYXU01WAP03"
web_app_https_only_app_03                   = true
web_app_always_on_app_03                    = true
web_app_ftps_state_app_03                   = "FtpsOnly"
web_app_scm_type_app_03                     = "None"
#web_app_use_32_bit_worker_app_03            = true # Moved to locals
web_app_websockets_enabled_app_03           = false
#web_app_managed_pipeline_mode_app_03        = "Integrated" # Moved to locals
web_app_remote_debugging_enabled_app_03     = false
web_app_current_stack_app_03                = "dotnet"
web_app_dotnet_version_app_03               = "v8.0"
web_app_identity_type_app_03                = "SystemAssigned"
site_config_app_03                          = {}
app_service_windows_notice_api_app_settings = {}

### app_service_windows_kernel_memory #####
web_app_name_app_04                            = "USEUEYXU01WAP04"
web_app_https_only_app_04                      = true
#web_app_always_on_app_04                       = true # Moved to locals
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
function_app_name_app_01                          = "USEUEYXU01AZF01"
dotnet_version_funct_app_01                       = "v8.0"
function_current_stack_app_01                     = "dotnet"
function_public_network_access_enabled            = false
function_app_01_app_settings = {
  # UAT-Lab specific: Disable certain Azure WebJobs to preserve existing configuration
  "AzureWebJobs.RatingCalculation_TimerStart.Disabled"                      = "1"
  "AzureWebJobs.StatelessChat_CleanupInactiveChats_Activity.Disabled"       = "1"
  "AzureWebJobs.StatelessChat_GetChatSessions_Activity.Disabled"            = "1"
  "AzureWebJobs.StatelessChat_OrchestratorDisabled"                         = "1"
  "AzureWebJobs.StatelessChat_Timer.Disabled"                               = "1"
  # Agent Testing Framework
  "ChatStore:Cosmos:TestCaseContainer"         = "testCase"
  "ChatStore:Cosmos:TestResultContainer"       = "testResult"
  "ChatStore:Cosmos:TestSuiteContainer"        = "testSuite"
  "GithubWorkflowOwner"                        = "ey-org"
  "GithubWorkflowRepo"                         = "il-eyx-mfe"
  "GithubWorkflowToken"                        = "@Microsoft.KeyVault(VaultName=USEUEYXU01AKV02;SecretName=GithubToken)"
  "GithubWorkflowFile"                         = "agent-workflow-test-gha.yml"
  "GithubWorkflowEnvironment"                  = "uat-lab"
  "GithubWorkflowBranch"                       = "uatlatest"
  "GithubWorkflowTags"                         = "@agenttesting"
  "GithubWorkflowProductName"                  = "AgentStudio"
  "GithubWorkflowInputFileName"                = "input.json"
  "MaxParallelTests"                           = "10"
  "ServiceBus:ActiveQueueName"                 = "agenttestactivequeue"
  "ServiceBus:WaitingQueueName"                = "agenttestwaitqueue"
  "AgentTestActiveQueue"                       = "agenttestactivequeue"
  "AgentTestStorageContainer"                  = "agent-testing-transactions"
  "AgentTestFileStorageContainer"              = "agenttestsuite"
  "SignalRHubName"                             = "MessageRelayHub"
  "Azure:SignalR:ConnectionString"             = "@Microsoft.KeyVault(VaultName=USEUEYXU01AKV02;SecretName=Azure--SignalR--ConnectionString)"
}
kv_secret_storage_connection_string_name = "FuncAppStorageConnectionString"

################
#### SIGNALR  ##
################
#### signalr_name_app_01
signalr_name_app_01      = "USEUEYXU01SNR01"
sku_name_app_01          = "Premium_P1"
sku_capacity_app_01      = 1
signalr_enable_autoscale = true

######################
# CONTAINER REGISTRY #
######################
acr_name                    = "USEUEYXU01ACR01"
acr_sku                     = "Premium"
acr_admin_enabled           = false
acr_zone_redundancy_enabled = false

############################
# CONTAINER APP ENVIRONMENT#
############################
cae_name                      = "USEUEYXU01AME01"
cae_zone_redundancy_enabled   = false
public_network_access_enabled = "enable"
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
container_app_name = "USEUEYXU01ACA01"
container_name     = "app-container"
container_image    = "mcr.microsoft.com/azuredocs/containerapps-helloworld:latest"
container_cpu      = 0.5
container_memory   = "1Gi"

###########################
# SESSION POOL SETTINGS
#########################
session_pool_enabled                 = true
session_pool_name                    = "useueyxu01aca01-python-pool"
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
  "USEUEYXU01WAP02" # Web API app service
  # "USEQCXS05HWAP01"  # Uncomment to include UI app service
  # "USEQCXS05HWAP03",  # Uncomment to include Notice API app service
  # "USEQCXS05HWAP04"   # Uncomment to include Kernel Memory app service
]

#########################
# AZURE OPENAI SERVICE  #
#########################
# openai_account_name = "USEUEYXU01AOA01"
openai_sku_name                      = "S0"
openai_custom_subdomain_name         = "USEUEYXU01AOA01"
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
speech_account_name                  = "USEUEYXU01SPC01"
speech_service_custom_subdomain_name = "USEUEYXU01SPC01"
speech_sku_name                      = "S0"

#######################################
# AZURE DOCUMENT INTELLIGENCE SERVICE #
#######################################
document_intelligence_account_name          = "USEUEYXU01ADI01"
document_intelligence_custom_subdomain_name = "USEUEYXU01ADI01"
document_intelligence_sku_name              = "S0"

######################################
#### PRIVATE ENDPOINTS NAMES #########
######################################
web_app_ui_pep_name                     = "USEUEYXU01PEP0D"
web_app_api_pep_name                    = "USEUEYXU01PEP0E"
web_app_notice_api_pep_name             = "USEUEYXU01PEP0F"
web_app_kernel_memory_pep_name          = "USEUEYXU01PEP0G"
function_app_pep_name                   = "USEUEYXU01PEP0H"
storage_account_app_logs_pep_name_queue = "USEUEYXU01PEP0I"
storage_account_app_pep_name_blob       = "USEUEYXU01PEP0J"
storage_account_app_pep_name_table      = "USEUEYXU01PEP0K"
storage_account_app_pep_name_queue      = "USEUEYXU01PEP0L"
storage_account_app_logs_pep_name_blob  = "USEUEYXU01PEP0M"
speech_account_pep_name                 = "USEUEYXU01PEP0N"
document_intelligence_pep_name          = "USEUEYXU01PEP0O"
container_registry_pep_name             = "USEUEYXU01PEP0P"
# Container App Environment PEP - requires DNS zone to be created first
# container_app_environment_pep_name      = "USEUEYXU01PEP2A"