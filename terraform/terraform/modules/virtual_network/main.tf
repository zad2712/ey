resource "azurerm_virtual_network" "azure_vnet" {
  name                = var.name
  address_space       = var.address_space
  location            = var.location
  resource_group_name = var.resource_group_name
  tags                = var.tags

  # Recommendation: Activate DDoS Protection if required
  dynamic "ddos_protection_plan" {
    for_each = var.enable_ddos_protection ? [1] : []
    content {
      id     = var.ddos_protection_plan_id
      enable = var.enable_ddos_protection
    }
  }
}

resource "azurerm_subnet" "azure_subnet" {
  for_each = { for subnet in var.subnets : subnet.name => subnet }

  name                                  = each.value.name
  address_prefixes                      = [each.value.address_prefix]
  resource_group_name                   = var.resource_group_name
  virtual_network_name                  = azurerm_virtual_network.azure_vnet.name
  service_endpoints                     = lookup(each.value, "service_endpoints", null)
  private_endpoint_network_policies     = lookup(each.value, "private_endpoint_network_policies", null)


  dynamic "delegation" {
    for_each = lookup(each.value, "delegation", null) != null ? [each.value.delegation] : []
    content {
      name = delegation.value.name

      service_delegation {
        name    = delegation.value.service_delegation.name
        actions = delegation.value.service_delegation.actions
      }
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "vnet_logs" {
  name               = "${azurerm_virtual_network.azure_vnet.name}-diagnostic"
  target_resource_id = azurerm_virtual_network.azure_vnet.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "VMProtectionAlerts"
  }

  # enabled_log {
  #   category = "VMProtectionNotifications"
  # }

  enabled_metric {
    category = "AllMetrics"
  }
}