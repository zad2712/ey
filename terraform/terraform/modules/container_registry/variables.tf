variable "acr_name" {
  description = "The name of the Container Registry."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Container Registry."
  type        = string
}

variable "location" {
  description = "The Azure region where the Container Registry should exist."
  type        = string
}

variable "sku" {
  description = "The SKU of the Container Registry. Possible values are `Basic`, `Standard` and `Premium`."
  type        = string
  default     = "Standard"
}

variable "admin_enabled" {
  description = "Specifies whether the admin user is enabled. Defaults to `false`."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace to send diagnostics to."
  type        = string
}

variable "log_categories" {
  description = "List of log categories to send to Log Analytics. Default is ContainerRegistryRepositoryEvents, ContainerRegistryLoginEvents."
  type = list(object({
    category          = string
    enabled           = bool
    retention_enabled = bool
    retention_days    = number
  }))
  default = [
    {
      category          = "ContainerRegistryRepositoryEvents"
      enabled           = true
      retention_enabled = true
      retention_days    = 365
    },
    {
      category          = "ContainerRegistryLoginEvents"
      enabled           = true
      retention_enabled = true
      retention_days    = 365
    }
  ]
}

variable "metric_categories" {
  description = "List of metric categories to send to Log Analytics. Default is AllMetrics."
  type = list(object({
    category          = string
    enabled           = bool
    retention_enabled = bool
    retention_days    = number
  }))
  default = [
    {
      category          = "AllMetrics"
      enabled           = true
      retention_enabled = true
      retention_days    = 365
    }
  ]
}

variable "zone_redundancy_enabled" {
  description = "Enable zone redundancy for the Container Registry. When true, ACR will be zone redundant (Premium SKU required)."
  type        = bool
  default     = true
}

variable "network_rule_bypass_option" {
  type        = string
  default     = "AzureServices"
  description = <<DESCRIPTION
Specifies whether to allow trusted Azure services access to a network restricted Container Registry.
Possible values are `None` and `AzureServices`. Defaults to `AzureServices`.
DESCRIPTION

  validation {
    condition     = var.network_rule_bypass_option == null ? true : contains(["AzureServices", "None"], var.network_rule_bypass_option)
    error_message = "The network_rule_bypass_option variable must be either `AzureServices` or `None`."
  }
}

variable "public_network_access_enabled" {
  type        = bool
  default     = false
  description = "Specifies whether public access is permitted."
}