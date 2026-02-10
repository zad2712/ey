#####################
### SHARED DATA ####
####################
variable "resource_group_name_app" {
  description = "resource_group app name"
  type        = string
  default     = null
}
variable "log_analytics_workspace_app_name" {
  type        = string
  description = "Log Analytics Workspace app name"
  default     = null
}

variable "vnet_app_name_01" {
  description = "vnet app name"
  type        = string
  default     = null
}

variable "subnet_app_name_03" {
  description = "subnet admin name"
  type        = string
  default     = null
}


#######################
#### apim #############
#######################

variable "apim_name" {
  description = "API Management name"
  type        = string
}

variable "publisher_name" {
  description = "publisher name"
  type        = string
}

variable "publisher_email" {
  description = "Publisher Email"
  type        = string
}

variable "sku_name" {
  type        = string
  description = "SKU name"
}
variable "virtual_network_type" {
  type        = string
  description = "virtual network type"
}

variable "apim_tags" {
  description = "Specific tags for APIM"
  type        = map(string)
  default     = {}
}

##########################
####### front door #######
##########################
variable "profile_name" {
  description = "profile name"
  type        = string
}
variable "resource_group_fd" {
  description = "frontdoor resource group origin"
  type        = string
}

### frontdoor_origin ###
variable "fd_origin_name" {
  description = "name"
  type        = string
}
variable "origin_group_name" {
  description = "origin group name"
  type        = string
}
# variable "apim_hostname" {
#   description = "enable resource"
#   type        = string
# }
variable "http_port" {
  description = "http port"
  type        = number
}
variable "https_port" {
  description = "https port"
  type        = number
}
variable "priority" {
  description = "priority"
  type        = number
}
variable "weight" {
  description = "weight"
  type        = number
}

### frontdoor_route ###
variable "endpoint_name" {
  description = "endpoint name"
  type        = string
}
variable "fd_route_name" {
  description = "name"
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
variable "origin_path" {
  description = "origin path"
  type        = string
}
variable "catching_enabled" {
  description = "catching enabled"
  type        = bool
}


#############################
###### GENERAL #############
############################
variable "tags" {
  description = "Etiquetas estándar CTP"
  type        = map(string)
}