# Network Layer Outputs
# These outputs expose VNet and subnet information for consumption by other layers via terraform_remote_state

####################
# Admin VNet (optional - only when admin_resources = true)
####################
output "vnet_admin_01_id" {
  description = "The ID of the admin VNet"
  value       = var.admin_resources && length(module.vnet_admin_01) > 0 ? module.vnet_admin_01[0].vnet_id : null
}

output "vnet_admin_01_name" {
  description = "The name of the admin VNet"
  value       = var.admin_resources && length(module.vnet_admin_01) > 0 ? module.vnet_admin_01[0].vnet_name : null
}

output "vnet_admin_01_subnet_ids" {
  description = "Map of subnet names to subnet IDs for admin vnet"
  value       = var.admin_resources && length(module.vnet_admin_01) > 0 ? module.vnet_admin_01[0].subnet_ids : {}
}

####################
# Frontend VNet (app_01)
####################
output "vnet_app_01_id" {
  description = "The ID of the frontend VNet (app_01)"
  value       = module.vnet_app_01.vnet_id
}

output "vnet_app_01_name" {
  description = "The name of the frontend VNet (app_01)"
  value       = module.vnet_app_01.vnet_name
}

output "vnet_app_01_subnet_ids" {
  description = "Map of subnet names to subnet IDs for frontend vnet (app_01)"
  value       = module.vnet_app_01.subnet_ids
}

####################
# Backend VNet (app_02)
####################
output "vnet_app_02_id" {
  description = "The ID of the backend VNet (app_02)"
  value       = module.vnet_app_02.vnet_id
}

output "vnet_app_02_name" {
  description = "The name of the backend VNet (app_02)"
  value       = module.vnet_app_02.vnet_name
}

output "vnet_app_02_subnet_ids" {
  description = "Map of subnet names to subnet IDs for backend vnet (app_02)"
  value       = module.vnet_app_02.subnet_ids
}
