locals {
  subnet_id_admin_02 = var.admin_resources && var.subnet2_name != null ? module.vnet_admin_01[0].subnet_ids[var.subnet2_name] : null
  subnet_id_admin_01 = var.admin_resources && var.subnet1_name != null ? module.vnet_admin_01[0].subnet_ids[var.subnet1_name] : null
  nsg_admin_id_01    = var.admin_resources ? module.nsg_admin_01[0].id : null
  enable_telemetry   = false

  # Enable GitHub subnet data source only when env is QA and all required variables are provided
  enable_github_subnet_data = var.env == "QA" && alltrue([
    var.github_subnet_name != null,
    var.github_vnet_name != null,
    var.github_vnet_rg_name != null
  ])

  environment_mapping = {
    Development = "Dev"
    QA          = "QA"
    UAT         = "UAT"
    Prod        = "Prod"
  }
  env = lookup(local.environment_mapping, var.tags.ENVIRONMENT, upper(var.tags.ENVIRONMENT))

  private_dns_zones = {
    redis                 = "privatelink.redis.cache.windows.net"
    servicebus            = "privatelink.servicebus.windows.net"
    cosmosdb              = "privatelink.documents.azure.com"
    cosmosdb_postgresql   = "privatelink.postgres.cosmos.azure.com"
    storage_blob          = "privatelink.blob.core.windows.net"
    storage_queue         = "privatelink.queue.core.windows.net"
    storage_table         = "privatelink.table.core.windows.net"
    app_service           = "privatelink.azurewebsites.net"
    signalr               = "privatelink.service.signalr.net"
    speech                = "privatelink.speech.azure.com"
    openai                = "privatelink.openai.azure.com"
    document_intelligence = "privatelink.cognitiveservices.azure.com"
    container_app         = "privatelink.azurecontainerapps.io"
    container_registry    = "privatelink.azurecr.io"
  }
  private_dns_zone_tags = {
    redis                 = { "hidden-title" = "EYX - ${local.env} - Redis Private DNS Zone" }
    servicebus            = { "hidden-title" = "EYX - ${local.env} - Service Bus Private DNS Zone" }
    cosmosdb              = { "hidden-title" = "EYX - ${local.env} - CosmosDB Private DNS Zone" }
    cosmosdb_postgresql   = { "hidden-title" = "EYX - ${local.env} - PostgreSQL Private DNS Zone" }
    storage_blob          = { "hidden-title" = "EYX - ${local.env} - Storage Blob Private DNS Zone" }
    storage_queue         = { "hidden-title" = "EYX - ${local.env} - Storage Queue Private DNS Zone" }
    storage_table         = { "hidden-title" = "EYX - ${local.env} - Storage Table Private DNS Zone" }
    app_service           = { "hidden-title" = "EYX - ${local.env} - App Service Private DNS Zone" }
    signalr               = { "hidden-title" = "EYX - ${local.env} - SignalR Private DNS Zone" }
    speech                = { "hidden-title" = "EYX - ${local.env} - Speech Private DNS Zone" }
    openai                = { "hidden-title" = "EYX - ${local.env} - OpenAI Private DNS Zone" }
    document_intelligence = { "hidden-title" = "EYX - ${local.env} - Document Intelligence Private DNS Zone" }
    container_app         = { "hidden-title" = "EYX - ${local.env} - Container App Private DNS Zone" }
    container_registry    = { "hidden-title" = "EYX - ${local.env} - Container Registry Private DNS Zone" }
  }

  # Dev Integration DNS Zones Info
  dns_zones_rg_dev = "USEDCXS05HRSG02"
  private_dns_zones_dev = {
    redis                 = "privatelink.redis.cache.windows.net"
    servicebus            = "privatelink.servicebus.windows.net"
    cosmosdb              = "privatelink.documents.azure.com"
    cosmosdb_postgresql   = "privatelink.postgres.cosmos.azure.com"
    storage_blob          = "privatelink.blob.core.windows.net"
    storage_queue         = "privatelink.queue.core.windows.net"
    storage_table         = "privatelink.table.core.windows.net"
    app_service           = "privatelink.azurewebsites.net"
    signalr               = "privatelink.service.signalr.net"
    document_intelligence = "privatelink.cognitiveservices.azure.com"
    # speech                = "privatelink.speech.azure.com" - Not deployed in Dev Integration
    # openai                = "privatelink.openai.azure.com" - Not deployed in Dev Integration
    # container_app         = "privatelink.azurecontainerapps.io" - Not deployed in Dev Integration
    # container_registry    = "privatelink.azurecr.io" - Not deployed in Dev Integration
  }
}