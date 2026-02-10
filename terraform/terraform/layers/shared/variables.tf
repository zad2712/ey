#### Resource group ##########
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

#### Key vaults ######
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

variable "kv_secret_storage_connection_string_name" {
  description = "Key Vault secret name for the storage connection string"
  type        = string
  default     = null
}

#### Log analytics workspace #######
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

# App Insights
variable "app_insights_name" {
  type        = string
  description = "Name of an existing Application Insights instance to read (optional). If not provided, the data lookup will be skipped."
  default     = null
}

# Optional additional Application Insights instances used for environment-specific connection strings
variable "app_insights_app_pilot_name" {
  type        = string
  description = "Name of an existing Application Insights instance for the Pilot environment (optional)."
  default     = null
}

variable "app_insights_app_prod_name" {
  type        = string
  description = "Name of an existing Application Insights instance for the Prod environment (optional)."
  default     = null
}

#### vnets #####
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

#### vnet app_02 (backend) #####
variable "vnet_app_name_02" {
  description = "vnet app_02 name"
  type        = string
  default     = null
}

#### subnets ########
variable "subnet_admin_name_01" {
  description = "subnet_admin app name"
  type        = string
  default     = null
}

#### subnets app_01 (frontend) #####
variable "subnet_app_name_01" {
  description = "subnet app name"
  type        = string
  default     = null
}

variable "subnet_app_name_02" {
  description = "subnet app name"
  type        = string
  default     = null
}

variable "subnet_app_name_03" {
  description = "subnet app name"
  type        = string
  default     = null
}

#### subnets app_02 (backend) #####
variable "subnet1_name_app_02" {
  description = "subnet1 app_02 name"
  type        = string
  default     = null
}
variable "subnet2_name_app_02" {
  description = "subnet2 app_02 name"
  type        = string
  default     = null
}
variable "subnet3_name_app_02" {
  description = "subnet3 app_02 name"
  type        = string
  default     = null
}

#### Storage account ######
variable "storage_account_app_name_01" {
  description = "storage_account app name"
  type        = string
  default     = null
}

#### Private DNS Zones ####
variable "private_dns_zones_names_backend" {
  description = "Object containing all private DNS zone names. Keys: redis, servicebus, cosmosdb, postgresql, etc."
  type        = map(string)
  default     = {}
}

variable "private_dns_zones_names_app" {
  description = "Object containing all private DNS zone names. Keys: storage, web apps, etc."
  type        = map(string)
  default     = {}
}

variable "env" {
  description = "Environment name (e.g., DEV, QA, UAT, PROD) passed from caller to allow conditional logic inside the shared module."
  type        = string
  default     = null
}

#####################################################################
####### Private DNS Zones - Admin Resources Dev Subscription ########
#####################################################################
variable "resource_group_name_admin_dev" {
  description = "Admin Resource Group Name for Dev Environment"
  type        = string
  default     = null
}

variable "vnet_name_admin_dev" {
  description = "VNet Name for Admin Resources in Dev Environment"
  type        = string
  default     = null
}