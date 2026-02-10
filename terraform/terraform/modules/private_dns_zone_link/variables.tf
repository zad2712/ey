variable "name" {
  description = "The name of the private DNS zone link."
  type        = string
}

variable "private_dns_zone_name" {
  description = "The name of the private DNS zone to link."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the private DNS zone."
  type        = string
}

variable "virtual_network_ids" {
  description = "The IDs of the virtual networks to link the private DNS zone."
  type        = map(string)
}