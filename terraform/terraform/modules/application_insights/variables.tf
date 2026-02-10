variable "name" {
  description = "The name of the Application Insights component."
  type        = string
}

variable "location" {
  description = "The Azure region where the Application Insights component will be created."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Application Insights component."
  type        = string
}

variable "workspace_id" {
  description = "The ID of the Log Analytics Workspace to which the Application Insights component will send its data."
  type        = string
}

variable "application_type" {
  description = "The type of application being monitored. Valid values are: ios, java, MobileCenter, Node.JS, other, phone, store, web."
  type        = string
  default     = "web"
}

variable "retention_in_days" {
  description = "The retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730."
  type        = number
  default     = 90
}

variable "sampling_percentage" {
  description = "The percentage of telemetry items tracked that will be transmitted to Application Insights."
  type        = number
  default     = 100
}

variable "internet_ingestion_enabled" {
  description = "Should the Application Insights component accept data ingestion over the public internet?"
  type        = bool
  default     = true
}

variable "internet_query_enabled" {
  description = "Should the Application Insights component accept queries over the public internet?"
  type        = bool
  default     = true
}

variable "local_authentication_disabled" {
  description = "Disable Non-Azure AD based authentication to the Application Insights component."
  type        = bool
  default     = false
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}
