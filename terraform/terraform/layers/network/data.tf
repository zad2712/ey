data "azurerm_subnet" "github_subnet" {
  count                = local.enable_github_subnet_data ? 1 : 0
  name                 = var.github_subnet_name
  virtual_network_name = var.github_vnet_name
  resource_group_name  = var.github_vnet_rg_name
}