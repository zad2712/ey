resource "azurerm_cosmosdb_postgresql_cluster" "postgresql_cluster" {
  name                = var.name
  resource_group_name = var.resource_group_name
  location            = var.location
  administrator_login_password = var.administrator_login_password # Use a secure password or secret management
  coordinator_server_edition       = "GeneralPurpose"
  coordinator_storage_quota_in_mb  = 131072  # 128 GiB storage
  coordinator_vcore_count          = 8       # 8 vCores / 32 GiB RAM
  
  node_count = 0
  node_public_ip_access_enabled = false

  coordinator_public_ip_access_enabled = false
  
  
  tags = var.tags
}

# The database is created automatically when the cluster is created
# The default database name is defined by the administrator_login parameter
# Additional databases can be created post-deployment using PostgreSQL commands

resource "azurerm_monitor_diagnostic_setting" "postgresql_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.name}-diagnostic"
  target_resource_id         = azurerm_cosmosdb_postgresql_cluster.postgresql_cluster.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "PostgreSQLLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}