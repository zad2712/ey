resource "azurerm_private_endpoint" "pep" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  subnet_id           = var.subnet_id
  private_service_connection {
    name                           = var.connection_name
    private_connection_resource_id = sensitive(var.resource_id)
    subresource_names              = var.subresource_names
    is_manual_connection           = var.is_manual_connection
  }
  tags = var.tags

  dynamic "private_dns_zone_group" {
    for_each = var.private_dns_zone_id != null ? [1] : []
    content {
      name                 = "${var.name}-dns-zone-group"
      private_dns_zone_ids = [var.private_dns_zone_id]
    }
  }
  # lifecycle: ignoring changes fix for "custom_network_interface_name" to avoid replacements in QA
  lifecycle {
    ignore_changes = [custom_network_interface_name]
  }
}