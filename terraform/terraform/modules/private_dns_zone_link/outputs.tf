output "private_dns_zone_link_id" {
  description = "IDs of the private DNS zone virtual network links"
  value       = { for k, v in azurerm_private_dns_zone_virtual_network_link.zone_vnet_link : k => v.id }
}