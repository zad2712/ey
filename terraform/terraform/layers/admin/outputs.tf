# Admin Layer Outputs
# These outputs expose Private DNS Zone IDs for consumption by other layers via terraform_remote_state
# Updated to use custom module (maintains AVM-compatible output structure)

output "private_dns_zone_ids" {
  description = "Map of private DNS zone names (keys) to their resource IDs"
  value = {
    for key, zone in module.private_dns_zone :
    key => zone.resource_id
  }
}

output "private_dns_zone_names" {
  description = "Map of private DNS zone keys to their FQDN names"
  value = {
    for key, zone in module.private_dns_zone :
    key => zone.resource.name
  }
}

# Additional outputs from custom module (optional, for debugging/monitoring)
output "private_dns_zone_vnet_links" {
  description = "Map of private DNS zone VNet links with their details"
  value = {
    for key, zone in module.private_dns_zone :
    key => zone.virtual_network_links
  }
  sensitive = false
}

output "private_dns_zone_record_counts" {
  description = "Map of private DNS zones to their current record counts"
  value = {
    for key, zone in module.private_dns_zone :
    key => {
      current_records = zone.number_of_record_sets
      max_records     = zone.max_number_of_record_sets
    }
  }
}
