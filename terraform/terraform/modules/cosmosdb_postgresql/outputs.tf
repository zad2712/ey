output "id" {
  description = "The ID of the Cosmos DB PostgreSQL Cluster."
  value       = azurerm_cosmosdb_postgresql_cluster.postgresql_cluster.id
}

output "name" {
  description = "The name of the Cosmos DB PostgreSQL Cluster."
  value       = azurerm_cosmosdb_postgresql_cluster.postgresql_cluster.name
}

output "administrator_login" {
  description = "The administrator login name for the PostgreSQL Cluster."
  value       = var.administrator_login
}

output "database_name" {
  description = "The name of the database created in the PostgreSQL Cluster."
  value       = var.database_name
}