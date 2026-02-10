output "resource" {
  description = "The full resource group object. This is the default output for the module following AVM standards."
  value       = azurerm_resource_group.this
}

output "id" {
  description = "The ID of the resource group."
  value       = azurerm_resource_group.this.id
}

output "name" {
  description = "The name of the resource group."
  value       = azurerm_resource_group.this.name
}

output "location" {
  description = "The Azure region where the resource group is located."
  value       = azurerm_resource_group.this.location
}

output "tags" {
  description = "The tags assigned to the resource group."
  value       = azurerm_resource_group.this.tags
}

output "role_assignments" {
  description = "A map of role assignments created on the resource group."
  value       = azurerm_role_assignment.this
}

output "lock" {
  description = "The management lock resource if one was created."
  value       = try(azurerm_management_lock.this[0], null)
}
