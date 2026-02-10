variable "cosmosdb_account_name" {
  description = "Name of the existing Cosmos DB account"
  type        = string
}

variable "resource_group_name" {
  description = "Resource group of the Cosmos DB account"
  type        = string
}

variable "database_name" {
  description = "Name of the Cosmos DB SQL database"
  type        = string
}

variable "containers" {
  description = "Map of container definitions. Key is container name."
  type = map(object({
    partition_key_path         = string
    partition_key_version      = optional(number, 2)
    throughput                 = optional(number)
    autoscale_max_throughput   = optional(number)
    default_ttl                = optional(number)
    unique_key_paths           = optional(list(string))
  }))
}
