output "session_pool_id" {
  description = "Resource ID of the Container App session pool"
  value       = var.enabled ? jsondecode(azurerm_resource_group_template_deployment.session_pool[0].output_content)["sessionPoolId"]["value"] : null
}

output "session_pool_name" {
  description = "Name of the Container App session pool"
  value       = var.enabled ? var.session_pool_name : null
}

output "pool_management_endpoint" {
  description = "Pool management endpoint for session pool API operations"
  value       = var.enabled ? jsondecode(azurerm_resource_group_template_deployment.session_pool[0].output_content)["poolManagementEndpoint"]["value"] : null
}

output "session_pool_location" {
  description = "Location of the session pool"
  value       = var.enabled ? var.location : null
}

output "max_concurrent_sessions" {
  description = "Maximum number of concurrent sessions configured for the pool"
  value       = var.enabled ? var.max_concurrent_sessions : null
}

output "ready_session_instances" {
  description = "Target number of ready session instances in the pool"
  value       = var.enabled ? var.ready_session_instances : null
}

output "container_type" {
  description = "Container type of the session pool"
  value       = var.enabled ? var.container_type : null
}

output "network_status" {
  description = "Network status configuration of the session pool"
  value       = var.enabled ? var.network_status : null
}

output "sessions_executor_role_assignments" {
  description = "List of Container Apps Sessions Executor role assignment IDs"
  value       = var.enabled && var.enable_default_roles ? azurerm_role_assignment.sessions_executor[*].id : []
}

output "sessionpools_contributor_role_assignments" {
  description = "List of Container Apps SessionPools Contributor role assignment IDs"
  value       = var.enabled && var.enable_default_roles ? azurerm_role_assignment.sessionpools_contributor[*].id : []
}

output "custom_role_assignments" {
  description = "List of custom role assignment IDs"
  value       = var.enabled ? azurerm_role_assignment.custom[*].id : []
}

output "role_assignment_summary" {
  description = "Summary of role assignments configured for the session pool"
  value = var.enabled ? {
    default_roles_enabled = var.enable_default_roles
    total_principals_provided = length(var.default_role_principals)
    valid_principals_count = length(local.valid_role_principals)
    invalid_principals_count = length(var.default_role_principals) - length(local.valid_role_principals)
    custom_role_assignments_count = length(var.role_assignments)
    sessions_executor_assignments = var.enable_default_roles && local.session_pool_id != null ? length(local.valid_role_principals) : 0
    sessionpools_contributor_assignments = var.enable_default_roles && local.session_pool_id != null ? length(local.valid_role_principals) : 0
    session_pool_id_available = local.session_pool_id != null
  } : null
}

# Debug output for troubleshooting role assignments
output "debug_role_principals" {
  description = "Debug information about role principals (sensitive)"
  value = var.enabled && var.enable_default_roles ? {
    provided_principals = var.default_role_principals
    valid_principals = local.valid_role_principals
    session_pool_id = local.session_pool_id
  } : null
  sensitive = true
}
