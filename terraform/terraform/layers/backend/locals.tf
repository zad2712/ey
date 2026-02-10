locals {
  # Dev Integration DNS Zones Info
  # resource_group_name_admin_dev = "USEDCXS05HRSG02"
  resource_group_name_admin_dev = contains(["QA", "UAT", "PROD"], var.env) ? null : "USEDCXS05HRSG02"

  # TAGS
  ## Base tags per main environment
  environment_base_tags = {
    DEV = {
      DEPLOYMENT_ID = "CXS05H"
      ENGAGEMENT_ID = "I-69197406"
      OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
      ENVIRONMENT   = "Development"
    }
    QA = {
      DEPLOYMENT_ID = "CXS05H"
      ENGAGEMENT_ID = "I-68403024"
      OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
      ENVIRONMENT   = "QA"
    }
    UAT = {
      DEPLOYMENT_ID = "EYXU01"
      ENGAGEMENT_ID = "I-69197406"
      OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
      ENVIRONMENT   = "UAT"
    }
    PROD = {
      DEPLOYMENT_ID = "EYPU01"
      ENGAGEMENT_ID = "I-69197406"
      OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
      ENVIRONMENT   = "PROD"
    }
  }

  general_tags = local.environment_base_tags[var.env]

  resources_specific_tags = {
    redis_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Redis Cache",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Redis Cache"
    }
    servicebus_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Service Bus",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Service Bus"
    }
    cosmosdb_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Cosmos DB NoSQL",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Cosmos DB NoSQL"
    }
    cosmosdb_postgresql_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - PostgreSQL",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - PostgreSQL"
    }
    # Used on QA only - TODO: Fix them to match QA.
    storage_account_admin_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Storage Account Admin",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Storage Account Admin"
    }
    storage_account_app_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Storage Account App",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Storage Account App"
    }
  }

  # Dynamic merging - automatically merges general_tags with each resource-specific tag set
  merged_tags = {
    for key, resource_tags in local.resources_specific_tags :
    key => merge(local.general_tags, resource_tags)
  }

  # Private endpoint specific tags (separate from resource tags)
  private_endpoint_specific_tags = {
    service_bus_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Service Bus Private Endpoint",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Service Bus Private Endpoint"
    }
    redis_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Redis Private Endpoint",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Redis Private Endpoint"
    }
    cosmosdb_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - CosmosDB Private Endpoint",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - CosmosDB Private Endpoint"
    }
    cosmosdb_postgresql_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - PostgreSQL Private Endpoint",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - PostgreSQL Private Endpoint"
    }
  }

  # Dynamic merging for private endpoints
  merged_private_endpoint_tags = {
    for key, pep_tags in local.private_endpoint_specific_tags :
    key => merge(local.general_tags, pep_tags)
  }

  private_dns_zones_names_backend = {
    redis      = "privatelink.redis.cache.windows.net"
    servicebus = "privatelink.servicebus.windows.net"
    cosmosdb   = "privatelink.documents.azure.com"
    postgresql = "privatelink.postgres.cosmos.azure.com"
  }

  backend_private_endpoints = {
    service_bus = {
      name                = var.service_bus_pep_name
      subnet_id           = module.shared_data.subnet1_app_shared_id_app_02
      connection_name     = var.service_bus_pep_name
      resource_id         = module.service_bus[0].id
      subresource_names   = ["namespace"]
      private_dns_zone_id = var.env == "DEV" ? module.shared_data.dev_servicebus_dns_zone_id : (var.env == "QA" ? module.shared_data.qa_servicebus_dns_zone_id : module.shared_data.servicebus_dns_zone_id)
      tags                = local.merged_private_endpoint_tags.service_bus_pep
    }

    redis = {
      name                = var.redis_cache_pep_name
      subnet_id           = module.shared_data.subnet1_app_shared_id_app_02
      connection_name     = var.redis_cache_pep_name
      resource_id         = module.redis_cache.id
      subresource_names   = ["redisCache"]
      private_dns_zone_id = var.env == "DEV" ? module.shared_data.dev_redis_cache_dns_zone_id : (var.env == "QA" ? module.shared_data.qa_redis_cache_dns_zone_id : module.shared_data.redis_cache_dns_zone_id)
      tags                = local.merged_private_endpoint_tags.redis_pep
    }

    cosmosdb = {
      name                = var.cosmosdb_pep_name
      subnet_id           = module.shared_data.subnet1_app_shared_id_app_02
      connection_name     = var.cosmosdb_pep_name
      resource_id         = module.cosmosdb[0].cosmosdb_account_id
      subresource_names   = ["Sql"]
      private_dns_zone_id = var.env == "DEV" ? module.shared_data.dev_cosmosdb_dns_zone_id : (var.env == "QA" ? module.shared_data.qa_cosmosdb_dns_zone_id : module.shared_data.cosmosdb_dns_zone_id)
      tags                = local.merged_private_endpoint_tags.cosmosdb_pep
    }

    cosmosdb_postgresql = {
      name                = var.cosmosdb_postgresql_pep_name
      subnet_id           = module.shared_data.subnet1_app_shared_id_app_02
      connection_name     = var.cosmosdb_postgresql_pep_name
      resource_id         = module.cosmosdb_postgresql[0].id
      subresource_names   = ["coordinator"]
      private_dns_zone_id = var.env == "DEV" ? module.shared_data.dev_cosmosdb_postgresql_dns_zone_id : (var.env == "QA" ? module.shared_data.qa_cosmosdb_postgresql_dns_zone_id : module.shared_data.cosmosdb_postgresql_dns_zone_id)
      tags                = local.merged_private_endpoint_tags.cosmosdb_postgresql_pep
    }
  }
}