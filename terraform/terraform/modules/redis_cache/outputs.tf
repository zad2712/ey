output "id" {
  description = "The ID of the Redis Cache."
  value       = azurerm_redis_cache.redis.id
}

output "hostname" {
  description = "The hostname of the Redis Cache."
  value       = azurerm_redis_cache.redis.hostname
}

output "port" {
  description = "The port used by the Redis Cache."
  value       = azurerm_redis_cache.redis.port
}

output "ssl_port" {
  description = "The SSL port used by the Redis Cache."
  value       = azurerm_redis_cache.redis.ssl_port
}

output "primary_access_key" {
  description = "The primary access key for the Redis Cache."
  value       = azurerm_redis_cache.redis.primary_access_key
  sensitive   = true
}

output "secondary_access_key" {
  description = "The secondary access key for the Redis Cache."
  value       = azurerm_redis_cache.redis.secondary_access_key
  sensitive   = true
}

output "primary_connection_string" {
  description = "The primary connection string for the Redis Cache."
  value       = azurerm_redis_cache.redis.primary_connection_string
  sensitive   = true
}

output "secondary_connection_string" {
  description = "The secondary connection string for the Redis Cache."
  value       = azurerm_redis_cache.redis.secondary_connection_string
  sensitive   = true
}

output "redis_configuration" {
  description = "The Redis configuration for the Redis Cache."
  value       = azurerm_redis_cache.redis.redis_configuration
}
