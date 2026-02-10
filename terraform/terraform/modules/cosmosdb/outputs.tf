output "cosmosdb_account_id" {
  description = "The ID of the Cosmos DB Account."
  value       = azurerm_cosmosdb_account.cosmosdb_account.id
}

output "cosmosdb_account_endpoint" {
  description = "The endpoint of the Cosmos DB Account."
  value       = azurerm_cosmosdb_account.cosmosdb_account.endpoint
}

output "cosmosdb_account_primary_key" {
  description = "The primary key for the Cosmos DB Account."
  value       = azurerm_cosmosdb_account.cosmosdb_account.primary_key
  sensitive   = true
}