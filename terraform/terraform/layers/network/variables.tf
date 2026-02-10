### GENERAL
variable "tags" {
  description = "Etiquetas estándar CTP"
  type        = map(string)
}

variable "admin_resources" {
  description = "Deploy admin resources"
  type        = bool
  default     = true
}

variable "env" {
  description = "Environment type (DEV, QA, UAT, PROD)"
  type        = string
  validation {
    condition     = contains(["DEV", "QA", "UAT", "PROD"], var.env)
    error_message = "Environment must be one of: DEV, QA, UAT, PROD."
  }
}

############################################
### Route Table for APIM (All Environments)
############################################
variable "enable_apim_route_table" {
  description = "Enable APIM route table with UDR for API Management service tag"
  type        = bool
  default     = false
}

variable "route_table_apim_name" {
  description = "Name for APIM route table"
  type        = string
  default     = null
}

variable "route_table_apim_tags" {
  description = "Specific tags for APIM route table"
  type        = map(string)
  default     = {}
}

#################################
### GitHub Variables - QA ##########
#################################
variable "github_subnet_name" {
  description = "GitHub subnet name (required when env is QA)"
  type        = string
  default     = null
}

variable "github_vnet_name" {
  description = "GitHub VNet name (required when env is QA)"
  type        = string
  default     = null
}

variable "github_vnet_rg_name" {
  description = "GitHub VNet resource group name (required when env is QA)"
  type        = string
  default     = null
}

########################
### VNet Specific Tags #
########################

variable "vnet_admin_tags" {
  description = "Specific tags for admin VNet"
  type        = map(string)
  default     = {}
}

variable "vnet_frontend_tags" {
  description = "Specific tags for frontend VNet"
  type        = map(string)
  default     = {}
}

variable "vnet_backend_tags" {
  description = "Specific tags for backend VNet"
  type        = map(string)
  default     = {}
}

variable "github_settings_tags" {
  description = "Tags for github_settings"
  type        = map(string)
  default     = null
}

variable "nsg_admin_tags" {
  description = "Specific tags for NGS"
  type        = map(string)
  default     = {}
}

variable "nsg_app_name_01_tags" {
  description = "Specific tags for nsg app_name_01"
  type        = map(string)
  default     = {}
}

variable "nsg_app_name_02_tags" {
  description = "Specific tags for nsg app_name_02"
  type        = map(string)
  default     = {}
}

variable "nsg_app_name_03_tags" {
  description = "Specific tags for nsg app_name_03"
  type        = map(string)
  default     = {}
}

variable "nsg_app_name_04_tags" {
  description = "Specific tags for nsg app_name_04"
  type        = map(string)
  default     = {}
}

variable "nsg_app_name_05_tags" {
  description = "Specific tags for nsg app_name_05"
  type        = map(string)
  default     = {}
}

variable "nsg_app_name_06_tags" {
  description = "Specific tags for nsg app_name_06"
  type        = map(string)
  default     = {}
}

### SHARED DATA 
variable "resource_group_name_admin" {
  description = "resource_group admin name"
  type        = string
  default     = null
}
variable "resource_group_name_app" {
  description = "resource_group app name"
  type        = string
  default     = null
}
variable "log_analytics_workspace_admin_name" {
  type        = string
  description = "Log Analytics Workspace admin name"
  default     = null
}
variable "log_analytics_workspace_app_name" {
  type        = string
  description = "Log Analytics Workspace app name"
  default     = null
}


####################
### VNETS############
####################
#### VNET Admin 01
variable "vnet_admin_name_01" {
  description = "vnet name"
  type        = string
  default     = null
}
variable "vnet_address_space_admin_01" {
  description = "vnet name"
  type        = list(string)
  default     = null
}
variable "subnet1_name" {
  description = "subnet1 name"
  type        = string
  default     = null
}
variable "subnet2_name" {
  description = "subnet2 name"
  type        = string
  default     = null
}
variable "subnet1_address_prefix" {
  description = "subnet address prefix"
  type        = string
  default     = null
}
variable "subnet2_address_prefix" {
  description = "subnet address prefix"
  type        = string
  default     = null
}
variable "enable_ddos_protection" {
  type        = bool
  default     = false
  description = "Enables standard DDoS protection if true"
}
variable "ddos_protection_plan_id" {
  description = "ID del DDoS Protection Plan"
  type        = string
  default     = null
}

#### VNET app 01
variable "vnet_name_app_01" {
  description = "vnet name"
  type        = string
}
variable "vnet_address_space_app_01" {
  description = "vnet name"
  type        = list(string)
}
variable "subnet1_name_app_01" {
  description = "subnet1 name"
  type        = string
}
variable "subnet2_name_app_01" {
  description = "subnet2 name"
  type        = string
}
variable "subnet3_name_app_01" {
  description = "subnet2 name"
  type        = string
}
variable "subnet1_address_prefix_app_01" {
  description = "subnet address prefix"
  type        = string
}
variable "subnet2_address_prefix_app_01" {
  description = "subnet address prefix"
  type        = string
}
variable "subnet3_address_prefix_app_01" {
  description = "subnet address prefix"
  type        = string
}
variable "enable_ddos_protection_app_01" {
  type        = bool
  default     = false
  description = "Enables standard DDoS protection if true"
}
variable "ddos_protection_plan_id_app_01" {
  description = "ID del DDoS Protection Plan"
  type        = string
  default     = null
}

### VNET app 02
variable "vnet_name_app_02" {
  description = "vnet name"
  type        = string
}
variable "vnet_address_space_app_02" {
  description = "vnet name"
  type        = list(string)
}
variable "subnet1_name_app_02" {
  description = "subnet1 name"
  type        = string
}
variable "subnet2_name_app_02" {
  description = "subnet2 name"
  type        = string
}
variable "subnet3_name_app_02" {
  description = "subnet3 name"
  type        = string
}
variable "subnet1_address_prefix_app_02" {
  description = "subnet address prefix"
  type        = string
}
variable "subnet2_address_prefix_app_02" {
  description = "subnet address prefix"
  type        = string
}
variable "subnet3_address_prefix_app_02" {
  description = "subnet address prefix"
  type        = string
}
variable "enable_ddos_protection_app_02" {
  type        = bool
  default     = false
  description = "Enables standard DDoS protection if true"
}
variable "ddos_protection_plan_id_app_02" {
  description = "ID del DDoS Protection Plan"
  type        = string
  default     = null
}


### NSG
variable "nsg_admin_name_01" {
  description = "nsg admin name 01"
  type        = string
  default     = null
}
# variable "nsg_admin_name_02" {
#   description = "nsg admin name 02"
#   type        = string
# }

variable "nsg_app_name_01" {
  description = "nsg admin name 01"
  type        = string
}
variable "nsg_app_name_02" {
  description = "nsg admin name 02"
  type        = string
}
variable "nsg_app_name_03" {
  description = "nsg admin name 03"
  type        = string
}
variable "nsg_app_name_04" {
  description = "nsg admin name 04"
  type        = string
}
variable "nsg_app_name_05" {
  description = "nsg admin name 05"
  type        = string
}
variable "nsg_app_name_06" {
  description = "nsg admin name 06"
  type        = string
}

variable "additional_security_rules_nsg_admin_01" {
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
}
variable "additional_security_rules_nsg_app_01" {
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
}

variable "additional_security_rules_nsg_app_02" {
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
}

variable "additional_security_rules_nsg_app_03" {
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
}

variable "additional_security_rules_nsg_app_04" {
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
}

variable "additional_security_rules_nsg_app_05" {
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
}

variable "additional_security_rules_nsg_general" {
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
}



#################################
### GitHub Network Settings #####
#################################

variable "github_network_settings_name" {
  type    = string
  default = null
}

variable "business_id" {
  type    = string
  default = null
}

###########################
### Private DNS Zones #####
###########################
variable "enable_private_dns_zones" {
  description = "Enable private DNS zones for this environment"
  type        = bool
  default     = false
}

variable "create_dns_zones" {
  type        = bool
  default     = false
  description = "Whether to create private DNS zones"
}

variable "hidden_title_tag_env" {
  type        = string
  default     = null
  description = "The environment name used by the hidden title tag, e.g. dev1, dev2, uat-lab, prod."
}