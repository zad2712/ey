variable "account_name" {
  description = "The name of the Cosmos DB account."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Cosmos DB account."
  type        = string
}

variable "location" {
  description = "The Azure location where the Cosmos DB account should exist."
  type        = string
}

variable "tags" {
  description = "A map of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace to send diagnostics to. If null, diagnostics will not be configured."
  type        = string
  default     = null
}
variable "maximum_throughput" {
  description = "The maximum throughput for the Cosmos DB account."
  type        = number
  default     = 400
}

variable "enable_public_network" {
  description = "Whether to enable public network access for the Cosmos DB account."
  type        = bool
  default     = false
}