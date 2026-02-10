variable "name" {}
variable "resource_group_name" {}
variable "location" {}

variable "subnet_ids" {
  description = "List of subnet IDs to allow access to the storage account. If empty, no VNet rules will be applied."
  type        = list(string)
  default     = []
}

variable "ip_rules" {
  description = "List of IP addresses or CIDR ranges to allow access to the storage account. If empty, no IP rules will be applied."
  type        = list(string)
  default     = []
}

variable "private_link_endpoint_resource_id" {
  description = "The resource ID of the Private Link Endpoint to allow access to the storage account. If null, no private link access will be configured."
  type        = string
  default     = null
}

variable "private_link_endpoint_tenant_id" {
  description = "Optional tenant ID of the Private Link Endpoint. If omitted while resource id is provided, current authenticated tenant id will be used." 
  type        = string
  default     = null
  validation {
    condition     = var.private_link_endpoint_tenant_id == null || (length(var.private_link_endpoint_tenant_id) > 0 && can(regex("^[0-9a-fA-F-]{36}$", var.private_link_endpoint_tenant_id)))
    error_message = "private_link_endpoint_tenant_id must be a valid GUID when provided."
  }
}

variable "account_tier" {
  default = "Standard"
}
variable "account_replication_type" {
  default = "LRS"
}
variable "allow_nested_items_to_be_public" {
  description = "Allow or disallow nested items to be public"
  type        = bool
  default     = true
}
variable "tags" {
  type    = map(string)
  default = {}
}

variable "log_analytics_workspace_id" {
  description = "The ID of the Log Analytics Workspace to send diagnostics to. If null, diagnostics will not be configured."
  type        = string
  default     = null
}

variable "diag_resource_name_prefix" {
  description = "Optional override for the storage account resource name prefix used when constructing diagnostic setting names. Use to match existing diagnostic names in specific environments (e.g. QA). If null, uses the storage account 'name' variable."
  type        = string
  default     = null
}

variable "account_infra_encryption_enabled" {
  description = "Enable infrastructure encryption for the storage account"
  type        = bool
  default     = false
}

variable "enable_malware_scanning" {
  description = "Enable Microsoft Defender for Storage malware scanning on the storage account"
  type        = bool
  default     = false
}

variable "malware_scan_cap_gb_per_month" {
  description = "Monthly cap in GB for malware scanning. Set to 5000 as per requirements. Use -1 for unlimited scanning."
  type        = number
  default     = 5000
}

variable "enable_sensitive_data_discovery" {
  description = "Enable sensitive data discovery feature in Microsoft Defender for Storage"
  type        = bool
  default     = true
}

variable "malware_scan_subscription_name" {
  description = "The name of the Event Grid subscription used for malware scan results"
  type        = string
  default     = "MalwareScanSubscription"
}

# Function App Name for data source - We use this to get the function ID that's used by the malware scan event subscription
variable "function_app_name_app_01" {
  description = "Name of the Windows Function App that processes malware scan event results. Required when enable_malware_scanning is true and you want Event Grid integration. If null, malware scanning will be enabled without Event Grid subscription."
  type        = string
  default     = null
}

# This is the default name of the function app function used by the Event Subscription in Malware Scan configuration.
variable "function_app_function_name" {
  description = "Malware Scan - Event Subscription - Function name"
  type        = string
  default     = "ProcessMalwareScanResult"
}

variable "malware_scan_exclude_blobs_with_prefix" {
  description = "List of blob prefixes to exclude from malware scanning. Format: container-name/blob-name. To exclude entire containers, use container name WITH trailing slash. Examples: ['logs/', 'cache/', 'temp/']"
  type        = list(string)
  default     = []
  validation {
    condition = length(var.malware_scan_exclude_blobs_with_prefix) <= 1000
    error_message = "The exclude blobs with prefix list cannot exceed 1000 patterns as per Azure Storage limitations."
  }
}

variable "malware_scan_exclude_blobs_with_suffix" {
  description = "List of blob suffixes (file extensions) to exclude from malware scanning. Should be used for file extensions only. Examples: ['.log', '.tmp', '.config']"
  type        = list(string)
  default     = []
  validation {
    condition = length(var.malware_scan_exclude_blobs_with_suffix) <= 1000
    error_message = "The exclude blobs with suffix list cannot exceed 1000 patterns as per Azure Storage limitations."
  }
}

variable "malware_scan_exclude_blobs_larger_than" {
  description = "Maximum size in bytes for blobs to be scanned. Blobs larger than this value will be excluded. Set to null to disable size-based exclusion."
  type        = number
  default     = null
  validation {
    condition = var.malware_scan_exclude_blobs_larger_than == null || var.malware_scan_exclude_blobs_larger_than > 0
    error_message = "The exclude blobs larger than value must be a positive number or null."
  }
}

variable "blob_delete_retention_policy_days" {
  description = "blob delete retention policy days"
  type        = number
  default     = 14
}

variable "public_network_access_enabled" {
  description = "public network access"
  type        = bool
  default     = false
}