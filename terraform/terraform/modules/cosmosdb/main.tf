resource "azurerm_cosmosdb_account" "cosmosdb_account" {
  name                = var.account_name
  resource_group_name = var.resource_group_name
  location            = var.location
  offer_type          = "Standard"
  kind                = "GlobalDocumentDB" 
  tags                = var.tags
  consistency_policy {
    consistency_level = "Session"
  }

  geo_location {
    location          = var.location
    failover_priority = 0
  }

  identity {
    type = "SystemAssigned"
  }

  public_network_access_enabled = var.enable_public_network # Enable public network access
}

resource "azurerm_monitor_diagnostic_setting" "cosmosdb_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.account_name}-diagnostic"
  target_resource_id         = azurerm_cosmosdb_account.cosmosdb_account.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  enabled_log {
    category = "DataPlaneRequests"
  }
  
  # Not supported in the latest Terraform provider version
  # enabled_log {
  #   category = "DataPlaneRequests - Aggregated 5 Min"
  # }

  # Not supported in the latest Terraform provider version
  # enabled_log {
  #   category = "DataPlaneRequests - Aggregated 15 Min"
  # }

  enabled_log {
    category = "MongoRequests"
  }

  enabled_log {
    category = "QueryRuntimeStatistics"
  }

  enabled_log {
    category = "PartitionKeyStatistics"
  }

  enabled_log {
    category = "PartitionKeyRUConsumption"
  }

  enabled_log {
    category = "ControlPlaneRequests"
  }

  enabled_log {
    category = "CassandraRequests"
  }

  enabled_log {
    category = "GremlinRequests"
  }

  enabled_log {
    category = "TableApiRequests"
  }
  enabled_metric {
    category = "Requests"
  }

  enabled_metric {
    category = "SLI"
  }
}