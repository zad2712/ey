variable "container_app_name" {
  description = "Name of the Container App"
  type        = string
}

variable "location" {
  description = "The Azure region where the Container App should exist."
  type        = string
}

variable "resource_group_name" {
  description = "The name of the resource group in which to create the Container App."
  type        = string
}

variable "container_app_environment_id" {
  description = "The ID of the Container App Environment to host this Container App."
  type        = string
}

variable "container_name" {
  description = "Name of the container within the Container App"
  type        = string
}

variable "container_image" {
  description = "Container image reference"
  type        = string
}

variable "container_cpu" {
  description = "The CPU cores to allocate to the container."
  type        = number
}

variable "container_memory" {
  description = "The memory to allocate to the container (e.g., '0.5Gi')."
  type        = string
}

variable "tags" {
  description = "A mapping of tags to assign to the resource."
  type        = map(string)
  default     = {}
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics workspace to send diagnostics to"
  type        = string
  default     = null
}