###########################
# Shared Module Locals ####
###########################
locals {
  # QA App-layer Private DNS Zones
  qa_app_dns_zone_keys = [
    "storage_blob",
    "storage_queue",
    "storage_table",
    "app_service",
    "signalr",
    "speech",
    "document_intelligence",
    "container_registry",
    "container_app_environment"
  ]

  qa_app_dns_zone_map = {
    for k in local.qa_app_dns_zone_keys :
    k => lookup(var.private_dns_zones_names_app, k, null)
    if lookup(var.private_dns_zones_names_app, k, null) != null
  }

  # QA Backend-Layer Private DNS Zones
  qa_backend_dns_zone_keys = [
    "redis",
    "servicebus",
    "cosmosdb",
    "postgresql",
  ]

  qa_backend_dns_zone_map = {
    for k in local.qa_backend_dns_zone_keys :
    k => lookup(var.private_dns_zones_names_backend, k, null)
    if lookup(var.private_dns_zones_names_backend, k, null) != null
  }

  # Output grouping (kept for clarity – could reuse *_keys directly)
  qa_app_dns_output_keys     = local.qa_app_dns_zone_keys
  qa_backend_dns_output_keys = local.qa_backend_dns_zone_keys

  ##############################################
  # Admin Resource Group Selection (Shared Module)
  ##############################################
  # Selects the correct admin resource group name for data sources in the shared module.
  # DEV environments (DEV1/2/3) use shared_rg_admin_dev (in dev_integration subscription),
  # while QA/UAT/PROD use shared_rg_admin (in default subscription).
  # This enables cross-subscription resource lookups for admin resources.
  shared_rg_admin_name = length(data.azurerm_resource_group.shared_rg_admin_dev) > 0 ? data.azurerm_resource_group.shared_rg_admin_dev[0].name : (
    length(data.azurerm_resource_group.shared_rg_admin) > 0 ? data.azurerm_resource_group.shared_rg_admin[0].name : null
  )

  ##############################################
  # Admin VNet Selection (Shared Module)
  ##############################################
  # Selects the correct admin virtual network name based on environment.
  # DEV environments use shared_vnet_admin_01_dev (in dev_integration subscription),
  # while QA/UAT/PROD use shared_vnet_admin_01 (in default subscription).
  shared_vnet_admin_01_name = length(data.azurerm_virtual_network.shared_vnet_admin_01_dev) > 0 ? data.azurerm_virtual_network.shared_vnet_admin_01_dev[0].name : (
    length(data.azurerm_virtual_network.shared_vnet_admin_01) > 0 ? data.azurerm_virtual_network.shared_vnet_admin_01[0].name : null
  )

  ##############################################
  # Admin Subnet Selection (Shared Module)
  ##############################################
  # Selects the correct admin subnet ID based on environment.
  # DEV environments use shared_subnet_admin_01_dev (in dev_integration subscription),
  # while QA/UAT/PROD use shared_subnet_admin_01 (in default subscription).
  shared_subnet_admin_01_id = length(data.azurerm_subnet.shared_subnet_admin_01_dev) > 0 ? data.azurerm_subnet.shared_subnet_admin_01_dev[0].id : (
    length(data.azurerm_subnet.shared_subnet_admin_01) > 0 ? data.azurerm_subnet.shared_subnet_admin_01[0].id : null
  )
}
