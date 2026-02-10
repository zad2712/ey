resource "azurerm_virtual_network_peering" "this" {
  count = var.enable_peering ? 1 : 0

  name                      = "${var.name}-to-${var.remote_vnet_name}"
  resource_group_name       = var.resource_group_name
  virtual_network_name      = var.name
  remote_virtual_network_id = var.remote_vnet_id

  allow_virtual_network_access = true
  allow_forwarded_traffic      = false
  allow_gateway_transit        = false
  use_remote_gateways          = false
}