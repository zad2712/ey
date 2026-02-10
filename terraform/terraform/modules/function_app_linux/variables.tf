variable "name" {
  description = "Nombre de la Azure Function App."
  type        = string
}

variable "location" {
  description = "Ubicación donde desplegar los recursos."
  type        = string
}

variable "resource_group_name" {
  description = "Nombre del resource group."
  type        = string
}

variable "app_service_plan_id" {
  description = "ID del App Service Plan a usar."
  type        = string
}

variable "storage_account_name" {
  description = "Nombre del storage account."
  type        = string
}

variable "storage_account_access_key" {
  description = "Access key del storage account."
  type        = string
  sensitive   = true
}

variable "os_type" {
  description = "Tipo de sistema operativo: Linux o Windows."
  type        = string
  default     = "Linux"
}

variable "functions_version" {
  description = "Versión del runtime de Azure Functions."
  type        = string
  default     = "~4"
}

variable "tags" {
  description = "Tags para los recursos."
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to"
  type        = string
  default     = null
}

variable "auth_settings" {
  description = "Configuración de autenticación para la Azure Function App."
  type = object({
    enabled                       = bool
    default_provider              = optional(string)
    issuer                        = optional(string)
    client_id                     = optional(string)
    allowed_audiences            = optional(list(string))
  })
  default = null
}

variable "app_settings" {
  description = "Configuración de variables de entorno para la Function App."
  type        = map(string)
  default     = {}
}

variable "site_config" {
  description = "Configuraciones adicionales de la Function App."
  type = object({
    always_on                       = optional(bool)
    ftps_state                      = optional(string)
    http2_enabled                   = optional(bool)
    minimum_tls_version             = optional(string)
    use_32_bit_worker_process       = optional(bool)
  })
  default = null
}

variable "function_app_name" {
  description = "The name of the Function App"
  type        = string
}