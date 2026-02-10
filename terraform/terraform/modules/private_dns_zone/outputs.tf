# ============================================================================
# OUTPUTS - Azure Verified Module (AVM) Compatible
# ============================================================================
# These outputs follow AVM naming conventions for seamless integration with
# existing infrastructure that uses AVM modules.
# ============================================================================

# ============================================================================
# PRIMARY OUTPUTS
# ============================================================================

output "resource_id" {
  value       = azurerm_private_dns_zone.this.id
  description = "The resource ID of the Private DNS Zone. AVM-compatible output."
}

output "resource" {
  value       = azurerm_private_dns_zone.this
  description = <<-DESCRIPTION
    The full Private DNS Zone resource object with all attributes.
    Use this for accessing any property not explicitly exposed in other outputs.
    AVM-compatible output.
  DESCRIPTION
}

output "name" {
  value       = azurerm_private_dns_zone.this.name
  description = "The FQDN name of the Private DNS Zone (e.g., privatelink.blob.core.windows.net)."
}

output "id" {
  value       = azurerm_private_dns_zone.this.id
  description = "The resource ID of the Private DNS Zone (alternative to resource_id for backward compatibility)."
}

# ============================================================================
# VIRTUAL NETWORK LINK OUTPUTS
# ============================================================================

output "virtual_network_links" {
  value = {
    for k, link in azurerm_private_dns_zone_virtual_network_link.this : k => {
      id                   = link.id
      name                 = link.name
      virtual_network_id   = link.virtual_network_id
      registration_enabled = link.registration_enabled
    }
  }
  description = <<-DESCRIPTION
    Map of Virtual Network links with their key properties.
    Each entry contains the link's resource ID, name, associated VNet ID, and registration status.
  DESCRIPTION
}

output "virtual_network_link_ids" {
  value = {
    for k, link in azurerm_private_dns_zone_virtual_network_link.this : k => link.id
  }
  description = "Map of Virtual Network link keys to their resource IDs."
}

# ============================================================================
# DNS ZONE PROPERTIES
# ============================================================================

output "number_of_record_sets" {
  value       = azurerm_private_dns_zone.this.number_of_record_sets
  description = "The current number of record sets in this Private DNS Zone (excluding SOA and default NS records)."
}

output "max_number_of_record_sets" {
  value       = azurerm_private_dns_zone.this.max_number_of_record_sets
  description = "The maximum number of record sets that can be created in this Private DNS Zone."
}

output "max_number_of_virtual_network_links" {
  value       = azurerm_private_dns_zone.this.max_number_of_virtual_network_links
  description = "The maximum number of virtual network links that can be created for this Private DNS Zone."
}

output "max_number_of_virtual_network_links_with_registration" {
  value       = azurerm_private_dns_zone.this.max_number_of_virtual_network_links_with_registration
  description = "The maximum number of virtual network links with registration enabled that can be created."
}

# ============================================================================
# SOA RECORD
# ============================================================================

output "soa_record" {
  value = try(azurerm_private_dns_zone.this.soa_record[0], null)
  description = <<-DESCRIPTION
    The SOA (Start of Authority) record for this Private DNS Zone.
    Contains authoritative information about the DNS zone including serial number,
    refresh intervals, and contact information.
  DESCRIPTION
}

# ============================================================================
# DIAGNOSTIC SETTINGS
# ============================================================================

output "diagnostic_setting_id" {
  value       = try(azurerm_monitor_diagnostic_setting.this[0].id, null)
  description = "The resource ID of the diagnostic setting, if configured."
}

# ============================================================================
# MANAGEMENT LOCK
# ============================================================================

output "lock_id" {
  value       = try(azurerm_management_lock.this[0].id, null)
  description = "The resource ID of the management lock, if configured."
}

# ============================================================================
# METADATA OUTPUTS
# ============================================================================

output "resource_group_name" {
  value       = azurerm_private_dns_zone.this.resource_group_name
  description = "The name of the resource group containing the Private DNS Zone."
}

output "tags" {
  value       = azurerm_private_dns_zone.this.tags
  description = "The tags applied to the Private DNS Zone."
}
