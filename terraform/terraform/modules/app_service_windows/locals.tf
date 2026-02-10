locals {
  # Normalize managed identity configuration for simplified resource reference
  managed_identities = {
    system_assigned            = var.managed_identities.system_assigned
    user_assigned_resource_ids = toset(var.managed_identities.user_assigned_resource_ids)
  }
}
