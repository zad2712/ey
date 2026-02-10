variable "name" {
  description = "Nombre del Front Door"
  type        = string
}

variable "resource_group_name" {
  description = "Grupo de recursos"
  type        = string
}

variable "location" {
  description = "Ubicación"
  type        = string
}

variable "endpoint_name" {
  description = "Nombre del frontend endpoint"
  type        = string
}

variable "backend_pool_name" {
  description = "Nombre del backend pool"
  type        = string
}

variable "backend_host" {
  description = "Host header del backend"
  type        = string
}

variable "backend_address" {
  description = "Dirección IP o FQDN del backend"
  type        = string
}

variable "waf_policy_id" {
  description = "ID de la política de WAF asociada"
  type        = string
  default     = null
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostics."
  type        = string
  default     = null
}
