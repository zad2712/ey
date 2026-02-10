variable "openai_account_name" {
  description = "Name of the Azure OpenAI account."
  type        = string
}

variable "openai_account_id" {
  description = "The ID of the Azure OpenAI account."
  type        = string
}

variable "resource_group_name" {
  description = "Name of the resource group where the OpenAI account resides."
  type        = string
}

variable "deployments" {
  description = "A map of OpenAI model deployments to create."
  type = map(object({
    deployment_name = string // Custom name for this deployment instance
    model_format    = string // e.g., "OpenAI"
    model_name      = string // The base model identifier, e.g., "gpt-4o", "text-embedding-ada-002"
    model_version   = string // The specific version of the model, e.g., "2024-05-13" for gpt-4o, "2" for ada
    sku_name        = string // SKU name for the deployment, e.g., "Standard" or "Default"
    sku_capacity    = number // SKU capacity for the deployment (e.g., for standard scale type)
  }))
  default = {}
}

variable "log_analytics_workspace_id" {
  description = "Log Analytics Workspace ID for diagnostics."
  type        = string
  default     = null
}