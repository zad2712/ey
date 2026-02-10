variable "enabled" {
  description = "Whether to create the session pool"
  type        = bool
  default     = false
}

variable "session_pool_name" {
  description = "Name of the Container App session pool"
  type        = string
}

variable "max_concurrent_sessions" {
  description = "Maximum number of concurrent sessions allowed in the pool"
  type        = number
  default     = 10
  validation {
    condition     = var.max_concurrent_sessions > 0 && var.max_concurrent_sessions <= 1000
    error_message = "max_concurrent_sessions must be between 1 and 1000"
  }
}

variable "ready_session_instances" {
  description = "Target number of sessions to keep ready in the pool"
  type        = number
  default     = 5
  validation {
    condition     = var.ready_session_instances >= 0 && var.ready_session_instances <= var.max_concurrent_sessions
    error_message = "ready_session_instances must be between 0 and max_concurrent_sessions"
  }
}

variable "cooldown_period_seconds" {
  description = "Number of seconds a session can be idle before termination (300-3600)"
  type        = number
  default     = 300
  validation {
    condition     = var.cooldown_period_seconds >= 300 && var.cooldown_period_seconds <= 3600
    error_message = "cooldown_period_seconds must be between 300 and 3600"
  }
}

variable "target_port" {
  description = "The session port used for ingress traffic"
  type        = number
  default     = 80
}

variable "network_status" {
  description = "Network status for session pool (EgressEnabled or EgressDisabled)"
  type        = string
  default     = "EgressDisabled"
  validation {
    condition     = contains(["EgressEnabled", "EgressDisabled"], var.network_status)
    error_message = "network_status must be either 'EgressEnabled' or 'EgressDisabled'"
  }
}

variable "container_type" {
  description = "Type of container for the session pool (PythonLTS or CustomContainer)"
  type        = string
  default     = "CustomContainer"
  validation {
    condition     = contains(["PythonLTS", "CustomContainer"], var.container_type)
    error_message = "container_type must be either 'PythonLTS' or 'CustomContainer'"
  }
}

# Container configuration variables
variable "container_command" {
  description = "Optional list of command strings to run as the container command (entrypoint override)"
  type        = list(string)
  default     = null
}

variable "container_args" {
  description = "Optional list of args strings to pass to the container entrypoint"
  type        = list(string)
  default     = null
}

variable "container_name" {
  description = "The name of the container"
  type        = string
}

variable "container_image" {
  description = "Container image to use for pool members"
  type        = string
}

variable "container_cpu" {
  description = "CPU for each container session (e.g., 0.25, 0.5, 1.0)"
  type        = number
  default     = 0.25
  validation {
    condition     = contains([0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0], var.container_cpu)
    error_message = "container_cpu must be one of: 0.25, 0.5, 0.75, 1.0, 1.25, 1.5, 1.75, 2.0"
  }
}

variable "container_memory" {
  description = "Memory for each container session (e.g., '0.5Gi', '1Gi', '2Gi')"
  type        = string
  default     = "0.5Gi"
  validation {
    condition     = can(regex("^[0-9]+(\\.[0-9]+)?Gi$", var.container_memory))
    error_message = "container_memory must be in format like '0.5Gi', '1Gi', '2Gi'"
  }
}

variable "location" {
  description = "Azure location"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "container_app_environment_id" {
  description = "Container App Environment ID (must be workload profile enabled)"
  type        = string
}

variable "tags" {
  description = "Tags to apply to resources"
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "Optional Log Analytics workspace ID for diagnostics"
  type        = string
  default     = null
}

# Registry and authentication variables
variable "registry_server" {
  description = "Container registry server hostname (e.g., myregistry.azurecr.io)"
  type        = string
  default     = null
}

variable "registry_username" {
  description = "Username for container registry authentication"
  type        = string
  default     = null
}

variable "registry_password_secret" {
  description = "Name of the secret containing the registry password"
  type        = string
  default     = null
}

variable "environment_variables" {
  description = "Environment variables to set in the container sessions"
  type        = map(string)
  default     = null
}

variable "secrets" {
  description = "List of secrets for the session pool. Each secret should reference an external secret store (e.g., Azure Key Vault secret ID) rather than providing a raw value."
  type = list(object({
    name                 = string
    key_vault_secret_id  = string
  }))
  default = null
}

variable "role_assignments" {
  description = "List of role assignments for the session pool"
  type = list(object({
    principal_id   = string
    principal_type = optional(string, "User")
    role_name     = string
  }))
  default = []
}

variable "enable_default_roles" {
  description = "Whether to enable default Container Apps session roles (Sessions Executor and SessionPools Contributor)"
  type        = bool
  default     = true
}

variable "default_role_principals" {
  description = "Principal IDs to assign default Container Apps session roles to"
  type = list(object({
    principal_id   = string
    principal_type = optional(string, "User")
  }))
  default = []
}
