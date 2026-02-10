variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "os_type" {
  default = "Windows"
}
variable "sku_name" {
  default = "S1"
}
variable "tags" {
  type    = map(string)
  default = {}
}
variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to"
  type        = string
  default     = null
}

############################
# AUTOSCALE VARIABLES
############################
variable "enable_autoscale" {
  description = "Enable Azure Monitor autoscale for App Service Plan (requires P*v2/P*v3 SKU)"
  type        = bool
  default     = false
}

variable "autoscale_min_capacity" {
  description = "Minimum instance count when autoscale is enabled"
  type        = number
  default     = 2
  validation {
    condition     = var.autoscale_min_capacity >= 1
    error_message = "autoscale_min_capacity must be >= 1"
  }
}

variable "autoscale_max_capacity" {
  description = "Maximum instance count when autoscale is enabled"
  type        = number
  default     = 8
  validation {
    condition     = var.autoscale_max_capacity >= var.autoscale_min_capacity
    error_message = "autoscale_max_capacity must be >= autoscale_min_capacity"
  }
}

variable "autoscale_default_capacity" {
  description = "Default (initial) instance count used by autoscale profile"
  type        = number
  default     = 2
  validation {
    condition     = var.autoscale_default_capacity >= var.autoscale_min_capacity && var.autoscale_default_capacity <= var.autoscale_max_capacity
    error_message = "autoscale_default_capacity must be between autoscale_min_capacity and autoscale_max_capacity"
  }
}

variable "autoscale_metric_name" {
  description = "Metric name evaluated for autoscale. Default: 'CpuPercentage' for App Service Plans"
  type        = string
  default     = "CpuPercentage"
}

variable "autoscale_scale_out_threshold" {
  description = "Numeric threshold for scale OUT when CPU percentage is greater than this"
  type        = number
  default     = 50
}

variable "autoscale_scale_in_threshold" {
  description = "Numeric threshold for scale IN when CPU percentage is less than this"
  type        = number
  default     = 30
}

variable "autoscale_scale_out_cooldown_minutes" {
  description = "Cooldown minutes after a scale OUT action before evaluating again"
  type        = number
  default     = 1
}

variable "autoscale_scale_in_cooldown_minutes" {
  description = "Cooldown minutes after a scale IN action before evaluating again"
  type        = number
  default     = 5
}

variable "autoscale_scale_out_change_count" {
  description = "Number of instances to add when scale-out condition met"
  type        = number
  default     = 2
}

variable "autoscale_scale_in_change_count" {
  description = "Number of instances to remove when scale-in condition met"
  type        = number
  default     = 1
}

variable "autoscale_scale_out_duration_minutes" {
  description = "Duration in minutes over which the metric is evaluated for scale OUT"
  type        = number
  default     = 1
}

variable "autoscale_scale_in_duration_minutes" {
  description = "Duration in minutes over which the metric is evaluated for scale IN"
  type        = number
  default     = 10
}

variable "autoscale_scale_out_statistic" {
  description = "Statistic used for scale-out evaluation (Average, Min, Max, Sum)"
  type        = string
  default     = "Average"
  validation {
    condition     = contains(["Average", "Min", "Max", "Sum"], var.autoscale_scale_out_statistic)
    error_message = "autoscale_scale_out_statistic must be one of: Average, Min, Max, Sum"
  }
}

variable "autoscale_scale_in_statistic" {
  description = "Statistic used for scale-in evaluation (Average, Min, Max, Sum)"
  type        = string
  default     = "Min"
  validation {
    condition     = contains(["Average", "Min", "Max", "Sum"], var.autoscale_scale_in_statistic)
    error_message = "autoscale_scale_in_statistic must be one of: Average, Min, Max, Sum"
  }
}