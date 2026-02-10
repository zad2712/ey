##################
#### GENERAL #####
##################
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

##########################
#### RESOURCE GROUP ######
##########################
variable "resource_group_name" {
  description = "(Required). The name of the resource group to create."
  type        = string
}

variable "resource_group_role_assignments" {
  description = "(Optional). A map of role assignments to create on this resource. The map key is arbitrary."
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false) # Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
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
  description = "(Optional) The workspace data retention in days. Possible values are either 7 (Free Tier only) or range between 30 and 730."
  type        = number
  default     = null
}

variable "log_analytics_workspace_sku" {
  description = "(Optional) Specifies the SKU of the Log Analytics Workspace. Possible values are `Free`, `PerNode`, `Premium`, `Standard`, `Standalone`, `Unlimited`, `CapacityReservation`, and `PerGB2018` (new SKU as of `2018-04-03`). Defaults to `PerGB2018`."
  type        = string
  default     = null
}

variable "log_analytics_workspace_role_assignments" {
  description = "(Optional). A map of role assignments to create on this resource. The map key is arbitrary. See AVM module documentation for details."
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false) # Note: only set `skip_service_principal_aad_check` to true if you are assigning a role to a service principal.
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
  default = {}
}

variable "log_analytics_workspace_internet_ingestion_enabled" {
  description = "(Optional) Enable or disable internet ingestion for the Log Analytics Workspace. Default is true. Required for Application Insights to access LAW logs without Azure Monitor Private Link."
  type        = bool
  default     = true
}

variable "log_analytics_workspace_internet_query_enabled" {
  description = "(Optional) Enable or disable internet query for the Log Analytics Workspace. Default is true. Required for Application Insights to query LAW data without Azure Monitor Private Link."
  type        = bool
  default     = true
}

########################
#### AVM KEY VAULT #####
########################
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
    name                                     = optional(string, null)
    log_categories                           = optional(set(string), [])
    log_groups                               = optional(set(string), ["allLogs"])
    metric_categories                        = optional(set(string), ["AllMetrics"])
    log_analytics_destination_type           = optional(string, "Dedicated")
    workspace_resource_id                    = optional(string, null)
    storage_account_resource_id              = optional(string, null)
    event_hub_authorization_rule_resource_id = optional(string, null)
    event_hub_name                           = optional(string, null)
  }))
  default = {}
}

variable "key_vault_enabled_for_template_deployment" {
  description = "Specifies whether Azure Resource Manager is permitted to retrieve secrets from the vault."
  type        = bool
  default     = true
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

variable "key_vault_keys" {
  description = <<-EOT
    A map of keys to create on the Key Vault. The map key is arbitrary. See AVM module documentation for details.
    - name: The name of the key.
    - key_type: The type of the key. Possible values are `EC` and `RSA`.
    - key_opts: A list of key options. Possible values are `decrypt`, `encrypt`, `sign`, `unwrapKey`, `verify`, and `wrapKey`. Defaults to ["sign", "verify"].
    - key_size: The size of the key. Required for `RSA` keys.
    - curve: The curve of the key. Required for `EC` keys. Possible values are `P-256`, `P-256K`, `P-384`, and `P-521`. Defaults to `P-256` if not specified.
    - not_before_date: The not before date of the key.
    - expiration_date: The expiration date of the key.
    - tags: A mapping of tags to assign to the key.
    - role_assignments: A map of role assignments to create on this key. Same structure as for `var.role_assignments`.
    - rotation_policy: The rotation policy of the key.
      - automatic: The automatic rotation policy of the key.
        - time_after_creation: The time after creation of the key before it is automatically rotated.
        - time_before_expiry: The time before expiry of the key before it is automatically rotated.
      - expire_after: The time after which the key expires.
      - notify_before_expiry: The time before expiry of the key when notification emails will be sent.
  EOT
  type = map(object({
    name            = string
    key_type        = string
    key_opts        = optional(list(string), ["sign", "verify"])
    key_size        = optional(number, null)
    curve           = optional(string, null)
    not_before_date = optional(string, null)
    expiration_date = optional(string, null)
    tags            = optional(map(any), null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })))
    rotation_policy = optional(object({
      automatic = optional(object({
        time_after_creation = optional(string, null)
        time_before_expiry  = optional(string, null)
      }), null)
      expire_after         = optional(string, null)
      notify_before_expiry = optional(string, null)
    }), null)
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

# variable "key_vault_legacy_access_policies_enabled" {
#   description = "Specifies whether legacy access policies are enabled for this Key Vault. Prevents use of Azure RBAC for data plane."
#   type        = bool
#   default     = true
# }

variable "key_vault_network_acls" {
  description = <<-EOT
    The network ACL configuration for the Key Vault. If not specified then the Key Vault will be created with a firewall that blocks access. Specify `null` to create the Key Vault with no firewall.
    - bypass: (Optional) Should Azure Services bypass the ACL. Possible values are `AzureServices` and `None`. Defaults to `None`.
    - default_action: (Optional) The default action when no rule matches. Possible values are `Allow` and `Deny`. Defaults to `Deny`.
    - ip_rules: (Optional) A list of IP rules in CIDR format. Defaults to [].
    - virtual_network_subnet_ids: (Optional) When using with Service Endpoints, a list of subnet IDs to associate with the Key Vault. Defaults to [].
  EOT
  type = object({
    bypass                     = optional(string, "None")
    default_action             = optional(string, "Deny")
    ip_rules                   = optional(list(string), [])
    virtual_network_subnet_ids = optional(list(string), [])
  })
  default = {}
}

variable "key_vault_public_network_access_enabled" {
  description = "Specifies whether public network access is enabled for the Key Vault. Defaults to true."
  type        = bool
  default     = true
}

variable "key_vault_purge_protection_enabled" {
  type    = bool
  default = true
}

variable "key_vault_secrets" {
  description = <<-EOT
    A map of secrets to create on the Key Vault. The map key is arbitrary. See AVM module documentation for details.
    - name: The name of the secret.
    - content_type: The content type of the secret.
    - tags: A mapping of tags to assign to the secret.
    - not_before_date: The not before date of the secret.
    - expiration_date: The expiration date of the secret.
    - role_assignments: A map of role assignments to create on this secret. Same structure as for `var.role_assignments`.
    > Note: the `value` of the secret is supplied via the `var.secrets_value` variable. Make sure to use the same map key.
  EOT
  type = map(object({
    name            = string
    content_type    = optional(string, null)
    tags            = optional(map(any), null)
    not_before_date = optional(string, null)
    expiration_date = optional(string, null)
    role_assignments = optional(map(object({
      role_definition_id_or_name             = string
      principal_id                           = string
      description                            = optional(string, null)
      skip_service_principal_aad_check       = optional(bool, false)
      condition                              = optional(string, null)
      condition_version                      = optional(string, null)
      delegated_managed_identity_resource_id = optional(string, null)
      principal_type                         = optional(string, null)
    })))
  }))
  default = {}
}

variable "key_vault_secrets_value" {
  description = "A map of secret keys to values. The map key is the supplied input to `var.key_vault_secrets`. The map value is the secret value. This is a separate variable to `var.key_vault_secrets` because it is sensitive and therefore cannot be used in a `for_each` loop."
  type        = map(string)
  default     = null
}

variable "key_vault_sku_name" {
  description = "The SKU name of the Key Vault. Default is `premium`. Possible values are `standard` and `premium`."
  type        = string
  default     = "premium"
}

variable "key_vault_soft_delete_retention_days" {
  description = "The number of days that items should be retained for once soft-deleted. This value can be between 7 and 90 (the default) days."
  type        = number
  default     = null
}

variable "key_vault_role_assignments" {
  type = map(object({
    role_definition_id = optional(string)
    principal_id       = string
  }))
  default = {}
}

# variable "key_vault_wait_for_rbac_before_contact_operations" {
#   description = "Controls the amount of time to wait before performing contact operations. Applies when role assignments and contacts are both set. Default is 30s for create and 0s for destroy."
#   type = object({
#     create  = optional(string, "30s")
#     destroy = optional(string, "0s")
#   })
#   default = {}
# }

# variable "key_vault_wait_for_rbac_before_key_operations" {
#   description = "Controls the amount of time to wait before performing key operations. Applies when role assignments and keys are both set. Default is 30s for create and 0s for destroy."
#   type = object({
#     create  = optional(string, "30s")
#     destroy = optional(string, "0s")
#   })
#   default = {}
# }

# variable "key_vault_wait_for_rbac_before_secret_operations" {
#   description = "Controls the amount of time to wait before performing secret operations. Applies when role assignments and secrets are both set. Default is 30s for create and 0s for destroy."
#   type = object({
#     create  = optional(string, "30s")
#     destroy = optional(string, "0s")
#   })
#   default = {}
# }


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

variable "workbook_display_name" {
  description = "The display name of the Azure Workbook."
  type        = string
  default     = null
}

variable "workbook_tags" {
  description = "Specific tags for the Azure Workbook."
  type        = map(string)
  default     = {}
}
variable "user_assigned_identity_name" {
  description = "(Optional). The name of the User Assigned Identity to create. If null, no identity will be created. Required for environments with Skills Plugins (Dev-1, Dev, and higher) where ACA pulls images from ACR using Managed Identity instead of admin credentials. Not needed for dev2/dev3 as they don't have Skills Plugins deployed."
  type        = string
  default     = null
}