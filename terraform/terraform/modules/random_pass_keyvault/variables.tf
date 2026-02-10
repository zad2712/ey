# variable "key_vault_id" {
#   type        = string
#   description = "ID of the existing Azure Key Vault"
# }

# variable "secret_name" {
#   type        = string
#   description = "The name of the secret to store in Key Vault"
# }

# variable "password_length" {
#   type        = number
#   description = "Length of the generated password"
#   default     = 20
# }


variable "key_vault_id" {
  description = "Resource ID of the Key Vault to store the secret"
  type        = string
}

# variable "secret_name" {
#   description = "Name of the secret to create in Key Vault"
#   type        = string
# }

variable "secret_name" {
  description = "Key Vault secret name"
  type        = string
  default     = null
}

variable "password_length" {
  description = "Length of generated password"
  type        = number
  default     = 16
}

variable "prevent_destroy" {
  description = "If true, prevent Terraform from destroying the generated password/secret"
  type        = bool
  default     = true
}

variable "create_access_policy" {
  description = "Create an access policy granting the specified principal access to the vault"
  type        = bool
  default     = true
}

variable "principal_object_id" {
  description = "Object ID of the principal (user/service principal) to grant access. If empty, current client object_id is used."
  type        = string
  default     = ""
}

variable "principal_tenant_id" {
  description = "Tenant ID for the access policy. If empty, current tenant_id is used."
  type        = string
  default     = ""
}

variable "content_type" {
  description = "Key Vault secret content_type"
  type        = string
  default     = "text/plain"
}

variable "tags" {
  description = "Tags for the secret"
  type        = map(string)
  default     = {}
}

