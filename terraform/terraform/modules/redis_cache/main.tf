resource "azurerm_redis_cache" "redis" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name
  capacity            = var.capacity
  family              = var.family
  sku_name            = var.sku_name
  non_ssl_port_enabled = var.enable_non_ssl_port  
  minimum_tls_version = var.minimum_tls_version
  tags                = var.tags

  redis_configuration {
  }

  identity {
    type = "SystemAssigned"
  }

  public_network_access_enabled = var.enable_public_network # Enable public network access
}

resource "azurerm_monitor_diagnostic_setting" "redis_diagnostic" {
  name                       = "${var.name}-diagnostic"
  target_resource_id         = azurerm_redis_cache.redis.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ConnectedClientList"
  }

  enabled_log {
    category = "MSEntraAuthenticationAuditLog"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}