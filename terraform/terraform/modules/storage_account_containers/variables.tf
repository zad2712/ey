variable "storage_account_name" {
  description = "Name of the existing Azure Storage Account"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group of the Storage Account"
  type        = string
}

variable "container_names" {
  description = "List of container names to create"
  type        = list(string)
}

variable "storage_account_id" {
  description = "ID of the existing Azure Storage Account"
  type        = string
  default     = null
}