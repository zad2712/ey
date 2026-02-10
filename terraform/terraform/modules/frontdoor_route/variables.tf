variable "name" {
  description = "name"
  type        = string
}
variable "profile_name" {
  description = "profile name"
  type        = string
}
variable "endpoint_name" {
  description = "endpoint name"
  type        = string
}
variable "origin_group_name" {
  description = "origin group name"
  type        = string
}
variable "resource_group_name" {
  description = "resource group name"
  type        = string
}
variable "supported_protocols" {
  description = "supported protocols"
  type        = list(string)
}
variable "patterns_to_match" {
  description = "pattern to match"
  type        = list(string)
}
variable "forwarding_protocols" {
  description = "forwarding protocols"
  type        = string
}
variable "https_redirect_enabled" {
  description = "https redirect enabled"
  type        = bool
}
variable "enabled" {
  description = "enabled"
  type        = bool
  default     = true
}
variable "origin_path" {
  description = "origin path"
  type        = string
}
variable "catching_enabled" {
  description = "catching enabled"
  type        = bool
}
variable "rules_engine_name" {
  description = "rules engine name"
  type        = string
  default     = null
}