variable "name" {
  description = "NSG name"
  type        = string
}

variable "location" {
  description = "az region"
  type        = string
}

variable "resource_group_name" {
  description = "Name of the Resource Group where the NSG is created"
  type        = string
}

variable "tags" {
  description = "optional tags"
  type        = map(string)
  default     = {}
}

variable "additional_security_rules" {
  description = "List of additional safety rules"
  type = list(object({
    name                                       = string
    priority                                   = number
    direction                                  = string
    access                                     = string
    protocol                                   = string
    description                                = optional(string)
    source_port_range                          = optional(string)
    source_port_ranges                         = optional(list(string))
    destination_port_range                     = optional(string)
    destination_port_ranges                    = optional(list(string))
    source_address_prefix                      = optional(string)
    source_address_prefixes                    = optional(list(string))
    destination_address_prefix                 = optional(string)
    destination_address_prefixes               = optional(list(string))
    source_application_security_group_ids      = optional(list(string))
    destination_application_security_group_ids = optional(list(string))
  }))
  default = []

  validation {
    condition = alltrue([
      for rule in var.additional_security_rules : !(
        (rule.source_port_range != null && rule.source_port_range != "") &&
        (rule.source_port_ranges != null && length(rule.source_port_ranges) > 0)
      )
    ])
    error_message = "Cannot specify both source_port_range and source_port_ranges. Use only one format per rule."
  }

  validation {
    condition = alltrue([
      for rule in var.additional_security_rules : !(
        (rule.destination_port_range != null && rule.destination_port_range != "") &&
        (rule.destination_port_ranges != null && length(rule.destination_port_ranges) > 0)
      )
    ])
    error_message = "Cannot specify both destination_port_range and destination_port_ranges. Use only one format per rule."
  }

  validation {
    condition = alltrue([
      for rule in var.additional_security_rules : !(
        (rule.source_address_prefix != null && rule.source_address_prefix != "") &&
        (rule.source_address_prefixes != null && length(rule.source_address_prefixes) > 0)
      )
    ])
    error_message = "Cannot specify both source_address_prefix and source_address_prefixes. Use only one format per rule."
  }

  validation {
    condition = alltrue([
      for rule in var.additional_security_rules : !(
        (rule.destination_address_prefix != null && rule.destination_address_prefix != "") &&
        (rule.destination_address_prefixes != null && length(rule.destination_address_prefixes) > 0)
      )
    ])
    error_message = "Cannot specify both destination_address_prefix and destination_address_prefixes. Use only one format per rule."
  }
}


### Diagnostic 
variable "log_analytics_workspace_id" {
  description = "log_analytics_workspace id "
  type        = string
}