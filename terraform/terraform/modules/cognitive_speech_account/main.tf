resource "azurerm_cognitive_account" "speech_account" {
  name                          = var.speech_account_name
  location                      = var.location
  resource_group_name           = var.resource_group_name
  kind                          = "SpeechServices"
  sku_name                      = var.sku_name
  tags                          = var.tags
  custom_subdomain_name         = var.custom_subdomain_name
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

resource "azurerm_monitor_diagnostic_setting" "speech_diagnostic" {
  name                       = "${var.speech_account_name}-diagnostic"
  target_resource_id         = azurerm_cognitive_account.speech_account.id
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

    // Optional: configure retention policy for metrics
    // retention_policy {
    //   enabled = false // Or true
    //   days    = 0     // Or the number of days to retain
    // }
  }
}