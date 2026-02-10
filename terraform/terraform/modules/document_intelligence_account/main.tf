resource "azurerm_cognitive_account" "doc_intelligence_account" {
  name                          = var.document_intelligence_account_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  kind                          = "FormRecognizer"
  sku_name                      = var.sku_name
  tags                          = var.tags
  custom_subdomain_name         = var.custom_subdomain_name // This enables the custom subdomain
  public_network_access_enabled = var.public_network_access_enabled

  identity {
    type = "SystemAssigned"
  }
    # Network ACLs configuration to match current Azure state
  network_acls {
    default_action = var.network_acls_default_action
    ip_rules       = var.network_acls_ip_rules
  }
}

resource "azurerm_monitor_diagnostic_setting" "doc_intelligence_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.document_intelligence_account_name}-diagnostic"
  target_resource_id         = azurerm_cognitive_account.doc_intelligence_account.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "Audit" // Example category, adjust as needed
  }

  enabled_log {
    category = "RequestResponse" // Example category, adjust as needed
  }
  enabled_metric {
    category = "AllMetrics"
  }
}