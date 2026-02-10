##################
#### GENERAL #####
##################
variable "env" {
  description = "Environment type (QA, UAT, PROD)"
  type        = string
  validation {
    condition     = contains(["QA", "UAT", "PROD"], var.env)
    error_message = "Environment must be one of: QA, UAT, PROD."
  }
}

variable "resource_group_name_admin" {
  description = "Admin resource group name"
  type        = string
}

variable "vnet_admin_name_01" {
  description = "Admin VNET name"
  type        = string
}

################################
#### PRIVATE DNS ZONES #########
################################
variable "enable_telemetry" {
  description = "Enable telemetry for the resources. Default is false."
  type        = bool
  default     = false
}

#####################
### LAB SUB-ENV ####
####################
variable "lab_vnet_app_name_01" {
  description = "Lab frontend VNET name"
  type        = string
}

variable "lab_vnet_app_name_02" {
  description = "Lab backend VNET name"
  type        = string
}

variable "lab_resource_group_name_app" {
  description = "Lab resource group name"
  type        = string
}

#######################
### PILOT SUB-ENV ####
#######################
variable "pilot_vnet_app_name_01" {
  description = "Pilot frontend VNET name (not used in QA)"
  type        = string
  default     = ""
}

variable "pilot_vnet_app_name_02" {
  description = "Pilot backend VNET name (not used in QA)"
  type        = string
  default     = ""
}

variable "pilot_resource_group_name_app" {
  description = "Pilot resource group name (not used in QA)"
  type        = string
  default     = ""
}

#######################
### PROD SUB-ENV #####
#######################
variable "prod_vnet_app_name_01" {
  description = "Prod frontend VNET name (not used in QA)"
  type        = string
  default     = ""
}

variable "prod_vnet_app_name_02" {
  description = "Prod backend VNET name (not used in QA)"
  type        = string
  default     = ""
}

variable "prod_resource_group_name_app" {
  description = "Prod resource group name (not used in QA)"
  type        = string
  default     = ""
}