output "id" {
  description = "The Service Bus Namespace ID"
  value       = azurerm_servicebus_namespace.sb_namespace.id
}

output "name" {
  description = "The Service Bus Namespace name"
  value       = azurerm_servicebus_namespace.sb_namespace.name
}

output "identity_principal_id" {
  description = "The Principal ID of the System Assigned Managed Identity for the Service Bus namespace"
  value       = azurerm_servicebus_namespace.sb_namespace.identity.0.principal_id
}

output "default_primary_connection_string" {
  description = "The primary connection string for the Service Bus namespace"
  value       = azurerm_servicebus_namespace.sb_namespace.default_primary_connection_string
  sensitive   = true
}

output "queues" {
  description = "Map of queue names to their IDs"
  value       = { for k, v in azurerm_servicebus_queue.sb_queue : k => v.id }
}
