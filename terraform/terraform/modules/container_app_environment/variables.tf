variable "cae_name" {
  description = "Name of the Container App Environment"
  type        = string
}

variable "cae_infrastructure_subnet_id" {
  description = "The ID of the subnet to be used for the container app environment infrastructure."
  type        = string
}

variable "public_network_access_enabled" {
  description = "Whether to enable workload profiles for the Container App Environment. Required for session pools."
  type        = string
  default     = "Enabled"
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Container App Environment."
  type        = string
}

variable "location" {
  description = "The Azure region where the Container App Environment should exist."
  type        = string
}

variable "logs_destination" {
  description = "The destination for logs. Currently only 'log-analytics' is supported."
  type        = string
  default     = "log-analytics"
}
variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace to send diagnostics to. This enables system logs for the environment."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the Container App Environment."
  type        = map(string)
  default     = {}
}

variable "workload_profile_enabled" {
  description = "Whether to enable workload profiles for the Container App Environment. Required for session pools."
  type        = bool
  default     = false
}

variable "workload_profiles" {
  description = "List of workload profiles to create. Required when workload_profile_enabled is true."
  type = list(object({
    name                  = string
    workload_profile_type = string
    minimum_count         = number
    maximum_count         = number
  }))
  default = []
  validation {
    condition     = (!var.workload_profile_enabled) || length(var.workload_profiles) > 0
    error_message = "You must provide at least one workload profile when workload_profile_enabled is true."
  }
}