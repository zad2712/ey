variable "openai_account_name" {
  description = "Name of the Azure OpenAI account."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group."
  type        = string
}

variable "location" {
  description = "Azure region for the OpenAI account."
  type        = string
}

variable "openai_custom_subdomain_name" {
  description = "Custom subdomain name for the Azure OpenAI account."
  type        = string
  default     = null
}

variable "sku_name" {
  description = "SKU name for the OpenAI account. Typically 'S0'."
  type        = string
  default     = "S0"
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostics."
  type        = string
  default     = null
}

variable "public_network_access_enabled" {
  description = "Whether public network access is enabled for the OpenAI account. Defaults to true."
  type        = bool
  default     = true
}

variable "network_acls_default_action" {
  description = "The default action for network ACLs. Can be 'Allow' or 'Deny'. Default is 'Deny' for better security, but this can be overridden in tfvars files."
  type        = string
  default     = "Deny"
}

variable "network_acls_bypass" {
  description = "Whether to bypass network ACLs for Azure services. Possible values are 'AzureServices' or 'None'."
  type        = string
  default     = "AzureServices"
}

variable "network_acls_ip_rules" {
  description = "List of IP rules to apply to the OpenAI account. Default is an empty list."
  type        = list(string)
  default     = []
}