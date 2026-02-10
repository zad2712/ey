variable "name" {
  description = "name"
  type        = string
}
variable "origin_group_name" {
  description = "origin group name"
  type        = string
}
variable "profile_name" {
  description = "profile name"
  type        = string
}
variable "resource_group_name" {
  description = "resource group name"
  type        = string
}
variable "enabled" {
  description = "enable resource"
  type        = bool
  default     = true
}
variable "certificate_name_check_enabled" {
  description = "certificate name check enabled"
  type        = bool
  default     = false
}
variable "apim_hostname" {
  description = "enable resource"
  type        = string
}
variable "http_port" {
  description = "http port"
  type        = number
}
variable "https_port" {
  description = "https port"
  type        = number
}
variable "origin_host_header" {
  description = "origin host header"
  type        = string
  default     = null
}
variable "priority" {
  description = "priority"
  type        = number
}
variable "weight" {
  description = "weight"
  type        = number
}