resource "azurerm_container_registry" "acr" {
  name                          = var.acr_name
  resource_group_name           = var.resource_group_name
  location                      = var.location
  sku                           = var.sku
  admin_enabled                 = var.admin_enabled
  zone_redundancy_enabled       = var.sku == "Premium" ? var.zone_redundancy_enabled : false
  network_rule_bypass_option    = var.network_rule_bypass_option
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags

  dynamic "identity" {
    for_each = [1]
    content {
      type         = "SystemAssigned, UserAssigned"
      identity_ids = []
    }
  }

    lifecycle {
    # Ignore user assigned identity_ids as they are managed outside Terraform
    # Using ignore_changes on the entire identity block to prevent conflicts with externally managed identities
    ignore_changes = [
      identity
    ]
    precondition {
      condition     = var.zone_redundancy_enabled && var.sku == "Premium" || !var.zone_redundancy_enabled
      error_message = "The Premium SKU is required if zone redundancy is enabled."
    }
  }
}

resource "azurerm_monitor_diagnostic_setting" "acr_diagnostic" {
  name                       = "${var.acr_name}-diagnostic"
  target_resource_id         = azurerm_container_registry.acr.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ContainerRegistryRepositoryEvents"
    // enabled = true // 'enabled = true' is the default when the block is present
  }

  enabled_log {
    category = "ContainerRegistryLoginEvents"
    // enabled = true // 'enabled = true' is the default when the block is present
  }
  enabled_metric {
    category = "AllMetrics"

    // Optional: configure retention policy for metrics
    // retention_policy {
    //   enabled = false // Or true
    //   days    = 0     // Or the number of days to retain
    // }
  }
}