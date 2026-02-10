output "id" {
  description = "The ID of the storage account"
  value       = azurerm_storage_account.storage_account.id
}

output "name" {
  description = "The name of the storage account"
  value       = azurerm_storage_account.storage_account.name
}

output "primary_access_key" {
  description = "The primary access key for the storage account"
  value       = azurerm_storage_account.storage_account.primary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The primary connection string for the storage account"
  value       = azurerm_storage_account.storage_account.primary_connection_string
  sensitive   = true
}

output "primary_blob_endpoint" {
  description = "The primary blob endpoint URL"
  value       = azurerm_storage_account.storage_account.primary_blob_endpoint
}

output "primary_table_endpoint" {
  description = "The primary table endpoint URL"
  value       = azurerm_storage_account.storage_account.primary_table_endpoint
}

output "primary_queue_endpoint" {
  description = "The primary queue endpoint URL"
  value       = azurerm_storage_account.storage_account.primary_queue_endpoint
}

output "primary_file_endpoint" {
  description = "The primary file endpoint URL"
  value       = azurerm_storage_account.storage_account.primary_file_endpoint
}

output "primary_blob_connection_string" {
  description = "The primary connection string for the blob service"
  value       = "${azurerm_storage_account.storage_account.primary_connection_string};BlobEndpoint=${azurerm_storage_account.storage_account.primary_blob_endpoint}"
  sensitive   = true
}

output "primary_table_connection_string" {
  description = "The primary connection string for the table service"
  value       = "${azurerm_storage_account.storage_account.primary_connection_string};TableEndpoint=${azurerm_storage_account.storage_account.primary_table_endpoint}"
  sensitive   = true
}

output "primary_queue_connection_string" {
  description = "The primary connection string for the queue service"
  value       = "${azurerm_storage_account.storage_account.primary_connection_string};QueueEndpoint=${azurerm_storage_account.storage_account.primary_queue_endpoint}"
  sensitive   = true
}

output "primary_file_connection_string" {
  description = "The primary connection string for the file service"
  value       = "${azurerm_storage_account.storage_account.primary_connection_string};FileEndpoint=${azurerm_storage_account.storage_account.primary_file_endpoint}"
  sensitive   = true
}

output "malware_scan_event_grid_topic_id" {
  description = "The ID of the Event Grid topic for malware scan results"
  value       = var.enable_malware_scanning && length(azurerm_eventgrid_topic.malware_scan_topic) > 0 ? azurerm_eventgrid_topic.malware_scan_topic[0].id : null
}

output "malware_scan_event_grid_topic_name" {
  description = "The name of the Event Grid topic for malware scan results"
  value       = var.enable_malware_scanning && length(azurerm_eventgrid_topic.malware_scan_topic) > 0 ? azurerm_eventgrid_topic.malware_scan_topic[0].name : null
}

output "malware_scan_event_grid_topic_endpoint" {
  description = "The endpoint URL of the Event Grid topic for malware scan results"
  value       = var.enable_malware_scanning && length(azurerm_eventgrid_topic.malware_scan_topic) > 0 ? azurerm_eventgrid_topic.malware_scan_topic[0].endpoint : null
}

output "defender_for_storage_enabled" {
  description = "Whether Microsoft Defender for Storage is enabled on this storage account"
  value       = var.enable_malware_scanning
}

output "malware_scan_event_subscription_created" {
  description = "Whether the Event Grid Event Subscription for malware scan results was created. Requires both malware scanning to be enabled and a valid function app name."
  value       = var.enable_malware_scanning && var.function_app_name_app_01 != null
}

output "malware_scan_event_subscription_id" {
  description = "The ID of the Event Grid Event Subscription for malware scan results, if created"
  value       = length(azurerm_eventgrid_event_subscription.malware_scan_subscription) > 0 ? azurerm_eventgrid_event_subscription.malware_scan_subscription[0].id : null
}

output "malware_scan_exclude_prefixes_configured" {
  description = "List of blob prefixes configured for exclusion from malware scanning"
  value       = var.malware_scan_exclude_blobs_with_prefix
}

output "malware_scan_exclude_suffixes_configured" {
  description = "List of blob suffixes configured for exclusion from malware scanning"
  value       = var.malware_scan_exclude_blobs_with_suffix
}

output "malware_scan_exclude_large_blobs_threshold" {
  description = "Size threshold (in bytes) for excluding large blobs from malware scanning"
  value       = var.malware_scan_exclude_blobs_larger_than
}

output "malware_scan_exclusions_total_count" {
  description = "Total number of exclusion patterns configured for malware scanning"
  value       = length(var.malware_scan_exclude_blobs_with_prefix) + length(var.malware_scan_exclude_blobs_with_suffix) + (var.malware_scan_exclude_blobs_larger_than != null ? 1 : 0)
}
