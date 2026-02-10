variable "speech_account_name" {
  description = "Name of the Azure Cognitive Services Speech account."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region for the Speech account."
  type        = string
}

variable "sku_name" {
  description = "SKU name for the Speech account. Typically 'S0'."
  type        = string
  default     = "S0"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostics. Set to null if not needed."
  type        = string
  default     = null
}

variable "custom_subdomain_name" {
  description = "The custom subdomain name for the Cognitive Services account. This is required for VNet integration with a private endpoint or service endpoint if you want a custom DNS name."
  type        = string
  default     = null
}

variable "network_acls_ip_rules" {
  description = "List of IP rules to apply to the Speech account. Default is an empty list."
  type        = list(string)
  default     = []
}

variable "network_acls_default_action" {
  description = "The default action for network ACLs. Can be 'Allow' or 'Deny'. Default is 'Deny' for better security, but this can be overridden in tfvars files."
  type        = string
  default     = "Deny"
}

variable "speech_service_custom_subdomain_name" {
  description = "Custom subdomain name for the Azure Cognitive Speech Service account. This is required if you want to use a custom DNS name."
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled. Defaults to true. Set to false if only allowing access via private endpoints or VNet service endpoints."
  type        = bool
  default     = false
}