variable "namespace_name" {
  description = "The name of the Service Bus namespace"
  type        = string
}

variable "location" {
  description = "The Azure location where the Service Bus should exist"
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Service Bus"
  type        = string
}

variable "sku" {
  description = "The SKU of the Service Bus namespace. Accepted values are 'Basic', 'Standard' or 'Premium'"
  type        = string
  default     = "Standard"
  validation {
    condition     = contains(["Basic", "Standard", "Premium"], var.sku)
    error_message = "The SKU must be one of 'Basic', 'Standard' or 'Premium'."
  }
}

variable "capacity" {
  description = "The capacity for the Service Bus namespace (required for Premium SKU: 1, 2, 4, 8, or 16)"
  type        = number
  default     = 1
}

variable "premium_messaging_partitions" {
  description = "The number of messaging partitions for a Premium Service Bus namespace. Valid values are 1, 2, or 4. Only applicable for Premium SKU."
  type        = number
  default     = 1
}

variable "queues" {
  description = "List of queues to create in the Service Bus namespace"
  type = list(object({
    name          = string
    lock_duration = optional(string, "PT1M")  # Default 1 minute, ISO 8601 duration format (PT5M for 5 minutes)
  }))
  default = []
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace to send diagnostics to"
  type        = string
  default     = null
}

variable "tags" {
  description = "A mapping of tags to assign to the resources"
  type        = map(string)
  default     = {}
}


variable "enable_public_network" {
  description = "Whether to enable public network access for the Cosmos DB account."
  type        = bool
  default     = false
}

