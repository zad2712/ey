resource "azurerm_cosmosdb_sql_database" "db" {
  name                = var.database_name
  resource_group_name = var.resource_group_name
  account_name        = var.cosmosdb_account_name
  throughput          = 400 // or use autoscale block if needed
}

resource "azurerm_cosmosdb_sql_container" "container" {
  for_each = var.containers

  name                = each.key
  resource_group_name = var.resource_group_name
  account_name        = var.cosmosdb_account_name
  database_name       = azurerm_cosmosdb_sql_database.db.name

  partition_key_paths    = [each.value.partition_key_path]
  partition_key_version  = try(each.value.partition_key_version, 2)

  throughput = try(each.value.throughput, null)

  dynamic "unique_key" {
    for_each = each.value.unique_key_paths != null ? each.value.unique_key_paths : []
    content {
      paths = [unique_key.value]
    }
  }

  default_ttl = try(each.value.default_ttl, null)

  depends_on = [azurerm_cosmosdb_sql_database.db]
}