variable "subnet_id" {
  description = "ID of the subnet to associate the NSG with"
  type        = string
}

variable "nsg_id" {
  description = "Name of the NSG"
  type        = string
  default     = "nsg-apim"
}