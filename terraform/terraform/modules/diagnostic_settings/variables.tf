variable "azure_diagnostic_name" {
  description = "Base name for the diagnostic setting"
  type        = string
}

variable "log_categories" {
  description = "List of logs to enable with their settings"
  type = list(object({
    category          = string
    enabled           = bool
    retention_enabled = bool
    retention_days    = number
  }))
}

variable "target_resource_id" {
  description = "Target resource ID"
  type        = string
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID"
  type        = string
}