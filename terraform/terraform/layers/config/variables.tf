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

#### vnet admin #####
variable "vnet_admin_name_01" {
  description = "vnet admin name"
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

variable "document_intelligence_public_network_access_enabled" {
  description = "Whether public network access is enabled for the Document Intelligence account. Set to null to use module default (true)."
  type        = bool
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

variable "storage_account_id" {
  description = "ID of the existing Azure Storage Account"
  type        = string
  default     = null
}
#########################

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



variable "storage_account_name" {
  description = "Name of the existing Azure Storage Account"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group of the Storage Account"
  type        = string
}

variable "container_names" {
  description = "List of container names to create"
  type        = list(string)
}


#####################################
#### Key Vault ######################
#####################################

variable "secret_name" {
  description = "Key Vault secret name"
  type        = string
  default     = null
}

variable "key_vault_id" {
  description = "Key Vault ID where the secret will be stored"
  type        = string
  default     = null
  
}

variable "kv_shared_app" {
  description = "Key Vault for shared resources"
  type        = string
  default     = null
}

variable "prevent_destroy" {
  description = "Prevent destruction of the Key Vault secret"
  type        = bool
  default     = false
}

variable "create_access_policy" {
  description = "Create access policy for the Key Vault secret"
  type        = bool
  default     = false
}


#####################################
#### cosmosdb #######################
#####################################

variable "cosmosdb_account_name" {
  description = "Name of the Cosmos DB account"
  type        = string
}

variable "cosmosdb_database_name" {
  description = "Name of the Cosmos DB database"
  type        = string
}

variable "cosmosdb_containers" {
  description = "Map of Cosmos DB containers"
  type        = map(object({
    partition_key_path       = string
    autoscale_max_throughput = optional(number)
    throughput               = optional(number)
    default_ttl              = optional(number)
    unique_key_paths         = optional(list(string))
  }))
}