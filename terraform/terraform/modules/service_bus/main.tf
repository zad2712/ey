


resource "azurerm_servicebus_namespace" "sb_namespace" {
  name                         = var.namespace_name
  location                     = var.location
  resource_group_name          = var.resource_group_name
  sku                          = var.sku
  tags                         = var.tags
  capacity                     = var.capacity
  premium_messaging_partitions = var.premium_messaging_partitions

  identity {
    type = "SystemAssigned"
  }

  

  network_rule_set {
    
    public_network_access_enabled = false
    
    default_action = "Deny"
    trusted_services_allowed = true

    ip_rules = [ "0.0.0.0/0"]
 }

}

resource "azurerm_servicebus_queue" "sb_queue" {
  for_each = { for queue in var.queues : queue.name => queue }

  name                  = each.value.name
  namespace_id          = azurerm_servicebus_namespace.sb_namespace.id
  max_size_in_megabytes = 1024
  lock_duration         = try(each.value.lock_duration, "PT1M")  # Default to 1 minute if not specified
}


resource "azurerm_servicebus_namespace_authorization_rule" "namespace_sas_policy" {
  name                = "GeneralSharedAccessKey"
  namespace_id        = azurerm_servicebus_namespace.sb_namespace.id
  listen              = true
  send                = true
  manage              = false

}

# # Shared Access Policy for  queue
# resource "azurerm_servicebus_queue_authorization_rule" "queue_policy" {
#   for_each = { for queue in var.queues : queue.name => queue }
#   name     = "GeneralSharedAccessKey"
#   queue_id = azurerm_servicebus_queue.sb_queue[each.key].id
#   listen   = true
#   send     = true
#   manage   = false
# }





resource "azurerm_monitor_diagnostic_setting" "sb_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.namespace_name}-diagnostic"
  target_resource_id         = azurerm_servicebus_namespace.sb_namespace.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "OperationalLogs"
  }

  enabled_log {
    category = "DiagnosticErrorLogs"
  }

  enabled_log {
    category = "VNetAndIPFilteringLogs"
  }

  enabled_log {
    category = "RuntimeAuditLogs"
  }

  enabled_log {
    category = "DataDRLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}
