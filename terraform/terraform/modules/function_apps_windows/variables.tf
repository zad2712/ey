# Core Resource Configuration
variable "name" {
  description = "Function App name"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group name"
  type        = string
}

variable "location" {
  description = "Azure region for the Function App"
  type        = string
}

variable "service_plan_id" {
  description = "App Service Plan resource ID"
  type        = string
}

variable "tags" {
  description = "Resource tags"
  type        = map(string)
  default     = {}
}

# Storage Configuration
variable "storage_key_vault_secret_id" {
  description = "Key Vault secret ID containing the storage connection string (preferred method, mutually exclusive with storage_account_name/access_key)"
  type        = string
  default     = null
}

# Runtime Configuration
variable "app_settings" {
  description = "Application settings (environment variables)"
  type        = map(string)
  default     = {}
}

variable "site_config" {
  description = "Site configuration including runtime stack and operational settings"
  type        = any
  default     = {}
}

# Identity Configuration
variable "identity_type" {
  description = "Managed identity type (SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned)"
  type        = string
  default     = null

  validation {
    condition     = var.identity_type == null || contains(["SystemAssigned", "UserAssigned", "SystemAssigned, UserAssigned"], var.identity_type)
    error_message = "Identity type must be SystemAssigned, UserAssigned, or SystemAssigned, UserAssigned."
  }
}

# Network Configuration
variable "virtual_network_subnet_id" {
  description = "Subnet resource ID for VNet integration"
  type        = string
  default     = null
}

variable "ip_restriction_default_action" {
  description = "Default action for IP restrictions (Allow or Deny)"
  type        = string
  default     = null

  validation {
    condition     = var.ip_restriction_default_action == null || contains(["Allow", "Deny"], var.ip_restriction_default_action)
    error_message = "IP restriction default action must be Allow or Deny."
  }
}

variable "scm_ip_restriction_default_action" {
  description = "Default action for SCM IP restrictions (Allow or Deny)"
  type        = string
  default     = null

  validation {
    condition     = var.scm_ip_restriction_default_action == null || contains(["Allow", "Deny"], var.scm_ip_restriction_default_action)
    error_message = "SCM IP restriction default action must be Allow or Deny."
  }
}

variable "ip_restriction" {
  description = "IP restriction rules for inbound traffic"
  type = map(object({
    action      = string
    priority    = number
    service_tag = optional(string)
    ip_address  = optional(string)
    description = optional(string)
  }))
  default = {}
}

# Security Configuration
variable "client_certificate_mode" {
  description = "Client certificate mode (Required, Optional, or OptionalInteractiveUser)"
  type        = string
  default     = null

  validation {
    condition     = var.client_certificate_mode == null || contains(["Required", "Optional", "OptionalInteractiveUser"], var.client_certificate_mode)
    error_message = "Client certificate mode must be Required, Optional, or OptionalInteractiveUser."
  }
}

variable "ftp_publish_basic_authentication_enabled" {
  description = "Enable FTP basic authentication"
  type        = bool
  default     = null
}

variable "webdeploy_publish_basic_authentication_enabled" {
  description = "Enable WebDeploy basic authentication"
  type        = bool
  default     = null
}

# Authentication Configuration
variable "auth_settings" {
  description = "App Service authentication settings"
  type        = any
  default     = null
}

# Deployment Slot Configuration
variable "sticky_settings" {
  description = "Settings that remain with the slot during swaps (not swapped between slots)"
  type = object({
    app_setting_names       = list(string)
    connection_string_names = list(string)
  })
  default = null
}

# Monitoring Configuration
variable "application_insights_connection_string" {
  description = "Application Insights connection string (can also be set via app_settings)"
  type        = string
  default     = null
  sensitive   = true
}

variable "application_insights_key" {
  description = "Application Insights instrumentation key (can also be set via app_settings)"
  type        = string
  default     = null
  sensitive   = true
}

variable "diagnostic_settings" {
  description = "Diagnostic settings for Azure Monitor integration"
  type = object({
    workspace_resource_id = string
    name                  = string
    log_groups            = list(string)
    metric_categories     = list(string)
  })
  default = null
}

variable "public_network_access_enabled" {
  description = "Should public network access be enabled for the Function App"
  type        = bool
  default     = false
}