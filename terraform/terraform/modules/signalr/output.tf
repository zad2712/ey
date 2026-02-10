output "signalr_id" {
  description = "SignalR Service ID"
  value       = azurerm_signalr_service.signalr.id
}

output "signalr_hostname" {
  description = "SignalR Service Hostname"
  value       = azurerm_signalr_service.signalr.hostname
}

output "signalr_primary_connection_string" {
  description = "Primary connection string"
  value       = azurerm_signalr_service.signalr.primary_connection_string
  sensitive   = true
}