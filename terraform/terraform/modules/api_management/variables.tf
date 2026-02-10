variable "name" {
  description = "Name of the API Management service"
  type        = string
}

variable "location" {
  description = "Azure region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group"
  type        = string
}

variable "publisher_name" {
  description = "Name of the publisher"
  type        = string
}

variable "publisher_email" {
  description = "Email of the publisher"
  type        = string
}

variable "sku_name" {
  description = "SKU name of the API Management instance (e.g., Developer_1, Premium_1)"
  type        = string
}

variable "virtual_network_type" {
  description = "Type of VNet integration: None, External, or Internal"
  type        = string
  default     = null
}

variable "subnet_id" {
  description = "ID of the subnet to integrate with"
  type        = string
  default     = null
}

variable "zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = []
}

variable "log_analytics_workspace_id" {
  type        = string
  default     = null
  description = "ID del workspace para diagnósticos."
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "standard tags: OWNER, DEPLOYMENT_ID, PEER, etc"
}