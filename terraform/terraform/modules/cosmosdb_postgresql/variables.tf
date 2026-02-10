variable "name" {
  description = "The name of the Cosmos DB PostgreSQL Cluster."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Cosmos DB PostgreSQL Cluster."
  type        = string
}

variable "location" {
  description = "The Azure location where the Cosmos DB PostgreSQL Cluster should exist."
  type        = string
}

variable "administrator_login" {
  description = "The administrator login name for the PostgreSQL Cluster."
  type        = string
  default     = "citus"
}

variable "administrator_login_password" {
  description = "The administrator login password for the PostgreSQL Cluster."
  type        = string
  sensitive   = true
}

variable "database_name" {
  description = "The name of the database to create in the PostgreSQL Cluster."
  type        = string
  default     = "citus"
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

variable "enable_public_network" {
  description = "Whether to enable public network access for the Cosmos DB account."
  type        = bool
  default     = false
}