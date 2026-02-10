# Core Resource Configuration
variable "name" {
  description = "App Service name"
  type        = string
}

variable "location" {
  description = "Azure region for the App Service"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "service_plan_id" {
  description = "App Service Plan resource ID (Windows)"
  type        = string
}

variable "service_plan_resource_id" {
  description = "App Service Plan resource ID (alternative to service_plan_id)"
  type        = string
  default     = null
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

# App Service Configuration
variable "https_only" {
  description = "Require HTTPS-only access"
  type        = bool
  default     = null
}

variable "public_network_access_enabled" {
  description = "Enable public network access"
  type        = bool
  default     = true
}

variable "app_settings" {
  description = "Application settings (environment variables)"
  type        = map(string)
  default     = null
}

variable "site_config" {
  description = "Site configuration including runtime stack and operational settings"
  type        = any
  default     = {}
}

# Runtime Stack Configuration
variable "application_stack" {
  description = "Application runtime stack configuration"
  type = object({
    dotnet_stack = optional(object({
      current_stack               = optional(string)
      dotnet_version              = optional(string)
      use_dotnet_isolated_runtime = optional(bool, false)
    }))
  })
  default = {}
}

# Network Configuration
variable "virtual_network_subnet_id" {
  description = "Subnet resource ID for VNet integration"
  type        = string
  default     = null
}

variable "minimum_tls_version" {
  description = "Minimum TLS version for SSL requests"
  type        = string
  default     = "1.2"

  validation {
    condition     = contains(["1.0", "1.1", "1.2"], var.minimum_tls_version)
    error_message = "Minimum TLS version must be 1.0, 1.1, or 1.2."
  }
}

variable "ip_restriction_default_action" {
  description = "Default action for IP restrictions (Allow or Deny)"
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.ip_restriction_default_action)
    error_message = "IP restriction default action must be Allow or Deny."
  }
}

variable "scm_ip_restriction_default_action" {
  description = "Default action for SCM IP restrictions (Allow or Deny)"
  type        = string
  default     = "Allow"

  validation {
    condition     = contains(["Allow", "Deny"], var.scm_ip_restriction_default_action)
    error_message = "SCM IP restriction default action must be Allow or Deny."
  }
}

variable "ip_restriction" {
  description = "IP restriction rules for main site"
  type = map(object({
    action                    = optional(string, "Allow")
    ip_address                = optional(string)
    name                      = optional(string)
    priority                  = optional(number, 65000)
    service_tag               = optional(string)
    virtual_network_subnet_id = optional(string)
    description               = optional(string)
    tag                       = optional(string)
    headers = optional(object({
      x_azure_fdid      = optional(list(string), [])
      x_fd_health_probe = optional(list(string), [])
      x_forwarded_for   = optional(list(string), [])
      x_forwarded_host  = optional(list(string), [])
    }), {})
  }))
  default = {}
}

variable "scm_ip_restriction" {
  description = "IP restriction rules for SCM site (Kudu)"
  type = map(object({
    action                    = optional(string, "Allow")
    ip_address                = optional(string)
    name                      = optional(string)
    priority                  = optional(number, 65000)
    service_tag               = optional(string)
    virtual_network_subnet_id = optional(string)
    description               = optional(string)
    tag                       = optional(string)
    headers = optional(object({
      x_azure_fdid      = optional(list(string), [])
      x_fd_health_probe = optional(list(string), [])
      x_forwarded_for   = optional(list(string), [])
      x_forwarded_host  = optional(list(string), [])
    }), {})
  }))
  default = {}
}

# CORS Configuration
variable "cors" {
  description = "Cross-Origin Resource Sharing (CORS) configuration"
  type = object({
    allowed_origins     = list(string)
    support_credentials = optional(bool, false)
  })
  default = null
}

# Identity Configuration
variable "managed_identities" {
  description = "Managed identity configuration"
  type = object({
    system_assigned            = optional(bool, false)
    user_assigned_resource_ids = optional(set(string), [])
  })
  default = {}
}

# Security Configuration
variable "ftp_publish_basic_authentication_enabled" {
  description = "Enable FTP basic authentication"
  type        = bool
  default     = true
}

variable "scm_publish_basic_authentication_enabled" {
  description = "Enable SCM basic authentication"
  type        = bool
  default     = true
}

variable "storage_key_vault_secret_id" {
  description = "Key Vault secret ID for Key Vault reference identity"
  type        = string
  default     = null
}

# Authentication Configuration
variable "auth_settings" {
  description = "App Service authentication settings"
  type = object({
    enabled                       = optional(bool)
    default_provider              = optional(string)
    issuer                        = optional(string)
    unauthenticated_client_action = optional(string)
    token_refresh_extension_hours = optional(number)
    token_store_enabled           = optional(bool)
    active_directory = object({
      client_id         = string
      client_secret     = string
      allowed_audiences = optional(list(string))
    })
  })
  default = null
}

# Deployment Slot Configuration
variable "sticky_settings" {
  description = "Settings that remain with the slot during swaps (not swapped between slots)"
  type = object({
    app_setting_names       = optional(list(string), [])
    connection_string_names = optional(list(string), [])
  })
  default = null
}

# Monitoring Configuration
variable "diagnostic_settings" {
  description = "Diagnostic settings for Azure Monitor integration"
  type = object({
    workspace_resource_id = string
    name                  = optional(string, null)
    log_groups            = optional(list(string), [])
    metric_categories     = optional(list(string), [])
  })
  default = null
}
