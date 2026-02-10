variable "name" {
  type = string
}

variable "resource_group_id" {
  type = string
}

variable "location" {
  type = string
}

variable "subnet_id" {
  type = string
}

variable "business_id" {
  type = string
}

variable "tags" {
  description = "optional tags"
  type        = map(string)
  default     = {}
}