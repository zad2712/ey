# data.tf - Data sources to get all sub-environment VNETs

# Admin VNET (shared across all sub-envs)
data "azurerm_virtual_network" "admin_vnet" {
  name                = var.vnet_admin_name_01
  resource_group_name = var.resource_group_name_admin
}

# LAB Environment VNETs
data "azurerm_virtual_network" "lab_frontend_vnet" {
  name                = var.lab_vnet_app_name_01
  resource_group_name = var.lab_resource_group_name_app
}

data "azurerm_virtual_network" "lab_backend_vnet" {
  name                = var.lab_vnet_app_name_02
  resource_group_name = var.lab_resource_group_name_app
}

# PILOT Environment VNETs (not used in QA)
data "azurerm_virtual_network" "pilot_frontend_vnet" {
  count               = var.env == "QA" ? 0 : 1
  name                = var.pilot_vnet_app_name_01
  resource_group_name = var.pilot_resource_group_name_app
}

data "azurerm_virtual_network" "pilot_backend_vnet" {
  count               = var.env == "QA" ? 0 : 1
  name                = var.pilot_vnet_app_name_02
  resource_group_name = var.pilot_resource_group_name_app
}

# PROD Environment VNETs (not used in QA)
data "azurerm_virtual_network" "prod_frontend_vnet" {
  count               = var.env == "QA" ? 0 : 1
  name                = var.prod_vnet_app_name_01
  resource_group_name = var.prod_resource_group_name_app
}

data "azurerm_virtual_network" "prod_backend_vnet" {
  count               = var.env == "QA" ? 0 : 1
  name                = var.prod_vnet_app_name_02
  resource_group_name = var.prod_resource_group_name_app
}

# Admin Resource Group
data "azurerm_resource_group" "admin" {
  name = var.resource_group_name_admin
}