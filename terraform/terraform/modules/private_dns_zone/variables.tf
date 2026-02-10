# ============================================================================
# REQUIRED VARIABLES
# ============================================================================

variable "domain_name" {
  type        = string
  description = <<-DESCRIPTION
    The domain name for the Private DNS Zone. Must be a valid DNS name.
    Examples:
    - privatelink.blob.core.windows.net
    - privatelink.azurewebsites.net
    - privatelink.redis.cache.windows.net
  DESCRIPTION
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9]([a-zA-Z0-9-\\.]{0,251}[a-zA-Z0-9])?$", var.domain_name))
    error_message = "The domain_name must be a valid DNS name (1-253 characters, alphanumeric, hyphens, and dots allowed)."
  }
  
  validation {
    condition     = length(var.domain_name) >= 1 && length(var.domain_name) <= 253
    error_message = "The domain_name must be between 1 and 253 characters long."
  }
}

variable "resource_group_name" {
  type        = string
  description = <<-DESCRIPTION
    The name of the resource group where the Private DNS Zone will be created.
    The resource group must already exist.
  DESCRIPTION
  
  validation {
    condition     = can(regex("^[a-zA-Z0-9-_()]{1,90}$", var.resource_group_name))
    error_message = "The resource_group_name must be 1-90 characters, containing only alphanumerics, underscores, hyphens, and parentheses."
  }
}

# ============================================================================
# OPTIONAL VARIABLES
# ============================================================================

variable "virtual_network_links" {
  type = map(object({
    name                 = optional(string)        # Link name (defaults to "{key}-link")
    vnetid               = string                  # Virtual Network resource ID
    registration_enabled = optional(bool, false)   # Enable auto-registration (default: false)
    tags                 = optional(map(string))   # Additional tags for this link
  }))
  default     = {}
  description = <<-DESCRIPTION
    Map of Virtual Network links to associate with this Private DNS Zone.
    Each link connects the DNS zone to a VNet, allowing resources in that VNet to resolve private endpoints.
    
    Key: Unique identifier for the link (e.g., "admin", "frontend-lab", "backend-pilot")
    Value:
    - name: (Optional) Name of the VNet link. Defaults to "{key}-link".
    - vnetid: (Required) Resource ID of the Virtual Network to link.
    - registration_enabled: (Optional) Enable auto-registration of VM DNS records. Default: false.
      Set to true for VM scenarios, false for PaaS/private endpoint scenarios.
    - tags: (Optional) Additional tags to merge with the module's base tags.
    
    Example:
    ```hcl
    virtual_network_links = {
      admin = {
        name   = "admin-vnet-link"
        vnetid = "/subscriptions/.../virtualNetworks/admin-vnet"
      }
      frontend = {
        vnetid = "/subscriptions/.../virtualNetworks/frontend-vnet"
        registration_enabled = false
      }
    }
    ```
  DESCRIPTION
  
  validation {
    condition = alltrue([
      for k, v in var.virtual_network_links : 
      can(regex("^/subscriptions/[a-f0-9-]+/resourceGroups/.+/providers/Microsoft.Network/virtualNetworks/.+$", v.vnetid))
    ])
    error_message = "All vnetid values must be valid Azure Virtual Network resource IDs."
  }
}

variable "tags" {
  type        = map(string)
  default     = {}
  description = <<-DESCRIPTION
    Tags to apply to all resources created by this module.
    Tags help with organization, cost tracking, and governance.
    
    Common tags:
    - ENVIRONMENT: Environment identifier (DEV, QA, UAT, PROD)
    - DEPLOYMENT_ID: Deployment identifier
    - ENGAGEMENT_ID: Project/Engagement identifier
    - OWNER: Team or individual responsible for the resource
    - hidden-title: Display name in Azure Portal
    
    Note: System-managed tags (created_date, created_by, ms-resource-usage) are automatically ignored in lifecycle.
  DESCRIPTION
  
  validation {
    condition = alltrue([
      for k, v in var.tags : length(k) <= 512 && length(v) <= 256
    ])
    error_message = "Tag keys must be <= 512 characters and values <= 256 characters."
  }
}

variable "soa_record" {
  type = object({
    email        = string           # Contact email (e.g., azureprivatedns.net)
    expire_time  = optional(number) # Expire time in seconds (default: 2419200 - 28 days)
    minimum_ttl  = optional(number) # Minimum TTL in seconds (default: 10)
    refresh_time = optional(number) # Refresh time in seconds (default: 3600 - 1 hour)
    retry_time   = optional(number) # Retry time in seconds (default: 300 - 5 minutes)
    ttl          = optional(number) # TTL in seconds (default: 3600 - 1 hour)
  })
  default     = null
  description = <<-DESCRIPTION
    (Optional) Custom SOA (Start of Authority) record configuration for the DNS zone.
    If not specified, Azure default SOA settings will be used.
    
    Recommended to leave as default (null) unless specific SOA requirements exist.
    
    Fields:
    - email: Contact email address (required if soa_record is set)
    - expire_time: Zone expiry time in seconds (default: 2419200 - 28 days)
    - minimum_ttl: Negative caching TTL in seconds (default: 10)
    - refresh_time: How often secondary DNS servers refresh from primary (default: 3600 - 1 hour)
    - retry_time: Retry interval if refresh fails (default: 300 - 5 minutes)
    - ttl: SOA record TTL in seconds (default: 3600 - 1 hour)
  DESCRIPTION
  
  validation {
    condition = var.soa_record == null || (
      var.soa_record.email != null &&
      (var.soa_record.expire_time == null || var.soa_record.expire_time >= 0) &&
      (var.soa_record.minimum_ttl == null || var.soa_record.minimum_ttl >= 0) &&
      (var.soa_record.refresh_time == null || var.soa_record.refresh_time >= 0) &&
      (var.soa_record.retry_time == null || var.soa_record.retry_time >= 0) &&
      (var.soa_record.ttl == null || var.soa_record.ttl >= 0)
    )
    error_message = "SOA record email is required when soa_record is configured, and all time values must be non-negative."
  }
}

variable "diagnostic_settings" {
  type = object({
    name                           = string                  # Name of the diagnostic setting
    log_analytics_workspace_id     = string                  # Log Analytics Workspace resource ID
    storage_account_id             = optional(string)        # Optional: Storage Account for archival
    eventhub_authorization_rule_id = optional(string)        # Optional: Event Hub for streaming
    eventhub_name                  = optional(string)        # Optional: Event Hub name
    enabled_log_categories         = optional(list(string))  # Log categories (default: ["AuditEvent"])
    enabled_metrics                = optional(list(string))  # Metrics (default: ["AllMetrics"])
  })
  default     = null
  description = <<-DESCRIPTION
    (Optional) Diagnostic settings configuration for monitoring and auditing.
    Sends logs and metrics to Log Analytics, Storage Account, or Event Hub.
    
    If enabled, audit logs will track:
    - DNS zone configuration changes
    - VNet link additions/removals
    - Record set modifications
    
    Fields:
    - name: Name of the diagnostic setting
    - log_analytics_workspace_id: (Required) Log Analytics Workspace resource ID
    - storage_account_id: (Optional) Storage Account for long-term log retention
    - eventhub_authorization_rule_id: (Optional) Event Hub authorization rule ID
    - eventhub_name: (Optional) Event Hub name for log streaming
    - enabled_log_categories: (Optional) Log categories to enable (default: ["AuditEvent"])
    - enabled_metrics: (Optional) Metrics to enable (default: ["AllMetrics"])
  DESCRIPTION
}

variable "lock" {
  type = object({
    kind = string           # "CanNotDelete" or "ReadOnly"
    name = optional(string) # Lock name (defaults to "{domain_name}-lock")
    notes = optional(string) # Notes about the lock
  })
  default     = null
  description = <<-DESCRIPTION
    (Optional) Management lock to prevent accidental deletion or modification.
    Recommended for production environments to protect critical DNS zones.
    
    Lock Types:
    - CanNotDelete: Allows reads and updates, but prevents deletion
    - ReadOnly: Allows only reads, prevents updates and deletion
    
    Fields:
    - kind: (Required) Lock type - "CanNotDelete" or "ReadOnly"
    - name: (Optional) Lock name. Defaults to "{domain_name}-lock"
    - notes: (Optional) Notes describing the purpose of the lock
    
    Example:
    ```hcl
    lock = {
      kind  = "CanNotDelete"
      name  = "prod-dns-zone-lock"
      notes = "Prevents accidental deletion of production Private DNS Zone"
    }
    ```
  DESCRIPTION
  
  validation {
    condition     = var.lock == null || contains(["CanNotDelete", "ReadOnly"], var.lock.kind)
    error_message = "Lock kind must be either 'CanNotDelete' or 'ReadOnly'."
  }
}

variable "enable_telemetry" {
  type        = bool
  default     = false
  description = <<-DESCRIPTION
    Enable Microsoft to identify the Terraform module used to create this resource.
    This helps Microsoft improve the module and Azure services.
    
    When enabled, a unique identifier is added to the deployment metadata.
    No customer data or personally identifiable information is collected.
    
    Default: false (disabled)
  DESCRIPTION
}
