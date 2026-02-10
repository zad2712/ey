variable "name" {}
variable "location" {}
variable "resource_group_name" {}
variable "tenant_id" {}

variable "sku_name" {}
variable "soft_delete_retention_days" { default = 7 }

variable "enabled_for_template_deployment" { default = false }
variable "enabled_for_deployment" { default = false }
variable "enabled_for_disk_encryption" { default = false }

variable "public_network_access_enabled" { default = true }

variable "purge_protection_enabled" {
  type    = bool
  default = true
}

variable "network_acls" {
  type = object({
    bypass                     = string
    default_action             = string
    ip_rules                   = list(string)
    virtual_network_subnet_ids = list(string)
  })
  default = null
}

variable "keys" {
  type = map(object({
    key_type     = string
    key_size     = number
    curve        = optional(string)
    key_opts     = list(string)
    expiration_date = optional(string)
    not_before_date = optional(string)
  }))
  default = {}
}

variable "secrets" {
  type = map(object({
    content_type    = optional(string)
    expiration_date = optional(string)
    not_before_date = optional(string)
    tags            = optional(map(string))
  }))
  default = {}
}

variable "secrets_value" {
  type = map(string)
  default = {}
}

variable "role_assignments" {
  type = map(object({
    role_definition_id = optional(string)
    principal_id       = string
  }))
  default = {}
}

variable "diagnostic_settings" {
  type = map(object({
    workspace_id = string
    logs = list(object({
      category = string
      enabled  = bool
      retention_policy = object({
        enabled = bool
        days    = number
      })
    }))
    metrics = list(object({
      category = string
      enabled  = bool
      retention_policy = object({
        enabled = bool
        days    = number
      })
    }))
  }))
  default = {}
}

variable "lock" {
  type = object({
    name  = string
    level = optional(string, "CanNotDelete")
    notes = optional(string)
  })
  default = null
}

variable "tags" {
  type    = map(string)
  default = {}
}

variable "legacy_access_policies" {
  description = "A map of legacy access policies to create on the Key Vault."
  type = map(object({
    object_id               = string
    tenant_id               = optional(string)
    key_permissions         = optional(list(string), [])
    secret_permissions      = optional(list(string), [])
    certificate_permissions = optional(list(string), [])
    storage_permissions     = optional(list(string), [])
  }))
  default = {}
}
