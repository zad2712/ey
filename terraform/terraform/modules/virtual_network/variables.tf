variable "name" {
  description = "VNet Name"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the existing resource group"
  type        = string
}

variable "location" {
  description = "resource group location"
  type        = string
}

variable "address_space" {
  description = "Address range for the VNet"
  type        = list(string)
  default     = ["10.0.0.0/16"]
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = "standard tags: OWNER, DEPLOYMENT_ID, PEER, etc"
}

variable "enable_ddos_protection" {
  type        = bool
  default     = false
  description = "Enables standard DDoS protection if true"
}

variable "ddos_protection_plan_id" {
  type        = string
  default     = null
  description = "DDoS Protection plan ID (required if enable_ddos_protection=true)"
}

variable "subnets" {
  type = list(object({
    name                              = string
    address_prefix                    = string
    service_endpoints                 = optional(list(string))
    private_endpoint_network_policies = optional(string)
    delegation = optional(object({
      name = string
      service_delegation = object({
        name    = string
        actions = list(string)
      })
    }))
  }))
  description = "List of subnets with configuration"
}

### Diagnostic 
variable "log_analytics_workspace_id" {
  description = "log_analytics_workspace id "
  type        = string
}