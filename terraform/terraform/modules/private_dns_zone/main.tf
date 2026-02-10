# ============================================================================
# Azure Private DNS Zone - Custom Module
# ============================================================================
# This module creates and manages Azure Private DNS Zones with VNet links
# following Azure best practices and security standards.
#
# Key Features:
# - Comprehensive input validation for domain names and resource naming
# - Support for multiple VNet links with auto-registration capabilities
# - Lifecycle management to prevent accidental deletion
# - SOA record configuration with validation
# - Tag lifecycle management (ignores system-generated tags)
# - AVM-compatible outputs for seamless integration
# - Diagnostic settings support for monitoring
# ============================================================================

# ============================================================================
# PRIVATE DNS ZONE
# ============================================================================

resource "azurerm_private_dns_zone" "this" {
  name                = var.domain_name
  resource_group_name = var.resource_group_name
  
  # SOA (Start of Authority) Record Configuration
  # Only configure if custom SOA settings are provided
  dynamic "soa_record" {
    for_each = var.soa_record != null ? [var.soa_record] : []
    
    content {
      email         = soa_record.value.email
      expire_time   = soa_record.value.expire_time
      minimum_ttl   = soa_record.value.minimum_ttl
      refresh_time  = soa_record.value.refresh_time
      retry_time    = soa_record.value.retry_time
      ttl           = soa_record.value.ttl
    }
  }
  
  tags = var.tags
  
  # Lifecycle Management
  # Prevent accidental deletion in production environments
  lifecycle {
    # Ignore changes to system-managed tags
    ignore_changes = [
      tags["created_date"],
      tags["created_by"],
      tags["ms-resource-usage"]
    ]
    
    # Prevent accidental deletion
    prevent_destroy = false # Set to true in production via override
  }
}

# ============================================================================
# VIRTUAL NETWORK LINKS
# ============================================================================

resource "azurerm_private_dns_zone_virtual_network_link" "this" {
  for_each = var.virtual_network_links
  
  name                  = each.value.name != null ? each.value.name : "${each.key}-link"
  resource_group_name   = var.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.this.name
  virtual_network_id    = each.value.vnetid
  
  # Auto-registration allows VMs in the VNet to automatically register their DNS records
  # Typically disabled for Azure PaaS services (false) but enabled for VM scenarios (true)
  registration_enabled  = try(each.value.registration_enabled, false)
  
  tags = merge(
    var.tags,
    try(each.value.tags, {})
  )
  
  # Lifecycle Management
  lifecycle {
    # Ignore system-managed tags
    ignore_changes = [
      tags["created_date"],
      tags["created_by"]
    ]
    
    # Prevent accidental deletion
    prevent_destroy = false # Set to true in production via override
  }
}

# ============================================================================
# DIAGNOSTIC SETTINGS (Optional)
# ============================================================================

resource "azurerm_monitor_diagnostic_setting" "this" {
  count = var.diagnostic_settings != null ? 1 : 0
  
  name                           = var.diagnostic_settings.name
  target_resource_id             = azurerm_private_dns_zone.this.id
  log_analytics_workspace_id     = var.diagnostic_settings.log_analytics_workspace_id
  storage_account_id             = try(var.diagnostic_settings.storage_account_id, null)
  eventhub_authorization_rule_id = try(var.diagnostic_settings.eventhub_authorization_rule_id, null)
  eventhub_name                  = try(var.diagnostic_settings.eventhub_name, null)
  
  # Audit Logs for DNS Zone
  dynamic "enabled_log" {
    for_each = try(var.diagnostic_settings.enabled_log_categories, ["AuditEvent"])
    
    content {
      category = enabled_log.value
    }
  }
  
  # Metrics
  dynamic "metric" {
    for_each = try(var.diagnostic_settings.enabled_metrics, ["AllMetrics"])
    
    content {
      category = metric.value
      enabled  = true
    }
  }
}

# ============================================================================
# MANAGEMENT LOCK (Optional)
# ============================================================================

resource "azurerm_management_lock" "this" {
  count = var.lock != null ? 1 : 0
  
  name       = var.lock.name != null ? var.lock.name : "${var.domain_name}-lock"
  scope      = azurerm_private_dns_zone.this.id
  lock_level = var.lock.kind
  notes      = try(var.lock.notes, "Managed by Terraform - Prevents accidental deletion")
  
  lifecycle {
    # Prevent lock from being destroyed without explicit action
    prevent_destroy = false # Set to true in production via override
  }
}
