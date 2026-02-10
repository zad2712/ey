variable "name" {
  description = "SignalR Service Name"
  type        = string
}

variable "location" {
  description = "Resource location"
  type        = string
}

variable "resource_group_name" {
  description = "Azure Resource Group"
  type        = string
}

variable "sku_name" {
  description = "SignalR SKU (por ejemplo, Standard_S1, Free_F1)"
  type        = string
}

variable "sku_capacity" {
  description = "Initial unit capacity when autoscale is disabled. Ignored when enable_autoscale = true (autoscale_default_capacity is used instead)."
  type        = number
  default     = 1
}

variable "enable_autoscale" {
  description = "Enable Azure Monitor autoscale for Premium tier SignalR Service"
  type        = bool
  default     = false
}

variable "autoscale_min_capacity" {
  description = "Minimum unit count when autoscale is enabled"
  type        = number
  default     = 2
  validation {
    condition     = var.autoscale_min_capacity >= 1
    error_message = "autoscale_min_capacity must be >= 1"
  }
}

variable "autoscale_max_capacity" {
  description = "Maximum unit count when autoscale is enabled"
  type        = number
  default     = 8
  validation {
    condition     = var.autoscale_max_capacity >= var.autoscale_min_capacity
    error_message = "autoscale_max_capacity must be >= autoscale_min_capacity"
  }
}

variable "autoscale_default_capacity" {
  description = "Default (initial) unit count used by autoscale profile"
  type        = number
  default     = 2
  validation {
    condition     = var.autoscale_default_capacity >= var.autoscale_min_capacity && var.autoscale_default_capacity <= var.autoscale_max_capacity
    error_message = "autoscale_default_capacity must be between autoscale_min_capacity and autoscale_max_capacity"
  }
}

variable "autoscale_metric_name" {
  description = "Metric name evaluated for autoscale. Defaults to SignalR metric 'Connection Quota Utilization'. Override (e.g. 'CpuPercentage') when using external metric resource."
  type        = string
  default     = "Connection Quota Utilization"
}

variable "autoscale_scale_out_threshold" {
  description = "Numeric threshold for scale OUT when statistic value is greater than this (percent for most metrics)."
  type        = number
  default     = 50
}

variable "autoscale_scale_in_threshold" {
  description = "Numeric threshold for scale IN when statistic value is less than this (percent for most metrics)."
  type        = number
  default     = 30
}

variable "autoscale_scale_out_cooldown_minutes" {
  description = "Cooldown minutes after a scale OUT action before evaluating again"
  type        = number
  default     = 30
}

variable "autoscale_scale_in_cooldown_minutes" {
  description = "Cooldown minutes after a scale IN action before evaluating again"
  type        = number
  default     = 30
}

variable "autoscale_scale_out_change_count" {
  description = "Number of units to add when scale-out condition met"
  type        = number
  default     = 2
}

variable "autoscale_scale_in_change_count" {
  description = "Number of units to remove when scale-in condition met"
  type        = number
  default     = 1
}

variable "autoscale_scale_out_statistic" {
  description = "Statistic used for scale-out evaluation (Average, Min, Max, Sum). NOTE: 'Min'/'Max' will be mapped to correct time_aggregation values."
  type        = string
  default     = "Average"
  validation {
    condition     = contains(["Average","Min","Max","Sum"], var.autoscale_scale_out_statistic)
    error_message = "autoscale_scale_out_statistic must be one of: Average, Min, Max, Sum."
  }
}

variable "autoscale_scale_in_statistic" {
  description = "Statistic used for scale-in evaluation (Average, Min, Max, Sum)."
  type        = string
  default     = "Min"
  validation {
    condition     = contains(["Average","Min","Max","Sum"], var.autoscale_scale_in_statistic)
    error_message = "autoscale_scale_in_statistic must be one of: Average, Min, Max, Sum."
  }
}

variable "autoscale_external_metric_resource_id" {
  description = "Optional resource ID supplying the metric (e.g. App Service Plan ID for CpuPercentage). If null, SignalR resource metrics are used."
  type        = string
  default     = null
}

variable "autoscale_external_metric_namespace" {
  description = "Metric namespace for external metric (e.g. 'Microsoft.Web/serverfarms'). Required when autoscale_external_metric_resource_id is set."
  type        = string
  default     = null
}

variable "autoscale_external_metric_enabled" {
  description = "Flag indicating whether external metric (cross-resource) autoscale is enabled. Set true when providing external metric resource ID."
  type        = bool
  default     = false
  validation {
    condition     = (!var.autoscale_external_metric_enabled) || (var.autoscale_external_metric_resource_id != null && var.autoscale_external_metric_namespace != null)
    error_message = "When autoscale_external_metric_enabled is true you must supply autoscale_external_metric_resource_id and autoscale_external_metric_namespace."
  }
}


variable "identity" {
  description = "Managed Identity Configuration"
  type = object({
    type         = string
    identity_ids = optional(list(string))
  })
  default = null
}

variable "cors" {
  description = "CORS Configuration"
  type = object({
    allowed_origins = list(string)
  })
  default = null
}

variable "tags" {
  description = "Optional tags"
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to"
  type        = string
  default     = null
}

