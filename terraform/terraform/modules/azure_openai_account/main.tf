resource "azurerm_cognitive_account" "openai_account" {
  name                          = var.openai_account_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  kind                          = "OpenAI"
  sku_name                      = var.sku_name
  custom_subdomain_name         = var.openai_custom_subdomain_name
  public_network_access_enabled = var.public_network_access_enabled
  tags                          = var.tags

  identity {
    type = "SystemAssigned"
  }
  
  # Network ACLs configuration to match current Azure state
  network_acls {
    default_action = var.network_acls_default_action
    bypass         = var.network_acls_bypass
    ip_rules       = var.network_acls_ip_rules
  }
}

resource "azurerm_monitor_diagnostic_setting" "openai_diagnostic" {
  name                       = "${var.openai_account_name}-diagnostic"
  target_resource_id         = azurerm_cognitive_account.openai_account.id
  log_analytics_workspace_id = var.log_analytics_workspace_id


  # enabled_log {
  #   category = "Request and Response Logs"
  #   // enabled = true // 'enabled = true' is the default when the block is present
  # }

  # enabled_log {
  #   category = "Azure OpenAI Request Usage"
  #   // enabled = true // 'enabled = true' is the default when the block is present
  # }

  enabled_metric {
    category = "AllMetrics"
  }
}