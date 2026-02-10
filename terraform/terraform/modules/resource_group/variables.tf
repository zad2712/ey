variable "name" {
  description = "(Required) The name of the resource group to create."
  type        = string

  validation {
    condition     = length(var.name) >= 1 && length(var.name) <= 90
    error_message = "Resource group name must be between 1 and 90 characters."
  }

  validation {
    condition     = can(regex("^[a-zA-Z0-9._()-]+$", var.name))
    error_message = "Resource group name can only contain alphanumerics, periods, underscores, hyphens, and parenthesis."
  }

  validation {
    condition     = !can(regex("[.]$", var.name))
    error_message = "Resource group name cannot end with a period."
  }
}

variable "location" {
  description = "(Required) The Azure region where the resource group will be created."
  type        = string

  validation {
    condition = can(regex("^[a-zA-Z ]+$", var.location))
    error_message = "Location must be a valid Azure region name (letters and spaces only, e.g., 'East US' or 'east us')."
  }
}

variable "tags" {
  description = "(Optional) A mapping of tags to assign to the resource group."
  type        = map(string)
  default     = {}

  validation {
    condition     = alltrue([for k in keys(var.tags) : can(regex("^[a-zA-Z0-9_ .-]+$", k))])
    error_message = "Tag keys can only contain alphanumerics, underscores, hyphens, periods, and spaces."
  }

  validation {
    condition     = alltrue([for k in keys(var.tags) : length(k) <= 512])
    error_message = "Tag keys cannot exceed 512 characters."
  }

  validation {
    condition     = alltrue([for v in values(var.tags) : length(v) <= 256])
    error_message = "Tag values cannot exceed 256 characters."
  }
}

variable "role_assignments" {
  description = <<-EOT
    (Optional) A map of role assignments to create on the resource group. The map key is arbitrary.
    
    - role_definition_id_or_name (Required): The built-in role name or custom role definition ID.
    - principal_id (Required): The ID of the principal (user, group, or service principal) to assign the role to.
    - description (Optional): A description for the role assignment.
    - skip_service_principal_aad_check (Optional): If true, skips validation that the principal exists in Azure AD. Default is false.
    - condition (Optional): A condition which will be used to scope the role assignment.
    - condition_version (Optional): The version of the condition. Possible values are 1.0 or 2.0.
    - delegated_managed_identity_resource_id (Optional): The delegated Azure Resource ID which contains a Managed Identity.
  EOT
  type = map(object({
    role_definition_id_or_name             = string
    principal_id                           = string
    description                            = optional(string, null)
    skip_service_principal_aad_check       = optional(bool, false)
    condition                              = optional(string, null)
    condition_version                      = optional(string, null)
    delegated_managed_identity_resource_id = optional(string, null)
  }))
  default = {}

  validation {
    condition = alltrue([
      for k, v in var.role_assignments :
      v.condition == null || v.condition_version != null
    ])
    error_message = "When condition is specified, condition_version must also be specified."
  }
}

variable "lock" {
  description = <<-EOT
    (Optional) Controls the Resource Lock configuration for this resource group.
    
    - kind (Required): The type of lock. Possible values are 'CanNotDelete' and 'ReadOnly'.
    - name (Optional): The name of the lock. If not specified, a name will be generated based on the resource group name and lock kind.
    - notes (Optional): Specifies some notes about the lock. Maximum of 512 characters.
  EOT
  type = object({
    kind  = string
    name  = optional(string, null)
    notes = optional(string, null)
  })
  default = null

  validation {
    condition     = var.lock == null || contains(["CanNotDelete", "ReadOnly"], var.lock.kind)
    error_message = "Lock kind must be either 'CanNotDelete' or 'ReadOnly'."
  }

  validation {
    condition     = var.lock == null || var.lock.notes == null || length(var.lock.notes) <= 512
    error_message = "Lock notes cannot exceed 512 characters."
  }
}


