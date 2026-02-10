variable "app_service_name" {}
variable "location" {}
variable "resource_group_name" {}
variable "app_service_plan_id" {}
variable "app_settings" {
  type    = map(string)
  default = {}
}
variable "tags" {
  type    = map(string)
  default = {}
}

# Opcional
variable "enable_auth" {
  default = false
}
variable "auth_settings" {
  type    = any
  default = {}
}

variable "enable_autoscale" {
  default = false
}
variable "autoscale_settings" {
  type = object({
    min     = string
    max     = string
    default = string
  })
  default = null
}

variable "enable_diagnostics" {
  default = false
}
variable "log_analytics_workspace_id" {
  default = null
}