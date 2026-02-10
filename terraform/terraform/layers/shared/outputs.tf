#### Resource group ##########
output "resource_group_admin" {
  description = "resource_group admin name"
  value       = data.azurerm_resource_group.shared_rg_admin
}

output "resource_group_app" {
  description = "resource_group app name"
  value       = data.azurerm_resource_group.shared_rg_app
}

#### Key vaults ######
output "kv_shared_admin" {
  description = "kv_shared admin name"
  value       = data.azurerm_key_vault.shared_kv_admin
}

output "kv_shared_app" {
  description = "kv_shared app name"
  value       = data.azurerm_key_vault.shared_kv_app
}

output "kv_shared_app_storage_connection_string_secret_id" {
  description = "kv_shared app storage connection string secret id"
  value       = length(data.azurerm_key_vault_secret.storage_connection_string) > 0 ? data.azurerm_key_vault_secret.storage_connection_string[0].versionless_id : null
}

#### Log analytics workspace #######
output "law_shared_admin" {
  description = "law shared admin name"
  value       = data.azurerm_log_analytics_workspace.shared_admin_law
}

output "law_shared_app" {
  description = "law shared admin name"
  value       = data.azurerm_log_analytics_workspace.shared_app_law
}


#### vnets #####
#### vnet admin #####
output "vnet_admin_shared_name_01" {
  description = "vnet shared admin name"
  # value       = data.azurerm_virtual_network.shared_vnet_admin_01
  value = length(data.azurerm_virtual_network.shared_vnet_admin_01) > 0 ? data.azurerm_virtual_network.shared_vnet_admin_01[0] : null
}

output "vnet_admin_shared_id_01" {
  description = "vnet shared admin id"
  value       = length(data.azurerm_virtual_network.shared_vnet_admin_01) > 0 ? data.azurerm_virtual_network.shared_vnet_admin_01[0].id : null
}

#### vnet app_01 (frontend) #####
output "vnet_app_shared_name_01" {
  description = "vnet shared app name"
  # value       = data.azurerm_virtual_network.shared_vnet_app_01
  value = length(data.azurerm_virtual_network.shared_vnet_app_01) > 0 ? data.azurerm_virtual_network.shared_vnet_app_01[0] : null
}

output "vnet_app_shared_id_01" {
  description = "vnet shared app_01 id (frontend vnet id)"
  value       = length(data.azurerm_virtual_network.shared_vnet_app_01) > 0 ? data.azurerm_virtual_network.shared_vnet_app_01[0].id : null
}

#### vnet app_02 (backend) #####
output "vnet_app_shared_name_02" {
  description = "vnet shared app_02 name (backend vnet name)"
  value       = length(data.azurerm_virtual_network.shared_vnet_app_02) > 0 ? data.azurerm_virtual_network.shared_vnet_app_02[0] : null
}

output "vnet_app_shared_id_02" {
  description = "vnet shared app_02 id (backend vnet id)"
  value       = length(data.azurerm_virtual_network.shared_vnet_app_02) > 0 ? data.azurerm_virtual_network.shared_vnet_app_02[0].id : null
}

#### subnets #####
output "subnet_admin_shared_name_01" {
  description = "subnet shared admin name"
  # value       = data.azurerm_subnet.shared_subnet_admin_01[0]
  value = length(data.azurerm_subnet.shared_subnet_admin_01) > 0 ? data.azurerm_subnet.shared_subnet_admin_01[0] : null
}

# Admin Subnet1 ID
output "admin_subnet1_id" {
  description = "Admin Subnet1 resource ID"
  value       = local.shared_subnet_admin_01_id
}

output "subnet_app_shared_name_01" {
  description = "subnet shared app name"
  # value       = data.azurerm_subnet.shared_subnet_app_01[0]
  value = length(data.azurerm_subnet.shared_subnet_app_01) > 0 ? data.azurerm_subnet.shared_subnet_app_01[0] : null
}

output "subnet_app_shared_name_02" {
  description = "subnet shared app name"
  # value       = data.azurerm_subnet.shared_subnet_app_02[0]
  value = length(data.azurerm_subnet.shared_subnet_app_02) > 0 ? data.azurerm_subnet.shared_subnet_app_02[0] : null
}

output "subnet_app_shared_name_03" {
  description = "subnet shared app name"
  # value       = data.azurerm_subnet.shared_subnet_app_03[0]
  value = length(data.azurerm_subnet.shared_subnet_app_03) > 0 ? data.azurerm_subnet.shared_subnet_app_03[0] : null
}

# Frontend subnets IDs
output "frontend_subnet1_id" {
  description = "Frontend Subnet1 resource ID"
  value       = length(data.azurerm_subnet.shared_subnet_app_01) > 0 ? data.azurerm_subnet.shared_subnet_app_01[0].id : null
}

output "frontend_subnet2_id" {
  description = "Frontend Subnet2 resource ID"
  value       = length(data.azurerm_subnet.shared_subnet_app_02) > 0 ? data.azurerm_subnet.shared_subnet_app_02[0].id : null
}

output "frontend_subnet3_id" {
  description = "Frontend Subnet3 resource ID"
  value       = length(data.azurerm_subnet.shared_subnet_app_03) > 0 ? data.azurerm_subnet.shared_subnet_app_03[0].id : null
}

#### subnets app_02 (backend) #####
output "subnet1_app_shared_name_app_02" {
  description = "subnet1 shared app_02 object"
  value       = length(data.azurerm_subnet.shared_subnet1_name_app_02) > 0 ? data.azurerm_subnet.shared_subnet1_name_app_02[0] : null
}
output "subnet2_app_shared_name_app_02" {
  description = "subnet2 shared app_02 object"
  value       = length(data.azurerm_subnet.shared_subnet2_name_app_02) > 0 ? data.azurerm_subnet.shared_subnet2_name_app_02[0] : null
}
output "subnet3_app_shared_name_app_02" {
  description = "subnet3 shared app_02 object"
  value       = length(data.azurerm_subnet.shared_subnet3_name_app_02) > 0 ? data.azurerm_subnet.shared_subnet3_name_app_02[0] : null
}

output "subnet1_app_shared_id_app_02" {
  description = "subnet1 shared app_02 id"
  value       = length(data.azurerm_subnet.shared_subnet1_name_app_02) > 0 ? data.azurerm_subnet.shared_subnet1_name_app_02[0].id : null
}
output "subnet2_app_shared_id_app_02" {
  description = "subnet2 shared app_02 id"
  value       = length(data.azurerm_subnet.shared_subnet2_name_app_02) > 0 ? data.azurerm_subnet.shared_subnet2_name_app_02[0].id : null
}
output "subnet3_app_shared_id_app_02" {
  description = "subnet3 shared app_02 id"
  value       = length(data.azurerm_subnet.shared_subnet3_name_app_02) > 0 ? data.azurerm_subnet.shared_subnet3_name_app_02[0].id : null
}




#### Storage account #########
output "storage_account_shared_app_name_01" {
  description = "storage_account shared app name"
  value       = length(data.azurerm_storage_account.shared_storage_account_app_01) > 0 ? data.azurerm_storage_account.shared_storage_account_app_01[0] : null
}
################################
#### PRIVATE DNS ZONES #########
################################
#### Private DNS Zones - Development Integration ####

#### App Layer Private DNS Zones - Dev Integration
output "dev_app_service_private_dns_zone_id" {
  description = "App Service private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.dev_app_service_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.dev_app_service_private_dns_zone[0].id : null
}

output "dev_signalr_private_dns_zone_id" {
  description = "SignalR Service private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.dev_signalr_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.dev_signalr_private_dns_zone[0].id : null
}

output "dev_storage_blob_private_dns_zone_id" {
  description = "Storage Blob private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.dev_storage_blob_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.dev_storage_blob_private_dns_zone[0].id : null
}

output "dev_storage_table_private_dns_zone_id" {
  description = "Storage Table private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.dev_storage_table_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.dev_storage_table_private_dns_zone[0].id : null
}

output "dev_storage_queue_private_dns_zone_id" {
  description = "Storage Queue private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.dev_storage_queue_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.dev_storage_queue_private_dns_zone[0].id : null
}

output "dev_speech_private_dns_zone_id" {
  description = "Speech Service private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.dev_speech_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.dev_speech_private_dns_zone[0].id : null
}

output "dev_document_intelligence_private_dns_zone_id" {
  description = "Document Intelligence private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.dev_document_intelligence_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.dev_document_intelligence_private_dns_zone[0].id : null
}

output "dev_container_registry_private_dns_zone_id" {
  description = "Container Registry private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.dev_container_registry_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.dev_container_registry_private_dns_zone[0].id : null
}

#############################################
# Consolidated QA Private DNS Zone Outputs  #
#############################################

output "qa_app_private_dns_zone_ids" {
  description = "Map of QA app-layer private DNS zone IDs keyed by zone type"
  value       = var.env == "QA" ? { for k, v in data.azurerm_private_dns_zone.qa_app_dns_zones : k => v.id } : {}
}

output "qa_backend_private_dns_zone_ids" {
  description = "Map of QA backend private DNS zone IDs keyed by zone type"
  value       = var.env == "QA" ? { for k, v in data.azurerm_private_dns_zone.qa_backend_dns_zones : k => v.id } : {}
}

#############################################
# UAT / PROD Private DNS Zone Outputs  #
#############################################

### Backend Layer Private DNS Zones
output "redis_cache_dns_zone_id" {
  description = "Redis Cache private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.redis_cache_dns_zone) > 0 ? data.azurerm_private_dns_zone.redis_cache_dns_zone[0].id : null
}

output "servicebus_dns_zone_id" {
  description = "Service Bus private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.servicebus_dns_zone) > 0 ? data.azurerm_private_dns_zone.servicebus_dns_zone[0].id : null
}

output "cosmosdb_dns_zone_id" {
  description = "CosmosDB private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.cosmosdb_dns_zone) > 0 ? data.azurerm_private_dns_zone.cosmosdb_dns_zone[0].id : null
}

output "cosmosdb_postgresql_dns_zone_id" {
  description = "PostgreSQL private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.cosmosdb_postgresql_dns_zone) > 0 ? data.azurerm_private_dns_zone.cosmosdb_postgresql_dns_zone[0].id : null
}

### App Layer Private DNS Zones
output "app_service_private_dns_zone_id" {
  description = "App Service private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.app_service_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.app_service_private_dns_zone[0].id : null
}

output "signalr_private_dns_zone_id" {
  description = "SignalR Service private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.signalr_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.signalr_private_dns_zone[0].id : null
}

output "storage_blob_private_dns_zone_id" {
  description = "Storage Blob private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.storage_blob_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.storage_blob_private_dns_zone[0].id : null
}

output "storage_table_private_dns_zone_id" {
  description = "Storage Table private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.storage_table_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.storage_table_private_dns_zone[0].id : null
}

output "storage_queue_private_dns_zone_id" {
  description = "Storage Queue private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.storage_queue_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.storage_queue_private_dns_zone[0].id : null
}

output "speech_private_dns_zone_id" {
  description = "Speech Service private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.speech_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.speech_private_dns_zone[0].id : null
}

output "document_intelligence_private_dns_zone_id" {
  description = "Document Intelligence private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.document_intelligence_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.document_intelligence_private_dns_zone[0].id : null
}

output "container_registry_private_dns_zone_id" {
  description = "Container Registry private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.container_registry_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.container_registry_private_dns_zone[0].id : null
}

output "container_app_environment_private_dns_zone_id" {
  description = "Container App Environment private DNS zone ID"
  value       = length(data.azurerm_private_dns_zone.container_app_environment_private_dns_zone) > 0 ? data.azurerm_private_dns_zone.container_app_environment_private_dns_zone[0].id : null
}



// Application Insights outputs (optional - populated when data lookup runs)
output "app_insights_instrumentation_key" {
  value       = try(data.azurerm_application_insights.shared_app_insights[0].instrumentation_key, null)
  description = "Instrumentation key for shared Application Insights (or null if not configured)"
}

output "app_insights_connection_string" {
  value       = try(data.azurerm_application_insights.shared_app_insights[0].connection_string, null)
  description = "Connection string for shared Application Insights (or null if not configured)"
}

output "app_insights_pilot_connection_string" {
  value       = try(data.azurerm_application_insights.shared_app_insights_app_pilot[0].connection_string, null)
  description = "Connection string for App Pilot Application Insights (or null if not configured)"
}

output "app_insights_prod_connection_string" {
  value       = try(data.azurerm_application_insights.shared_app_insights_app_prod[0].connection_string, null)
  description = "Connection string for App Prod Application Insights (or null if not configured)"
}

output "app_insights_resource_id" {
  value       = try(data.azurerm_application_insights.shared_app_insights[0].id, null)
  description = "Resource ID for shared Application Insights (or null if not configured)"
}