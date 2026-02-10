resource "azurerm_network_security_group" "azure_nsg" {
  name                = var.name
  location            = var.location
  resource_group_name = var.resource_group_name

  dynamic "security_rule" {
    for_each = local.security_rules_with_conditionals
    content {
      name        = security_rule.value.rule.name
      priority    = security_rule.value.rule.priority
      direction   = security_rule.value.rule.direction
      access      = security_rule.value.rule.access
      protocol    = security_rule.value.rule.protocol
      description = try(security_rule.value.rule.description, null)

      # Use singular or plural source port ranges, but not both
      source_port_range  = security_rule.value.src_port_ranges_present ? null : security_rule.value.rule.source_port_range
      source_port_ranges = security_rule.value.src_port_ranges_present ? security_rule.value.rule.source_port_ranges : null

      # Use singular or plural destination port ranges, but not both
      destination_port_range  = security_rule.value.dst_port_ranges_present ? null : security_rule.value.rule.destination_port_range
      destination_port_ranges = security_rule.value.dst_port_ranges_present ? security_rule.value.rule.destination_port_ranges : null

      # Use singular or plural source address prefixes, but not both
      source_address_prefix   = security_rule.value.src_addr_prefixes_present ? null : security_rule.value.rule.source_address_prefix
      source_address_prefixes = security_rule.value.src_addr_prefixes_present ? security_rule.value.rule.source_address_prefixes : null

      # Use singular or plural destination address prefixes, but not both
      destination_address_prefix   = security_rule.value.dst_addr_prefixes_present ? null : security_rule.value.rule.destination_address_prefix
      destination_address_prefixes = security_rule.value.dst_addr_prefixes_present ? security_rule.value.rule.destination_address_prefixes : null

      source_application_security_group_ids      = try(security_rule.value.rule.source_application_security_group_ids, null)
      destination_application_security_group_ids = try(security_rule.value.rule.destination_application_security_group_ids, null)
    }
  }

  tags = var.tags

  # lifecycle {
  #   ignore_changes = [
  #   security_rule
  #   ]
  # }


}

resource "azurerm_monitor_diagnostic_setting" "azure_diagnostic" {
  name                       = "${azurerm_network_security_group.azure_nsg.name}-diagnostic"
  target_resource_id         = azurerm_network_security_group.azure_nsg.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "NetworkSecurityGroupEvent"
    retention_policy {
      enabled = true
      days    = 365
    }
  }

  enabled_log {
    category = "NetworkSecurityGroupRuleCounter"
    retention_policy {
      enabled = true
      days    = 365
    }
  }

  # enabled_log {
  #   category = "AzureActivity" 
  #   retention_policy { deprecated
  #     enabled = true
  #     days    = 365
  #  }
  # }
}

