variable "name" {
  description = "The name of the private endpoint."
  type        = string
}

variable "location" {
  description = "The Azure location where the private endpoint will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the private endpoint."
  type        = string
}

variable "subnet_id" {
  description = "The ID of the subnet within which the private endpoint will be created."
  type        = string
}

variable "connection_name" {
  description = "The name of the private service connection."
  type        = string
}

variable "resource_id" {
  description = "The ID of the resource to which the private endpoint will connect."
  type        = string
  sensitive   = true
}

variable "subresource_names" {
  description = "A list of subresource names for the private service connection."
  type        = list(string)
}

variable "is_manual_connection" {
  description = "Whether the private service connection is manual. Default is false."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A map of tags to assign to the private endpoint."
  type        = map(string)
  default     = {}
}

variable "private_dns_zone_id" {
  description = "The ID of the private DNS zone to associate with the private endpoint."
  type        = string
  default     = null
}
