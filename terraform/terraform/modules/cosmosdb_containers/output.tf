# output "container_ids" {
#   description = "IDs of all Cosmos DB containers created."
#   value       = { for k, c in azurerm_cosmosdb_sql_container.container : k => c.id }
# }

# output "container_names" {
#   description = "Names of all Cosmos DB containers created."
#   value       = [for c in azurerm_cosmosdb_sql_container.container : c.name]
# }

# output "container_rids" {
#   description = "Resource IDs (rids) of all Cosmos DB containers."
#   value       = { for k, c in azurerm_cosmosdb_sql_container.container : k => c.resource_id }
# }
