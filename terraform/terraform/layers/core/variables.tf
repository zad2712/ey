##################
#### GENERAL #####
##################
variable "env" {
  description = "(Optional). Environment identifier (e.g., DEV1, DEV2, DEV3, QA, UAT, PROD). Used by shared module for conditional logic."
  type        = string
  default     = null
}

variable "location" {
  description = "(Required). The location where the resource group will be created."
  type        = string
}

variable "enable_telemetry" {
  description = "(Optional). Enable or disable telemetry for the module. Default is false."
  type        = bool
  default     = false
}

variable "lock" {
  description = <<-EOT
    Controls the Resource Lock configuration for this resource. The following properties can be specified:
    - kind (Required): The type of lock. Possible values are "CanNotDelete" and "ReadOnly".
    - name (Optional): The name of the lock. If not specified, a name will be generated based on the kind value. Changing this forces the creation of a new resource.
  EOT
  type = object({
    kind = string
    name = optional(string, null)
  })
  default = null
}

variable "create_delete_lock" {
  description = "(Optional). When true, create a management lock (CanNotDelete) on the core resource group. Intended to be set in environment tfvars for UAT/Prod."
  type        = bool
  default     = false
}

variable "delete_lock_name" {
  description = "(Optional). Name to assign to the delete lock. If not set, a name will be generated from the resource group name."
  type        = string
  default     = null
}

variable "enable_default_role_assignments" {
  description = <<-EOT
    (Optional). When true, applies default RBAC role assignments for Tax Dev, EYX Dev, Tax Admin, and DevOps teams.
    Set to false for QA and higher environments to preserve existing RBAC configurations.
    Default is true for Dev environments.
  EOT
  type        = bool
  default     = true
}

##########################
####  RESOURCE GROUP #####
##########################
variable "resource_group_name" {
  description = "(Required). The name of the resource group to create."
  type        = string
}

variable "resource_group_role_assignments" {
  description = "(Optional). A map of role assignments to create on this resource. The map key is arbitrary. See AVM module documentation for details."
  type = map(object({
    role_definition_id_or_name       = string
    principal_id                     = string
    skip_service_principal_aad_check = optional(bool, false)
  }))
  default = {}
}

######################################
#### AVM LOG ANALYTICS WORKSPACE #####
######################################
variable "log_analytics_workspace_name" {
  description = "(Required). The name of the Log Analytics Workspace to create."
  type        = string
}

variable "log_analytics_workspace_identity" {
  description = <<-EOT
    Specifies the identity configuration for the Log Analytics Workspace.
    - identity_ids (Optional): Specifies a list of user managed identity ids to be assigned. Required if `type` is `UserAssigned`.
    - type (Required): Specifies the identity type of the Log Analytics Workspace. Possible values are `SystemAssigned` and `UserAssigned`.
  EOT
  type = object({
    identity_ids = optional(set(string))
    type         = string
  })
  default = null
}

variable "log_analytics_workspace_retention_in_days" {
  description = "(Optional). The retention period (in days) for the Log Analytics Workspace data. Default is 365 days."
  type        = number
  default     = 365
}

variable "workspace_resource_id" {
  description = "Resource ID del Log Analytics Workspace para los diagnósticos del Key Vault"
  type        = string
  default     = null
}
####################
#### KEY VAULT #####
####################
variable "key_vault_name" {
  description = "(Required). The name of the Key Vault to create."
  type        = string
}

variable "key_vault_diagnostic_settings" {
  description = <<-EOT
    A map of diagnostic settings to create on the Key Vault. The map key is arbitrary. See AVM module documentation for details.
    - name (Optional): The name of the diagnostic setting. One will be generated if not set, but this will not be unique if you want to create multiple diagnostic setting resources.
    - log_categories (Optional): A set of log categories to send to the log analytics workspace. Defaults to [].
    - log_groups (Optional): A set of log groups to send to the log analytics workspace. Defaults to ["allLogs"].
    - metric_categories (Optional): A set of metric categories to send to the log analytics workspace. Defaults to ["AllMetrics"].
    - log_analytics_destination_type (Optional): The destination type for the diagnostic setting. Possible values are "Dedicated" and "AzureDiagnostics". Defaults to "Dedicated".
    - workspace_resource_id (Optional): The resource ID of the log analytics workspace to send logs and metrics to.
    - storage_account_resource_id (Optional): The resource ID of the storage account to send logs and metrics to.
    - event_hub_authorization_rule_resource_id (Optional): The resource ID of the event hub authorization rule to send logs and metrics to.
    - event_hub_name (Optional): The name of the event hub. If none is specified, the default event hub will be selected.
  EOT
  type = map(object({
    workspace_resource_id = optional(string, null)
  }))
  default = {}
}

variable "key_vault_legacy_access_policies" {
  description = <<-EOT
    A map of legacy access policies to create on the Key Vault. The map key is arbitrary. Requires `var.key_vault_legacy_access_policies_enabled` to be `true`. See AVM module documentation for details.
    - object_id: (Required) The object ID of the principal to assign the access policy to.
    - application_id: (Optional) The object ID of an Application in Azure Active Directory. Changing this forces a new resource to be created.
    - certificate_permissions: (Optional) A list of certificate permissions. Possible values are: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers, Update.
    - key_permissions: (Optional) A list of key permissions. Possible values are: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify, WrapKey, Release, Rotate, GetRotationPolicy, SetRotationPolicy.
    - secret_permissions: (Optional) A list of secret permissions. Possible values are: Backup, Delete, Get, List, Purge, Recover, Restore, Set.
    - storage_permissions: (Optional) A list of storage permissions. Possible values are: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS, Update.
  EOT
  type = map(object({
    object_id               = string
    application_id          = optional(string, null)
    certificate_permissions = optional(set(string), [])
    key_permissions         = optional(set(string), [])
    secret_permissions      = optional(set(string), [])
    storage_permissions     = optional(set(string), [])
  }))
  default = {}
}

variable "key_vault_sku_name" {
  description = "The SKU name of the Key Vault. Default is `premium`. Possible values are `standard` and `premium`."
  type        = string
  default     = "premium"
}

variable "key_vault_enabled_for_template_deployment" {
  description = "Specifies whether Azure Resource Manager is permitted to retrieve secrets from the vault."
  type        = bool
  default     = false
}

variable "enabled_for_deployment" {
  description = "Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the vault."
  type        = bool
  default     = true
}

variable "enabled_for_disk_encryption" {
  description = " Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys."
  type        = bool
  default     = true
}

variable "key_vault_public_network_access_enabled" {
  description = "Specifies whether public network access is enabled for the Key Vault. Defaults to true."
  type        = bool
  default     = true
}

variable "key_vault_network_acls" {
  description = <<-EOT
    The network ACL configuration for the Key Vault. If not specified then the Key Vault will be created with a firewall that blocks access. Specify `null` to create the Key Vault with no firewall.
    - bypass: (Optional) Should Azure Services bypass the ACL. Possible values are `AzureServices` and `None`. Defaults to `AzureServices`.
    - default_action: (Optional) The default action when no rule matches. Possible values are `Allow` and `Deny`. Defaults to `Deny`.
    - ip_rules: (Optional) A list of IP rules in CIDR format. Defaults to [].
    - virtual_network_subnet_ids: (Optional) When using with Service Endpoints, a list of subnet IDs to associate with the Key Vault. Defaults to [].
  EOT
  type = object({
    bypass                     = optional(string, "AzureServices")
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = {}
}


###############
#### TAGS #####
###############
variable "tags" {
  description = "A map of tags to assign to the resources."
  type        = map(string)
  default     = {}
}

variable "resource_group_tags" {
  description = "Specific tags for the resource group."
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_tags" {
  description = "Specific tags for the Log Analytics Workspace."
  type        = map(string)
  default     = {}
}

variable "key_vault_tags" {
  description = "Specific tags for the Key Vault."
  type        = map(string)
  default     = {}
}

variable "user_assigned_identity_tags" {
  description = "Specific tags for the User Assigned Identity."
  type        = map(string)
  default     = {}
}

########################
variable "app_insights_name" {
  description = "The name of the Application Insights component."
  type        = string
  default     = null
}

variable "app_insights_application_type" {
  description = "The type of application being monitored. Valid values are: ios, java, MobileCenter, Node.JS, other, phone, store, web."
  type        = string
  default     = "web"
}

variable "app_insights_retention_in_days" {
  description = "The retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730."
  type        = number
  default     = 90
}

variable "app_insights_sampling_percentage" {
  description = "The percentage of telemetry items tracked that are sampled. Valid range: 0-100."
  type        = number
  default     = 100
}

variable "app_insights_tags" {
  description = "Specific tags for the Application Insights component."
  type        = map(string)
  default     = {}
}

########################
#### Azure Workbook ####
########################

variable "workbook_display_name" {
  description = "The display name of the workbook."
  type        = string
  default     = null
}

variable "workbook_tags" {
  description = "Specific tags for the Azure Workbook."
  type        = map(string)
  default     = {}
}

######################################
#### AVM USER MANAGEDIDENTITY #######
######################################
variable "user_assigned_identity_name" {
  description = "(Required). The name of the User Assigned Identity to create."
  type        = string
}

########################
### Virtual Networks ###
########################

## Resource Group and VNet/Subnet names for Admin and App Environments
variable "resource_group_name_admin" {
  description = "The name of the resource group for the admin environment."
  type        = string
  default     = null
}
variable "resource_group_name_app" {
  description = "The name of the resource group for the app environment."
  type        = string
  default     = null
}

## Vnet and Subnet names for Admin Environments
variable "vnet_admin_name_01" {
  description = "The name of the virtual network for the admin environment."
  type        = string
  default     = null
}

variable "subnet_admin_name_01" {
  description = "The name of the subnet for the admin environment."
  type        = string
  default     = null
}

## Dev-specific Admin Resources (for cross-subscription scenarios)
variable "resource_group_name_admin_dev" {
  description = "The name of the resource group for admin resources in Dev environment (cross-subscription)."
  type        = string
  default     = null
}

variable "vnet_name_admin_dev" {
  description = "The name of the virtual network for admin resources in Dev environment (cross-subscription)."
  type        = string
  default     = null
}

## Vnet and Subnet names for App Environments
variable "vnet_app_name_01" {
  description = "The name of the virtual network for the app environment."
  type        = string
  default     = null
}

variable "subnet_app_name_01" {
  description = "The name of the subnet for the app environment."
  type        = string
  default     = null
}

variable "subnet_app_name_02" {
  description = "The name of the subnet for the app environment."
  type        = string
  default     = null
}

variable "subnet_app_name_03" {
  description = "The name of the subnet for the app environment."
  type        = string
  default     = null
}

## Vnet and Subnet names for App Environments - Backend VNet
variable "vnet_app_name_02" {
  description = "The name of the virtual network for the app environment."
  type        = string
  default     = null
}


variable "subnet1_name_app_01" {
  description = "The name of the first subnet for the app environment."
  type        = string
  default     = null
}

variable "subnet1_name_app_02" {
  description = "The name of the first subnet for the app environment."
  type        = string
  default     = null
}

variable "subnet2_name_app_02" {
  description = "The name of the second subnet for the app environment."
  type        = string
  default     = null
}


variable "subnet1_name_app_03" {
  description = "The name of the first subnet for the app environment."
  type        = string
  default     = null
}

variable "subnet3_name_app_02" {
  description = "The name of the third subnet for the app environment"
  type        = string
  default     = null
}



# Optional: create a Delete (CanNotDelete) management lock on the core resource group for UAT/Prod
variable "environment_tag_key" {
  description = "Tag key used to identify the environment (e.g., ENVIRONMENT, Environment, env)"
  type        = string
  default     = "ENVIRONMENT"
}
