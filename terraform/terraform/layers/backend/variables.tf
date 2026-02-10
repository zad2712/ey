##################
#### GENERAL #####
##################
# variable "tags" {
#   description = "Etiquetas estándar CTP"
#   type        = map(string)
# }

variable "env" {
  description = "Environment type (DEV, QA, UAT, PROD)"
  type        = string
  validation {
    condition     = contains(["DEV", "QA", "UAT", "PROD"], var.env)
    error_message = "Environment must be one of: DEV, QA, UAT, PROD."
  }
}

####################
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
variable "kv_shared_admin" {
  description = "kv_shared admin name"
  type        = string
  default     = null

}


variable "kv_shared_app" {
  description = "kv_shared app name"
  type        = string
  default     = null
}

#### vnet admin #####
variable "vnet_admin_name_01" {
  description = "vnet admin name"
  type        = string
  default     = null
}

#### vnet app_01 (frontend) #####
variable "vnet_app_name_01" {
  description = "vnet app name"
  type        = string
  default     = null
}
variable "subnet_app_name_01" {
  description = "subnet_app app name"
  type        = string
  default     = null
}
variable "subnet_admin_name_01" {
  description = "subnet_admin name"
  type        = string
  default     = null
}

#### vnet app_02 (backend) #####
variable "vnet_app_name_02" {
  description = "vnet app_02 name"
  type        = string
  default     = null
}

#### subnets app_02 (backend) ####
variable "subnet1_name_app_02" {
  description = "subnet1 app_02 name"
  type        = string
  default     = null
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

variable "storage_account_admin_tags" {
  description = "Specific tags for the admin storage account."
  type        = map(string)
  default     = {}
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
  description = "Specific tags for the app storage account."
  type        = map(string)
  default     = {}
}

variable "enable_storage_account_app_01" {
  description = "Conditional storage account for the application. If set to null, the storage account will not be created."
  type        = string
  default     = null
}

#####################################
#### REDIS CACHE ####################
#####################################
variable "redis_cache_name" {
  description = "The name of the Redis Cache."
  type        = string
  default     = null
}

variable "redis_cache_capacity" {
  description = "The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0,1,2,3,4,5,6, and for P (Premium) family are 1,2,3,4."
  type        = number
  default     = 1
}

variable "redis_cache_family" {
  description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)."
  type        = string
  default     = "C"
}

variable "redis_cache_sku_name" {
  description = "The SKU of Redis to use. Possible values are Basic, Standard and Premium."
  type        = string
  default     = "Standard"
}

variable "redis_cache_enable_non_ssl_port" {
  description = "Enable the non-SSL port (6379) for Redis. Disabled by default for security reasons."
  type        = bool
  default     = false
}

variable "redis_cache_minimum_tls_version" {
  description = "The minimum TLS version for the Redis Cache."
  type        = string
  default     = "1.2"
}

variable "redis_cache_configuration" {
  description = "A map of Redis configuration settings to configure."
  type        = map(string)
  default     = {}
}

variable "redis_cache_tags" {
  description = "Specific tags for the Redis Cache."
  type        = map(string)
  default     = {}
}

#####################################
#### SERVICE BUS ####################
#####################################
variable "servicebus_namespace_name" {
  description = "The name of the Service Bus namespace."
  type        = string
  default     = null
}

variable "servicebus_sku" {
  description = "The SKU of the Service Bus namespace. Accepted values are 'Basic', 'Standard' or 'Premium'."
  type        = string
  default     = "Standard"
}

variable "servicebus_queues" {
  description = "List of queues to create in the Service Bus namespace."
  type = list(object({
    name = string
  }))
  default = []
}

variable "servicebus_tags" {
  description = "Specific tags for the the Service Bus namespace."
  type        = map(string)
  default     = {}
}

variable "servicebus_capacity" {
  description = "The capacity for the Service Bus namespace (required for Premium SKU: 1, 2, 4, 8, or 16)"
  type        = number
  default     = 1
}

variable "premium_messaging_partitions" {
  description = "The number of messaging partitions for a Premium Service Bus namespace. Valid values are 1, 2, or 4. Only applicable for Premium SKU."
  type        = number
  default     = 1
}

#####################################
#### COSMOS DB ######################
#####################################
variable "cosmosdb_account_name" {
  description = "The name of the Cosmos DB account."
  type        = string
  default     = null
}

variable "cosmosdb_resource_group_name" {
  description = "The name of the resource group in which to create the Cosmos DB account."
  type        = string
  default     = null
}

variable "cosmosdb_location" {
  description = "The Azure location where the Cosmos DB account should exist."
  type        = string
  default     = null
}

variable "cosmosdb_tags" {
  description = "A map of tags to assign to the Cosmos DB account."
  type        = map(string)
  default     = {}
}

################################
#### COSMOS DB POSTGRESQL ######
################################
variable "cosmosdb_postgresql_name" {
  description = "The name of the Cosmos DB PostgreSQL Cluster."
  type        = string
  default     = null
}

variable "cosmosdb_postgresql_administrator_login" {
  description = "The administrator login name for the PostgreSQL Cluster."
  type        = string
  default     = "citus"
}

variable "cosmosdb_postgresql_administrator_login_password" {
  description = "The administrator login password for the PostgreSQL Cluster."
  type        = string
  sensitive   = true
  default     = null
}

variable "cosmosdb_postgresql_database_name" {
  description = "The name of the database to create in the PostgreSQL Cluster."
  type        = string
  default     = "citus"
}

variable "cosmosdb_postgresql_tags" {
  description = "A map of tags to assign to the Cosmos DB PostgreSQL Cluster."
  type        = map(string)
  default     = {}
}

#####################################
####### KEYVAULT          ###########
#####################################

variable "key_vault_id" {
  description = "ID of the existing Azure Key Vault"
  type        = string
  default     = null

}

######################################
#### PRIVATE ENDPOINTS NAMES #########
######################################
variable "resource_group_name_admin_dev" {
  description = "Admin Resource Group Name for Dev Environment"
  type        = string
  default     = null
}

variable "service_bus_pep_name" {
  description = "The name of the Service Bus private endpoint."
  type        = string
  default     = null
}

variable "redis_cache_pep_name" {
  description = "The name of the Redis Cache private endpoint."
  type        = string
  default     = null
}

variable "cosmosdb_pep_name" {
  description = "The name of the CosmosDB private endpoint."
  type        = string
  default     = null
}

variable "cosmosdb_postgresql_pep_name" {
  description = "The name of the CosmosDB PostgreSQL private endpoint."
  type        = string
  default     = null
}

variable "backend_private_endpoints" {
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