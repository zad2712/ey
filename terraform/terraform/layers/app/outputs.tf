#######################################
# CONTAINER APP SESSION POOL OUTPUTS #
#######################################

output "session_pool_id" {
  description = "Resource ID of the Container App session pool"
  value       = var.session_pool_enabled ? module.container_app_session_pool.session_pool_id : null
}

output "session_pool_name" {
  description = "Name of the Container App session pool"
  value       = var.session_pool_enabled ? module.container_app_session_pool.session_pool_name : null
}

output "session_pool_management_endpoint" {
  description = "Pool management endpoint for session pool API operations"
  value       = var.session_pool_enabled ? module.container_app_session_pool.pool_management_endpoint : null
  sensitive   = true
}

output "session_pool_location" {
  description = "Location of the session pool"
  value       = var.session_pool_enabled ? module.container_app_session_pool.session_pool_location : null
}

output "session_pool_max_concurrent_sessions" {
  description = "Maximum number of concurrent sessions configured"
  value       = var.session_pool_enabled ? module.container_app_session_pool.max_concurrent_sessions : null
}

output "session_pool_ready_instances" {
  description = "Target number of ready session instances"
  value       = var.session_pool_enabled ? module.container_app_session_pool.ready_session_instances : null
}

output "session_pool_container_type" {
  description = "Container type configuration of the session pool"
  value       = var.session_pool_enabled ? module.container_app_session_pool.container_type : null
}

output "session_pool_network_status" {
  description = "Network status configuration of the session pool"
  value       = var.session_pool_enabled ? module.container_app_session_pool.network_status : null
}

#####################################
# RBAC ROLE ASSIGNMENT OUTPUTS     #
#####################################

output "session_pool_sessions_executor_roles" {
  description = "Container Apps Sessions Executor role assignments for the session pool"
  value       = var.session_pool_enabled ? module.container_app_session_pool.sessions_executor_role_assignments : null
}

output "session_pool_contributor_roles" {
  description = "Container Apps SessionPools Contributor role assignments for the session pool"
  value       = var.session_pool_enabled ? module.container_app_session_pool.sessionpools_contributor_role_assignments : null
}

output "session_pool_custom_roles" {
  description = "Custom role assignments for the session pool"
  value       = var.session_pool_enabled ? module.container_app_session_pool.custom_role_assignments : null
  sensitive   = true
}

output "session_pool_role_summary" {
  description = "Summary of all role assignments for the session pool"
  value       = var.session_pool_enabled ? module.container_app_session_pool.role_assignment_summary : null
  sensitive   = true
}

#######################################
# DEBUG OUTPUTS FOR TROUBLESHOOTING  #
#######################################

output "debug_app_service_managed_identity_principal_ids" {
  description = "Debug: Map of app service names to principal IDs"
  value       = local.app_service_managed_identity_principal_ids
  sensitive   = true
}

output "debug_app_service_managed_identities_for_session_pool" {
  description = "Debug: App service managed identities formatted for session pool role assignments"
  value       = local.final_app_service_managed_identities_for_session_pool
  sensitive   = true
}

output "debug_session_pool_variables" {
  description = "Debug: Session pool configuration variables"
  value = var.session_pool_enabled ? {
    session_pool_enabled                        = var.session_pool_enabled
    session_pool_enable_default_roles           = var.session_pool_enable_default_roles
    session_pool_app_service_managed_identities = var.session_pool_app_service_managed_identities
    deploy_resource                             = var.deploy_resource
    app_service_names = {
      web_app_name_app_01 = var.web_app_name_app_01
      web_app_name_app_02 = var.web_app_name_app_02
      web_app_name_app_03 = var.web_app_name_app_03
      web_app_name_app_04 = var.web_app_name_app_04
    }
    all_app_service_managed_identities = local.all_app_service_managed_identities
    combined_app_service_principals    = local.combined_app_service_principals
    pre_deduplication_principals       = local.app_service_managed_identities_for_session_pool
    final_formatted_principals         = local.final_app_service_managed_identities_for_session_pool
  } : null
  sensitive = true
}