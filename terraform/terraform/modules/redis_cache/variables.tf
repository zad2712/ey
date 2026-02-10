variable "name" {
  description = "The name of the Redis Cache."
  type        = string
}

variable "location" {
  description = "The Azure region where the Redis Cache should exist."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Redis Cache."
  type        = string
}

variable "capacity" {
  description = "The size of the Redis cache to deploy. Valid values for a SKU family of C (Basic/Standard) are 0,1,2,3,4,5,6, and for P (Premium) family are 1,2,3,4."
  type        = number
  default     = 1
}

variable "family" {
  description = "The SKU family/pricing group to use. Valid values are C (for Basic/Standard SKU family) and P (for Premium)."
  type        = string
  default     = "C"

  validation {
    condition     = can(regex("^[CP]$", var.family))
    error_message = "The family value must be either 'C' or 'P'."
  }
}

variable "sku_name" {
  description = "The SKU of Redis to use. Possible values are Basic, Standard and Premium."
  type        = string
  default     = "Standard"

  validation {
    condition     = can(regex("^(Basic|Standard|Premium)$", var.sku_name))
    error_message = "The sku_name value must be one of 'Basic', 'Standard', or 'Premium'."
  }
}

variable "enable_non_ssl_port" {
  description = "Enable the non-SSL port (6379) for Redis. Disabled by default for security reasons."
  type        = bool
  default     = false
}

variable "minimum_tls_version" {
  description = "The minimum TLS version for the Redis Cache. Possible values are 1.0, 1.1 and 1.2."
  type        = string
  default     = "1.2"

  validation {
    condition     = can(regex("^1\\.[012]$", var.minimum_tls_version))
    error_message = "The minimum_tls_version value must be one of '1.0', '1.1', or '1.2'."
  }
}

variable "redis_configuration" {
  description = "A map of Redis configuration settings to configure."
  type        = map(string)
  default     = {}
}

variable "identity_type" {
  description = "The type of identity to assign to the Redis Cache. Valid values are SystemAssigned, UserAssigned, SystemAssigned,UserAssigned, and None."
  type        = string
  default     = "SystemAssigned"
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace to send diagnostics to."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}


variable "enable_public_network" {
  description = "Whether to enable public network access for the Cosmos DB account."
  type        = bool
  default     = false
}