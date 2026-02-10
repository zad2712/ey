resource "azapi_resource" "network_settings" {
  type      = "GitHub.Network/networkSettings@2024-04-02"
  name      = var.name
  parent_id = var.resource_group_id
  location  = var.location
  tags      = var.tags

  body = {
    properties = {
      subnetId   = var.subnet_id
      businessId = var.business_id
    }
  }
}



