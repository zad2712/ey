variable "enable_peering" {
  description = "Whether to create VNet peering"
  type        = bool
  default     = false
}

variable "remote_vnet_id" {
  description = "The ID of the remote VNet to peer with"
  type        = string
  default     = null
}

variable "remote_vnet_name" {
  description = "The name of the remote VNet (used for naming only)"
  type        = string
  default     = null
}