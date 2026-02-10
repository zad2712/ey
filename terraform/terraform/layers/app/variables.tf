##################
#### GENERAL######
##################
# variable "tags" {
#   description = "Etiquetas estándar CTP"
#   type        = map(string)
# }

variable "deploy_resource" {
  description = "Deploy admin resources"
  type        = bool
  default     = true
}

## Function & App Services Managed Identities config
variable "managed_identities" {
  description = "Configuration for managed identities assigned to Function and App Services. Allows enabling system-assigned identity and specifying user-assigned identity resource IDs."
  type = object({
    system_assigned            = bool
    user_assigned_resource_ids = optional(set(string), [])
  })
  default = {
    system_assigned = true
  }
}

variable "env" {
  description = "Environment type (DEV, QA, UAT, PROD)"
  type        = string
  validation {
    condition     = contains(["DEV", "QA", "UAT", "PROD"], var.env)
    error_message = "Environment must be one of: DEV, QA, UAT, PROD."
  }
}

variable "inactive_agent_purge_days" {
  description = "Number of days before inactive agents are purged"
  type        = number
  default     = 90
}

#####################
### SHARED DATA ####
####################
variable "resource_group_name_admin" {
  description = "resource_group admin name"
  type        = string
  default     = null
}
variable "resource_group_name_app" {
  description = "resource_group app name"
  type        = string
  default     = null
}
variable "log_analytics_workspace_admin_name" {
  type        = string
  description = "Log Analytics Workspace admin name"
  default     = null
}
variable "log_analytics_workspace_app_name" {
  type        = string
  description = "Log Analytics Workspace app name"
  default     = null
}

variable "app_insights_name" {
  description = "Name of an existing Application Insights instance to read (optional)."
  type        = string
  default     = null
}

variable "app_insights_app_pilot_name" {
  description = "Name of an existing Application Insights instance used for the Pilot environment (optional)."
  type        = string
  default     = null
}

variable "app_insights_app_prod_name" {
  description = "Name of an existing Application Insights instance used for the Prod environment (optional)."
  type        = string
  default     = null
}

variable "resource_group_name_app_pilot" {
  description = "App sub env Pilot instance Resource Group name"
  type        = string
  default     = null
}

variable "resource_group_name_app_prod" {
  description = "App sub env Prod instance Resource Group name"
  type        = string
  default     = null
}

variable "key_vault_name" {
  description = "App Key Vault resource name"
  type        = string
  default     = null
}

variable "kv_secret_storage_connection_string_name" {
  description = "Key Vault secret name for the storage connection string"
  type        = string
  default     = null
}

#### vnet admin #####
variable "vnet_admin_name_01" {
  description = "vnet admin name"
  type        = string
  default     = null
}

variable "subnet_admin_name_01" {
  description = "subnet admin name"
  type        = string
  default     = null
}

variable "vnet_app_name_01" {
  description = "vnet app name"
  type        = string
  default     = null
}
variable "subnet_app_name_01" {
  description = "subnet admin name"
  type        = string
  default     = null
}

variable "subnet_app_name_02" {
  description = "subnet admin name"
  type        = string
  default     = null
}

variable "subnet_app_name_03" {
  description = "subnet admin name"
  type        = string
  default     = null
}

## Backend VNet
variable "vnet_app_name_02" {
  description = "vnet app_02 name (backend vnet name)"
  type        = string
  default     = null
}

#### Backend Subnet1 /27 ####
variable "subnet1_name_app_02" {
  description = "Backend subnet1 name"
  type        = string
  default     = null
}

#### Backend Subnet2 /27 ####
variable "subnet2_name_app_02" {
  description = "Backend subnet2 name"
  type        = string
  default     = null
}

#### Backend Subnet3 /26 ####
variable "subnet3_name_app_02" {
  description = "Backend subnet3 name"
  type        = string
  default     = null
}

variable "storage_account_app_name_01" {
  description = "storage_account app name"
  type        = string
  default     = null
}

variable "document_intelligence_custom_subdomain_name" {
  description = "Custom subdomain name for the Azure Document Intelligence account."
  type        = string
  default     = null
}

variable "document_intelligence_sku_name" {
  description = "SKU for the Azure Document Intelligence account."
  type        = string
  default     = "S0"
}
variable "document_intelligence_tags" {
  description = "Tags for the Azure Document Intelligence account"
  type        = map(string)
  default     = {}
}

#####################################
#### STORAGE ACCOUNT ################
#####################################
####### storage_account_admin_01
variable "storage_account_admin_01" {
  type        = string
  description = "storage_account name"
  default     = null
}
variable "account_tier_storage_account_admin_01" {
  type        = string
  description = "account_tier storage_account"
  default     = null
}
variable "account_replication_type_storage_account_admin_01" {
  type        = string
  description = "account_replication_typ storage_account"
  default     = null
}

variable "allow_nested_items_to_be_public_storage_account_admin_01" {
  type        = bool
  description = "Allow or disallow nested items to be public for storage account"
  default     = false
}
variable "deploy_storage_account_admin_01" {
  description = "Deploy admin resources"
  type        = bool
  default     = false
}

####### storage_account_app_01
variable "storage_account_app_01" {
  type        = string
  description = "storage_account name"
  default     = null
}
variable "account_tier_storage_account_app_01" {
  type        = string
  description = "account_tier storage_account"
  default     = null
}
variable "account_replication_type_storage_account_app_01" {
  type        = string
  description = "account_replication_typ storage_account"
  default     = null
}

variable "allow_nested_items_to_be_public_storage_account_app_01" {
  type        = bool
  description = "Allow or disallow nested items to be public for storage account"
  default     = false
}

variable "storage_account_app_tags" {
  description = "Tags for the storage account"
  type        = map(string)
  default     = {}

}

variable "storage_ip_rules" {
  description = "List of IP addresses or CIDR ranges to allow access to the storage account. If empty, no IP rules will be applied."
  type        = list(string)
  default     = []
}

####### storage_account_app_02
variable "storage_account_app_02" {
  type        = string
  description = "storage_account name"
  default     = null
}
variable "account_tier_storage_account_app_02" {
  type        = string
  description = "account_tier storage_account"
  default     = null
}
variable "account_replication_type_storage_account_app_02" {
  type        = string
  description = "account_replication_typ storage_account"
  default     = null
}

variable "allow_nested_items_to_be_public_storage_account_app_02" {
  type        = bool
  description = "Allow or disallow nested items to be public for storage account"
  default     = false
}

variable "storage_account_app_02_tags" {
  description = "Tags for the storage account"
  type        = map(string)
  default     = {}

}

variable "blob_delete_retention_policy_days" {
  description = "blob delete retention policy days"
  type        = number
  default     = 14
}

############################################
# Azure Container Registry (ACR) Variables #
############################################

variable "container_registry_public_network_access_enabled" {
  description = "Enable public network access for the Azure Container Registry"
  type        = bool
  default     = false
}

variable "acr_admin_enabled" {
  description = "Enable admin user for ACR"
  type        = bool
  default     = true
}

variable "acr_name" {
  description = "Name for the Azure Container Registry"
  type        = string
}

variable "acr_sku" {
  description = "SKU for the Azure Container Registry"
  type        = string
  default     = "Standard"
}
variable "acr_tags" {
  description = "Tags for the Azure Container Registry"
  type        = map(string)
  default     = {}
}

variable "acr_zone_redundancy_enabled" {
  description = "Enable zone redundancy for the Azure Container Registry."
  type        = bool
  default     = true
}

##################################################
#Azure Container App Environment (CAE) Variables #
##################################################
variable "cae_dapr_app_insights_connection_string" {
  description = "Application Insights connection string for Dapr in Container App Environment."
  type        = string
  default     = null
  sensitive   = true
}

variable "cae_infrastructure_subnet_id" {
  description = "The ID of the Subnet to use for the Container App Environment infrastructure. If null, one will be created by CAE. If provided, it must be delegated to 'Microsoft.App/environments' and be /23 or larger."
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "Whether to enable workload profiles for the Container App Environment. Required for session pools."
  type        = string
  default     = "Enabled"
}

variable "cae_name" {
  description = "Name for the Azure Container App Environment"
  type        = string
}

variable "cae_zone_redundancy_enabled" {
  description = "Enable zone redundancy for the Container App Environment."
  type        = bool
  default     = false
}

variable "cae_tags" {
  description = "Tags for the Azure Container App Environment"
  type        = map(string)
  default     = {}
}

variable "cae_workload_profile_enabled" {
  description = "Whether to enable workload profiles for the Container App Environment. Required for session pools."
  type        = bool
  default     = false
}

variable "cae_workload_profiles" {
  description = "List of workload profiles for the Container App Environment. Required when workload_profile_enabled is true."
  type = list(object({
    name                  = string
    workload_profile_type = string
    minimum_count         = number
    maximum_count         = number
  }))
  default = []
}

################################
#Azure Container App Variables #
################################

variable "container_app_name" {
  description = "Name for the Azure Container App."
  type        = string
}

variable "container_cpu" {
  description = "CPU cores allocated to the container."
  type        = number
  # Default is set in the module, can be overridden here if needed for the layer
  # default     = 0.25
}

variable "container_image" {
  description = "Docker image for the container."
  type        = string
}

variable "container_memory" {
  description = "Memory allocated to the container (e.g., '0.5Gi')."
  type        = string
  # Default is set in the module, can be overridden here if needed for the layer
  # default     = "0.5Gi"
}

variable "container_name" {
  description = "Name for the container within the Azure Container App."
  type        = string
  # Default is set in the module, can be overridden here if needed for the layer
  # default     = "app-container"
}

variable "container_app_tags" {
  description = "Tags for the Azure Container App"
  type        = map(string)
  default     = {}
}

#########################
## Container App Session Pool
#########################
#################################
# Container App Session Pool     #
#################################

variable "session_pool_enabled" {
  description = "Whether to create the Container Apps session pool"
  type        = bool
  default     = false
}

variable "session_pool_name" {
  description = "Name of the Container App session pool"
  type        = string
  default     = null
}

variable "session_pool_max_concurrent_sessions" {
  description = "Maximum number of concurrent sessions allowed in the pool (1-1000)"
  type        = number
  default     = 10
}

variable "session_pool_ready_instances" {
  description = "Target number of sessions to keep ready in the pool"
  type        = number
  default     = 5
}

variable "session_pool_cooldown_period_seconds" {
  description = "Number of seconds a session can be idle before termination (300-3600)"
  type        = number
  default     = 300
}

variable "session_pool_target_port" {
  description = "The session port used for ingress traffic"
  type        = number
  default     = 80
}

variable "session_pool_network_status" {
  description = "Network status for session pool (EgressEnabled or EgressDisabled)"
  type        = string
  default     = "EgressDisabled"
}

variable "session_pool_container_type" {
  description = "Type of container for the session pool (PythonLTS or CustomContainer)"
  type        = string
  default     = "CustomContainer"
}

# Container configuration
variable "session_pool_container_name" {
  description = "Name of the container in the session pool"
  type        = string
  default     = null
}

variable "session_pool_container_image" {
  description = "Container image to use for sessions"
  type        = string
  default     = null
}

variable "session_pool_container_cpu" {
  description = "CPU allocation per session container (0.25-2.0)"
  type        = number
  default     = 0.25
}

variable "session_pool_container_memory" {
  description = "Memory allocation per session container (e.g., '0.5Gi', '1Gi')"
  type        = string
  default     = "0.5Gi"
}

variable "session_pool_container_command" {
  description = "Optional command override for the container"
  type        = list(string)
  default     = null
}

variable "session_pool_container_args" {
  description = "Optional arguments for the container command"
  type        = list(string)
  default     = null
}

# Registry authentication (optional)
variable "session_pool_registry_server" {
  description = "Container registry server hostname"
  type        = string
  default     = null
}

variable "session_pool_registry_username" {
  description = "Username for container registry authentication"
  type        = string
  default     = null
}

variable "session_pool_registry_password_secret" {
  description = "Name of the secret containing the registry password"
  type        = string
  default     = null
}

# Environment and secrets (optional)
variable "session_pool_environment_variables" {
  description = "Environment variables to set in the container sessions"
  type        = map(string)
  default     = null
}

variable "session_pool_secrets" {
  description = "List of secrets for the session pool"
  type = list(object({
    name  = string
    value = string
  }))
  default   = null
  sensitive = true
}

# Role assignment variables for session pool
variable "session_pool_role_assignments" {
  description = "List of role assignments for the session pool"
  type = list(object({
    principal_id   = string
    principal_type = optional(string, "User")
    role_name      = string
  }))
  default = []
}

variable "session_pool_enable_default_roles" {
  description = "Whether to enable default Container Apps session roles (Sessions Executor and SessionPools Contributor)"
  type        = bool
  default     = true
}

variable "session_pool_default_role_principals" {
  description = "Principal IDs to assign default Container Apps session roles to"
  type = list(object({
    principal_id   = string
    principal_type = optional(string, "User")
  }))
  default = []
}

variable "session_pool_app_service_managed_identities" {
  description = "List of app service names whose managed identities should be granted Container Apps session roles"
  type        = list(string)
  default     = [""] # Default includes the Notice API app service
}

################################
#Azure OpenAI Service Variables#
################################
variable "openai_account_name" {
  description = "Name for the Azure OpenAI account. Set to null to disable OpenAI deployment."
  type        = string
  default     = null
}

variable "openai_sku_name" {
  description = "SKU for the Azure OpenAI account."
  type        = string
  default     = "S0"
}

variable "deployments" {
  description = "A map of OpenAI model deployments to create."
  type = map(object({
    deployment_name = string
    model_format    = string
    model_name      = string
    model_version   = string
    sku_name        = string
    sku_capacity    = number
  }))
  default = {}
}

variable "openai_custom_subdomain_name" {
  description = "Custom subdomain name for the Azure OpenAI account."
  type        = string
  default     = null
}

variable "openai_public_network_access_enabled" {
  description = "Whether public network access is enabled for the OpenAI account. Set to null to use module default (true)."
  type        = bool
  default     = null
}

###########################################
# Azure Cognitive Speech Service Variables#
###########################################
variable "speech_account_name" {
  description = "Name for the Azure Cognitive Speech account. Set to null to disable deployment."
  type        = string
  default     = null
}

variable "speech_account_location" {
  description = "Name for the Azure Cognitive Speech account. Set to null to disable deployment."
  type        = string
  default     = ""
}

variable "speech_service_custom_subdomain_name" {
  description = "Custom subdomain name for the Azure Cognitive Speech Service account."
  type        = string
  default     = null
}

variable "speech_sku_name" {
  description = "SKU for the Azure Cognitive Speech account."
  type        = string
  default     = "S0"
}

variable "speech_account_tags" {
  description = "Tags for the Azure Cognitive Speech account"
  type        = map(string)
  default     = {}
}

// Azure Document Intelligence Service Variables
variable "document_intelligence_account_name" {
  description = "Name for the Azure Document Intelligence account. Set to null to disable deployment."
  default     = null
}

variable "document_intelligence_account_location" {
  description = "Location for the Azure Document Intelligence account."
  type        = string
  default     = ""
}

#########################
#### Service plans ######
#########################
### app_service_plan_ui #####
variable "app_service_plan_name_app_01" {
  description = "app service plan name"
  type        = string
}

variable "os_type_service_plan_app_01" {
  description = "os_type service plan"
  type        = string
}
variable "sku_name_service_plan_app_01" {
  description = "sku name plan name"
  type        = string
}
variable "app_service_plan_ui_tags" {
  description = "App Service Plan UI tags"
  type        = map(string)
  default     = {}
}


### app_service_plan_apis #####
variable "app_service_plan_name_app_02" {
  description = "app service plan name"
  type        = string
}

variable "os_type_service_plan_app_02" {
  description = "os_type service plan"
  type        = string
}
variable "sku_name_service_plan_app_02" {
  description = "sku name plan name"
  type        = string
}

variable "enable_autoscale_app_02" {
  description = "Enable autoscaling for API App Service Plan"
  type        = bool
  default     = false
}

variable "app_service_plan_apis_tags" {
  description = "App Service Plan API tags"
  type        = map(string)
  default     = {}
}

### app_service_plan_functions #####
variable "app_service_plan_name_app_03" {
  description = "app service plan name"
  type        = string
}

variable "os_type_service_plan_app_03" {
  description = "os_type service plan"
  type        = string
}
variable "sku_name_service_plan_app_03" {
  description = "sku name plan name"
  type        = string
}
variable "app_service_plan_functions_tags" {
  description = "App Service Plan Function tags"
  type        = map(string)
  default     = {}
}


######################
#### web apps ########
######################
variable "enable_telemetry" {
  description = "Enable telemetry for the resources. Default is false."
  type        = bool
  default     = false
}

variable "enable_application_insights" {
  description = "Enable Application Insights for the App Service. Default is false."
  type        = bool
  default     = false
}

variable "https_only" {
  description = "Enables https_only for the web app. Default is true."
  type        = bool
  default     = true
}

variable "minimum_tls_version" {
  description = "Minimum TLS version for the web app. Default is '1.2'."
  type        = string
  default     = "1.2"
}

variable "diagnostic_settings_log_groups" {
  description = "Log groups for diagnostic settings"
  type        = set(string)
  default     = []
}

variable "diagnostic_settings_metric_categories" {
  description = "Metric categories for diagnostic settings"
  type        = set(string)
  default     = []
}
### app_service_windows_ui #####
variable "web_app_name_app_01" {
  description = "web app name"
  type        = string
}
variable "web_app_current_stack_app_01" {
  description = "web app current_stack"
  type        = string
}
variable "web_app_dotnet_version_app_01" {
  description = "web app dotnet_version"
  type        = string
}
variable "site_config_app_01" {
  description = "Optional site_config configuration for the App Service"
  type        = any
  default     = {}
}
variable "app_service_ui_tags" {
  description = "App Service UI tags"
  type        = map(string)
  default     = {}
}

variable "app_service_windows_ui_app_settings" {
  description = "App Service Windows UI application settings"
  type        = map(string)
  default     = {}
}

variable "app_service_windows_ui_sticky_settings" {
  description = "App Service Windows UI sticky settings"
  type = map(object({
    app_setting_names       = optional(list(string))
    connection_string_names = optional(list(string))
  }))
  default = {}
}

variable "app_service_windows_ui_cors" {
  description = "App Service Windows UI CORS settings"
  type = object({
    allowed_origins     = optional(list(string))
    support_credentials = optional(bool)
  })
  default = null
}

### app_service_windows_web_api #####
variable "web_app_name_app_02" {
  description = "web app name"
  type        = string
}
variable "web_app_current_stack_app_02" {
  description = "web app current_stack"
  type        = string
}
variable "web_app_dotnet_version_app_02" {
  description = "web app dotnet_version"
  type        = string
}
variable "site_config_app_02" {
  description = "Optional site_config configuration for the App Service"
  type        = any
  default     = {}
}
variable "app_service_api_tags" {
  description = "App Service API tags"
  type        = map(string)
  default     = {}
}

variable "app_service_windows_api_app_settings" {
  description = "App Service Windows API application settings"
  type        = map(string)
  default     = {}
}

variable "app_service_windows_api_sticky_settings" {
  description = "App Service Windows API sticky settings"
  type = map(object({
    app_setting_names       = optional(list(string))
    connection_string_names = optional(list(string))
  }))
  default = {}
}

variable "app_service_windows_api_cors" {
  description = "App Service Windows API CORS settings"
  type = object({
    allowed_origins     = optional(list(string))
    support_credentials = optional(bool)
  })
  default = null
}

### app_service_windows_notice_api #####
variable "web_app_name_app_03" {
  description = "web app name"
  type        = string
}
variable "web_app_current_stack_app_03" {
  description = "web app current_stack"
  type        = string
}
variable "web_app_dotnet_version_app_03" {
  description = "web app dotnet_version"
  type        = string
}
variable "site_config_app_03" {
  description = "Optional site_config configuration for the App Service"
  type        = any
  default     = {}
}
variable "app_service_noticeapi_tags" {
  description = "App Service Notice API tags"
  type        = map(string)
  default     = {}
}

variable "app_service_windows_notice_api_app_settings" {
  description = "App Service Windows UI application settings"
  type        = map(string)
  default     = {}
}

variable "app_service_windows_notice_api_sticky_settings" {
  description = "App Service Windows UI sticky settings"
  type = map(object({
    app_setting_names       = optional(list(string))
    connection_string_names = optional(list(string))
  }))
  default = {}
}

### app_service_windows_kernel_memory #####
variable "web_app_name_app_04" {
  description = "web app name"
  type        = string
}
variable "web_app_current_stack_app_04" {
  description = "web app current_stack"
  type        = string
}
variable "web_app_dotnet_version_app_04" {
  description = "web app dotnet_version"
  type        = string
}
variable "site_config_app_04" {
  description = "Optional site_config configuration for the App Service"
  type        = any
  default     = {}
}
variable "app_service_kernelapi_tags" {
  description = "App Service Kernel API tags"
  type        = map(string)
  default     = {}
}

variable "app_service_windows_kernel_memory_app_settings" {
  description = "App Service Windows Kernel Memory application settings"
  type        = map(string)
  default     = {}
}

variable "app_service_windows_kernel_memory_sticky_settings" {
  description = "App Service Windows Kernel Memory sticky settings"
  type = map(object({
    app_setting_names       = optional(list(string))
    connection_string_names = optional(list(string))
  }))
  default = {}
}

#####################################
#### vnet webapp integration ########
#####################################


#####################################
#### function app    ################
#####################################
##########function_app_name_app_01 
variable "function_app_name_app_01" {
  description = "function app name"
  type        = string
}
variable "dotnet_version_funct_app_01" {
  description = "dotnet_version"
  type        = string
}
variable "app_service_functions_tags" {
  description = "App Service Functions tags"
  type        = map(string)
  default     = {}
}

variable "function_current_stack_app_01" {
  description = "Current stack for the Function App"
  type        = string
}

variable "function_app_01_app_settings" {
  description = "App settings for the Function App"
  type        = map(string)
  default     = {}
}

variable "function_ftp_publish_basic_authentication_enabled" {
  description = "ftp publish basic authentication enabled"
  type        = bool
  default     = false
}

variable "function_public_network_access_enabled" {
  description = "Should public network access be enabled for the Function App"
  type        = bool
  default     = false
}

variable "function_ip_restriction_default_action" {
  description = "ip_restriction_default_action for the function App"
  type        = string
  default     = "Deny"
}

variable "function_scm_ip_restriction_default_action" {
  description = "scm_ip_restriction_default_action for the function App"
  type        = string
  default     = "Deny"
}
#####################################
#### signalr   #####################
#####################################
#### signalr_name_app_01
variable "signalr_name_app_01" {
  description = "Nombre del recurso SignalR."
  type        = string
}


variable "sku_name_app_01" {
  description = "SKU del SignalR (Ej: Free_F1, Standard_S1)."
  type        = string
}

variable "sku_capacity_app_01" {
  description = "Capacidad del SKU."
  type        = number
}

variable "signalr_tags" {
  description = "Tags for the SignalR resource"
  type        = map(string)
  default     = {}
}

variable "signalr_enable_autoscale" {
  description = "Enable Azure Monitor autoscale for Premium tier SignalR Service"
  type        = bool
  default     = false
}

######################################
#### PRIVATE ENDPOINTS NAMES #########
######################################
variable "function_app_pep_name" {
  description = "Private endpoint name for the Function App"
  type        = string
  default     = ""
}

variable "web_app_ui_pep_name" {
  description = "Private endpoint name for the UI web app"
  type        = string
  default     = ""
}

variable "web_app_api_pep_name" {
  description = "Private endpoint name for the API web app"
  type        = string
  default     = ""
}

variable "web_app_notice_api_pep_name" {
  description = "Private endpoint name for the Notice API web app"
  type        = string
  default     = ""
}

variable "web_app_kernel_memory_pep_name" {
  description = "Private endpoint name for the Kernel API web app"
  type        = string
  default     = ""
}

variable "signalr_pep_name" {
  description = "Private endpoint name for the SignalR service"
  type        = string
  default     = ""
}

# storage_account_app_01 - app
variable "storage_account_app_pep_name_blob" {
  description = "Private endpoint name for the Storage Account App Blob"
  type        = string
  default     = ""
}

variable "storage_account_app_pep_name_table" {
  description = "Private endpoint name for the Storage Account App Table"
  type        = string
  default     = ""
}

variable "storage_account_app_pep_name_queue" {
  description = "Private endpoint name for the Storage Account App Queue"
  type        = string
  default     = ""
}

# storage_account_app_02 - app logs
variable "storage_account_app_logs_pep_name_blob" {
  description = "Private endpoint name for the Storage Account App Logs Blob"
  type        = string
  default     = ""
}

variable "storage_account_app_logs_pep_name_queue" {
  description = "Private endpoint name for the Storage Account App Logs Queue"
  type        = string
  default     = ""
}

variable "speech_account_pep_name" {
  description = "Private endpoint name for the Speech Service"
  type        = string
  default     = ""
}

variable "document_intelligence_pep_name" {
  description = "Private endpoint name for the Document Intelligence Service"
  type        = string
  default     = ""
}

variable "container_registry_pep_name" {
  description = "Private endpoint name for the Container Registry"
  type        = string
  default     = ""
}

variable "container_app_environment_pep_name" {
  description = "Private endpoint name for the Container App Environment"
  type        = string
  default     = ""
}

variable "app_private_endpoints" {
  description = "Map of private endpoints to create."
  type = map(object({
    name                = string
    subnet_id           = string
    connection_name     = string
    resource_id         = string
    subresource_names   = list(string)
    private_dns_zone_id = string
    tags                = map(string)
  }))
  default = {}
}

variable "hidden_title_tag_env" {
  type        = string
  default     = null
  description = "The environment name used by the hidden title tag, e.g. dev1, dev2, uat-lab, prod."
}

variable "x_azure_fdid" {
  description = "Azure Front Door ID"
  type        = string
  default     = null
}

variable "account_infra_encryption_enabled" {
  description = "Enable infrastructure encryption for the storage account"
  type        = bool
  default     = false
}

variable "storage_public_network_access_enabled" {
  description = "public network access"
  type        = bool
  default     = false
}

### Malware Scan - Event Grid
variable "enable_malware_scanning" {
  description = "Enable Microsoft Defender for Storage malware scanning on the storage account"
  type        = bool
  default     = true
}

###################################
### TERRAFORM REMOTE STATE CONFIG #
###################################

variable "backend_resource_group_name" {
  description = "Resource group name where terraform state is stored"
  type        = string
  default     = null
}

variable "backend_storage_account_name" {
  description = "Storage account name where terraform state is stored"
  type        = string
  default     = null
}

variable "backend_container_name" {
  description = "Container name where terraform state is stored"
  type        = string
  default     = "terraform"
}

variable "backend_subscription_id" {
  description = "Subscription ID where terraform backend is located"
  type        = string
  default     = null
}