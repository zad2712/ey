resource "azurerm_private_dns_zone_virtual_network_link" "zone_vnet_link" {
  for_each = var.virtual_network_ids
  name                  = "${each.key}-${var.name}-link"
  private_dns_zone_name = var.private_dns_zone_name
  resource_group_name   = var.resource_group_name
  virtual_network_id    = each.value
  registration_enabled  = false

  provider = azurerm.admin
}