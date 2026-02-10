########################
##### shared_data ######
#########################
# Temporary: Keep shared_data module as fallback while other layers are being synced
# TODO: Remove this module block once core/network/admin layers have outputs in their state files
module "shared_data" {
  source                                   = "../shared"
  resource_group_name_admin_dev            = local.resource_group_name_admin_dev
  private_dns_zones_names_app              = local.private_dns_zones_names_app
  resource_group_name_admin                = var.resource_group_name_admin
  resource_group_name_app                  = var.resource_group_name_app
  log_analytics_workspace_app_name         = var.log_analytics_workspace_app_name
  vnet_admin_name_01                       = var.vnet_admin_name_01   # Admin VNET
  subnet_admin_name_01                     = var.subnet_admin_name_01 # Admin Subnet1
  vnet_app_name_01                         = var.vnet_app_name_01     # Frontend VNET
  subnet_app_name_01                       = var.subnet_app_name_01
  subnet_app_name_02                       = var.subnet_app_name_02
  subnet_app_name_03                       = var.subnet_app_name_03
  vnet_app_name_02                         = var.vnet_app_name_02    # Backend VNet
  subnet1_name_app_02                      = var.subnet1_name_app_02 # Backend Subnet1 /27
  subnet2_name_app_02                      = var.subnet2_name_app_02 # Backend Subnet2 /27
  subnet3_name_app_02                      = var.subnet3_name_app_02 # Backend Subnet3 /26
  kv_shared_app                            = var.key_vault_name
  kv_secret_storage_connection_string_name = var.kv_secret_storage_connection_string_name
  app_insights_name                        = var.app_insights_name
  app_insights_app_pilot_name              = var.app_insights_app_pilot_name
  app_insights_app_prod_name               = var.app_insights_app_prod_name
  resource_group_name_app_pilot            = var.resource_group_name_app_pilot
  resource_group_name_app_prod             = var.resource_group_name_app_prod
  env                                      = var.env

  providers = {
    azurerm.dev_integration = azurerm.dev_integration
  }
}

# Azure Container Registry
# Conditionally creates the resource. The resource will be created if the `acr_name` variable is not null.
# If `acr_name` is null, the count will be 0, and the resource will not be created.
module "container_registry" {
  count = var.acr_name != null ? 1 : 0

  source                        = "../../modules/container_registry"
  acr_name                      = var.acr_name
  resource_group_name           = local.resource_group_app_name
  location                      = local.resource_group_app_location
  sku                           = var.acr_sku
  admin_enabled                 = var.acr_admin_enabled
  tags                          = local.merged_tags.container_registry_tags
  log_analytics_workspace_id    = local.law_shared_app_id
  zone_redundancy_enabled       = var.acr_zone_redundancy_enabled
  public_network_access_enabled = var.container_registry_public_network_access_enabled
}

#####################################
#### STORAGE ACCOUNT ################
#####################################
module "storage_account_app_01" {
  count                             = var.deploy_resource ? 1 : 0
  source                            = "../../modules/storage_account"
  name                              = lower(var.storage_account_app_01)
  location                          = local.resource_group_app_location
  resource_group_name               = local.resource_group_app_name
  account_tier                      = var.account_tier_storage_account_app_01
  account_replication_type          = var.account_replication_type_storage_account_app_01
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public_storage_account_app_01
  log_analytics_workspace_id        = local.law_shared_app_id
  diag_resource_name_prefix         = var.env == "QA" ? lower(var.storage_account_app_01) : null
  tags                              = local.merged_tags.storage_account_app_01_tags
  account_infra_encryption_enabled  = var.account_infra_encryption_enabled
  subnet_ids                        = local.storage_virtual_network_subnet_ids
  private_link_endpoint_resource_id = local.storage_private_link_endpoint_resource_id
  public_network_access_enabled     = var.storage_public_network_access_enabled 
  blob_delete_retention_policy_days = var.blob_delete_retention_policy_days
  # Enable malware scanning with Event Grid integration
  function_app_name_app_01               = var.function_app_name_app_01
  enable_malware_scanning                = true # Function App Function must exist before enabling malware scanning with Event Grid
  malware_scan_cap_gb_per_month          = 5000
  enable_sensitive_data_discovery        = true
  malware_scan_exclude_blobs_with_prefix = local.malware_scan_exclude_prefixes_app_01
}

module "storage_account_app_02" {
  count                            = var.deploy_resource ? 1 : 0
  source                           = "../../modules/storage_account"
  name                             = lower(var.storage_account_app_02)
  location                         = local.resource_group_app_location
  resource_group_name              = local.resource_group_app_name
  account_tier                     = var.account_tier_storage_account_app_02
  account_replication_type         = var.account_replication_type_storage_account_app_02
  allow_nested_items_to_be_public  = var.allow_nested_items_to_be_public_storage_account_app_02
  log_analytics_workspace_id       = local.law_shared_app_id
  diag_resource_name_prefix        = var.env == "QA" ? lower(var.storage_account_app_02) : null
  tags                             = local.merged_tags.storage_account_app_02_tags
  account_infra_encryption_enabled = var.account_infra_encryption_enabled
  subnet_ids                       = local.storage_virtual_network_subnet_ids
  blob_delete_retention_policy_days = var.blob_delete_retention_policy_days
}

###################################
# AZURE CONTAINER APP ENVIRONMENT #
###################################

module "container_app_environment" {
  # Conditionally creates the resource. The resource will be created if the `cae_name` variable is not null.
  # If `cae_name` is null, the count will be 0, and the resource will not be created.
  count = var.cae_name != null ? 1 : 0

  source                        = "../../modules/container_app_environment"
  cae_name                      = var.cae_name
  location                      = local.resource_group_app_location
  resource_group_name           = local.resource_group_app_name
  log_analytics_workspace_id    = local.law_shared_app_id
  workload_profile_enabled      = var.cae_workload_profile_enabled
  workload_profiles             = var.cae_workload_profiles
  cae_infrastructure_subnet_id  = local.subnet3_app_shared_id_app_02
  tags                          = local.merged_tags.container_app_environment_tags
  public_network_access_enabled = var.public_network_access_enabled
}

#######################
# AZURE CONTAINER APP #
#######################

module "container_app" {
  # Controls the creation of the resource. The resource is only created if both the `container_app_name` and `cae_name` variables are defined (not null). Otherwise, no instance of this resource is provisioned.
  count = var.container_app_name != null && var.cae_name != null ? 1 : 0 # Only create if app name and CAE name are provided

  source              = "../../modules/container_app"
  container_app_name  = lower(var.container_app_name)
  location            = local.resource_group_app_location
  resource_group_name = local.resource_group_app_name
  tags                = local.merged_tags.container_app_tags
  # The container_app_environment module is created with `count = var.cae_name != null ? 1 : 0`.
  # When a module is instantiated with `count`, its outputs are exposed as a list
  # of instances (even when count == 1). Previously we indexed [0] directly which
  # fails if CAE isn't created (count = 0). Use a safe conditional expression so
  # Terraform evaluates to `null` when no CAE exists instead of causing an error.
  # This ensures the module can be included in plans even when CAE is not present.
  container_app_environment_id = length(module.container_app_environment) > 0 ? module.container_app_environment[0].id : null
  container_name               = var.container_name
  container_image              = var.container_image
  container_cpu                = var.container_cpu
  container_memory             = var.container_memory
}

#######################################
# AZURE CONTAINER APP SESSION POOL ####
#######################################

module "container_app_session_pool" {
  source = "../../modules/container_app_session_pool"

  # Create pool only when enabled and CAE exists
  enabled                 = var.session_pool_enabled
  session_pool_name       = var.session_pool_name
  max_concurrent_sessions = var.session_pool_max_concurrent_sessions
  ready_session_instances = var.session_pool_ready_instances
  cooldown_period_seconds = var.session_pool_cooldown_period_seconds
  target_port             = var.session_pool_target_port
  network_status          = var.session_pool_network_status
  container_type          = var.session_pool_container_type

  # Container configuration
  container_name    = var.session_pool_container_name
  container_image   = var.session_pool_container_image
  container_cpu     = var.session_pool_container_cpu
  container_memory  = var.session_pool_container_memory
  container_command = var.session_pool_container_command
  container_args    = var.session_pool_container_args

  # Infrastructure
  location                     = local.resource_group_app_location
  resource_group_name          = local.resource_group_app_name
  container_app_environment_id = length(module.container_app_environment) > 0 ? module.container_app_environment[0].id : null

  # Registry authentication (optional) - Temporarily disabled due to ARM template complexity
  # registry_server              = var.session_pool_registry_server
  # registry_username            = var.session_pool_registry_username
  # registry_password_secret     = var.session_pool_registry_password_secret

  # Environment and secrets (optional) - Temporarily disabled due to ARM template complexity
  # environment_variables        = var.session_pool_environment_variables
  # secrets                      = var.session_pool_secrets

  # Observability
  tags                       = local.merged_tags.container_app_tags
  log_analytics_workspace_id = local.law_shared_app_id

  # Role assignments
  role_assignments     = var.session_pool_role_assignments
  enable_default_roles = var.session_pool_enable_default_roles
  default_role_principals = concat(
    var.session_pool_default_role_principals,
    local.final_app_service_managed_identities_for_session_pool
  )

  depends_on = [
    module.container_app_environment,
    module.app_service_windows_ui,
    module.app_service_windows_web_api,
    module.app_service_windows_notice_api,
    module.app_service_windows_kernel_memory
  ]
}

##################################
# AZURE CONGITIVE SPEECH ACCOUNT #
##################################

module "speech_account" {
  # Conditionally creates the resource if a speech account name is provided.
  # If var.speech_account_name is not null, one instance of this resource will be created.
  # Otherwise, if var.speech_account_name is null, no instances will be created.
  count                       = var.speech_account_name != null ? 1 : 0
  source                      = "../../modules/cognitive_speech_account"
  speech_account_name         = var.speech_account_name
  custom_subdomain_name       = lower(var.speech_service_custom_subdomain_name)
  resource_group_name         = local.resource_group_app_name
  location                    = local.resource_group_app_location
  sku_name                    = var.speech_sku_name
  tags                        = local.merged_tags.speech_account_tags
  log_analytics_workspace_id  = local.law_shared_app_id
  network_acls_default_action = "Allow" # Override the module's default of "Deny"
  network_acls_ip_rules       = []
}

#######################################
# AZURE DOCUMENT INTELLIGENCE ACCOUNT #
#######################################

module "document_intelligence_account" {

  # Conditionally creates the resource. The resource will be created if the `document_intelligence_account_name` variable is not null.
  # If `document_intelligence_account_name` is null, the count will be 0, and the resource will not be created.
  count                              = var.document_intelligence_account_name != null ? 1 : 0
  source                             = "../../modules/document_intelligence_account"
  document_intelligence_account_name = var.document_intelligence_account_name
  custom_subdomain_name              = lower(var.document_intelligence_custom_subdomain_name)
  resource_group_name                = local.resource_group_app_name
  location                           = local.resource_group_app_location
  sku_name                           = var.document_intelligence_sku_name
  tags                               = local.merged_tags.document_intelligence_account_tags
  log_analytics_workspace_id         = local.law_shared_app_id
  network_acls_default_action        = "Allow" # Override the module's default of "Deny"
  network_acls_ip_rules              = []
}

#########################
#### SERVICE PLANS ######
#########################
### app_service_plan_ui ###
module "app_service_plan_ui" {
  source                     = "../../modules/app_service_plan"
  name                       = var.app_service_plan_name_app_01
  location                   = local.resource_group_app_location
  resource_group_name        = local.resource_group_app_name
  os_type                    = var.os_type_service_plan_app_01
  sku_name                   = var.sku_name_service_plan_app_01
  tags                       = local.merged_tags.app_service_plan_ui_tags
  log_analytics_workspace_id = local.law_shared_app_id
}

### app_service_plan_apis ###
module "app_service_plan_apis" {
  source                     = "../../modules/app_service_plan"
  name                       = var.app_service_plan_name_app_02
  location                   = local.resource_group_app_location
  resource_group_name        = local.resource_group_app_name
  os_type                    = var.os_type_service_plan_app_02
  sku_name                   = var.sku_name_service_plan_app_02
  tags                       = local.merged_tags.app_service_plan_apis_tags
  log_analytics_workspace_id = local.law_shared_app_id

  # Autoscaling configuration
  enable_autoscale = var.enable_autoscale_app_02
}

### app_service_plan_functions ###
module "app_service_plan_functions" {
  source                     = "../../modules/app_service_plan"
  name                       = var.app_service_plan_name_app_03
  location                   = local.resource_group_app_location
  resource_group_name        = local.resource_group_app_name
  os_type                    = var.os_type_service_plan_app_03
  sku_name                   = var.sku_name_service_plan_app_03
  tags                       = local.merged_tags.app_service_plan_functions_tags
  log_analytics_workspace_id = local.law_shared_app_id
}

######################
#### WEB APPS ########
######################

# UI Web App
module "app_service_windows_ui" {
  source                                   = "../../modules/app_service_windows"
  name                                     = var.web_app_name_app_01
  location                                 = local.resource_group_app_location
  resource_group_name                      = local.resource_group_app_name
  service_plan_id                          = module.app_service_plan_ui.id
  https_only                               = var.https_only
  virtual_network_subnet_id                = local.frontend_subnet2_id
  managed_identities                       = var.managed_identities
  ftp_publish_basic_authentication_enabled = local.ftp_publish_basic_authentication_enabled
  scm_publish_basic_authentication_enabled = local.scm_publish_basic_authentication_enabled

  # App Service diagnostic settings
  diagnostic_settings = {
    workspace_resource_id = local.law_shared_app_id
    # Use existing name format for environments that already have diagnostic settings deployed
    # UAT and PROD use "diag-{resource_name}" format, QA uses "{resource_name}-diagnostic" format
    name              = contains(["UAT", "PROD"], var.env) ? "diag-${var.web_app_name_app_01}" : (var.env == "QA" ? "${var.web_app_name_app_01}-diagnostic" : null)
    log_groups        = var.diagnostic_settings_log_groups
    metric_categories = var.diagnostic_settings_metric_categories
  }

  # App Service site configuration
  site_config = {
    minimum_tls_version = var.minimum_tls_version
  }

  # Configure IP restrictions with Front Door support
  scm_ip_restriction_default_action = "Deny"
  scm_ip_restriction = var.x_azure_fdid != null ? {
    IN_ALLOW_FRONTDOOR_EYX = {
      name        = "IN_ALLOW_FRONTDOOR_EYX"
      description = "Allow Azure Front Door Public Inbound"
      service_tag = "AzureFrontDoor.Backend"
      action      = "Allow"
      priority    = 100
      headers = {
        x_azure_fdid      = [var.x_azure_fdid]
        x_fd_health_probe = ["1"]
      }
    }
  } : {}

  # Configure .NET application stack
  application_stack = {
    dotnet_stack = {
      current_stack               = var.web_app_current_stack_app_01
      dotnet_version              = var.web_app_dotnet_version_app_01
      use_dotnet_isolated_runtime = true
    }
  }

  # Configure CORS settings
  cors = var.app_service_windows_ui_cors

  tags                          = local.merged_tags.app_service_ui_tags
  public_network_access_enabled = lower(var.env) == "qa"
  app_settings                  = merge(local.general_app_settings, var.app_service_windows_ui_app_settings)
  sticky_settings               = local.app_service_sticky_settings
}

# Web API App Service
module "app_service_windows_web_api" {
  source                                   = "../../modules/app_service_windows"
  name                                     = var.web_app_name_app_02
  location                                 = local.resource_group_app_location
  resource_group_name                      = local.resource_group_app_name
  service_plan_id                          = module.app_service_plan_apis.id
  https_only                               = var.https_only
  virtual_network_subnet_id                = local.frontend_subnet2_id
  managed_identities                       = var.managed_identities
  ftp_publish_basic_authentication_enabled = local.ftp_publish_basic_authentication_enabled
  scm_publish_basic_authentication_enabled = local.scm_publish_basic_authentication_enabled

  # App Service diagnostic settings
  diagnostic_settings = {
    workspace_resource_id = local.law_shared_app_id
    # Use existing name format for environments that already have diagnostic settings deployed
    # UAT and PROD use "diag-{resource_name}" format, QA uses "{resource_name}-diagnostic" format
    name              = contains(["UAT", "PROD"], var.env) ? "diag-${var.web_app_name_app_02}" : (var.env == "QA" ? "${var.web_app_name_app_02}-diagnostic" : null)
    log_groups        = var.diagnostic_settings_log_groups
    metric_categories = var.diagnostic_settings_metric_categories
  }

  # Basic site configuration
  site_config = {
    minimum_tls_version = var.minimum_tls_version
  }

  # Configure .NET application stack
  application_stack = {
    dotnet_stack = {
      current_stack  = var.web_app_current_stack_app_02
      dotnet_version = var.web_app_dotnet_version_app_02
    }
  }

  # Configure CORS settings
  cors = var.app_service_windows_api_cors

  tags                          = local.merged_tags.app_service_api_tags
  public_network_access_enabled = false
  app_settings                  = merge(local.general_app_settings, local.general_app_settings_optional, var.app_service_windows_api_app_settings)
  sticky_settings               = local.app_service_sticky_settings
}

# Notice API App Service
module "app_service_windows_notice_api" {
  source                                   = "../../modules/app_service_windows"
  name                                     = var.web_app_name_app_03
  location                                 = local.resource_group_app_location
  resource_group_name                      = local.resource_group_app_name
  service_plan_id                          = module.app_service_plan_apis.id
  https_only                               = var.https_only
  virtual_network_subnet_id                = local.frontend_subnet2_id
  managed_identities                       = var.managed_identities
  ftp_publish_basic_authentication_enabled = local.ftp_publish_basic_authentication_enabled
  scm_publish_basic_authentication_enabled = local.scm_publish_basic_authentication_enabled

  # App Service diagnostic settings
  diagnostic_settings = {
    workspace_resource_id = local.law_shared_app_id
    # Use existing name format for environments that already have diagnostic settings deployed
    # UAT and PROD use "diag-{resource_name}" format, QA uses "{resource_name}-diagnostic" format
    name              = contains(["UAT", "PROD"], var.env) ? "diag-${var.web_app_name_app_03}" : (var.env == "QA" ? "${var.web_app_name_app_03}-diagnostic" : null)
    log_groups        = var.diagnostic_settings_log_groups
    metric_categories = var.diagnostic_settings_metric_categories
  }

  # Basic site configuration
  site_config = {
    minimum_tls_version = var.minimum_tls_version
  }

  # Configure .NET application stack
  application_stack = {
    dotnet_stack = {
      current_stack  = var.web_app_current_stack_app_03
      dotnet_version = var.web_app_dotnet_version_app_03
    }
  }

  tags                          = local.merged_tags.app_service_noticeapi_tags
  public_network_access_enabled = false
  app_settings                  = merge(local.general_app_settings, local.general_app_settings_optional, var.app_service_windows_notice_api_app_settings)
  sticky_settings               = local.app_service_sticky_settings
}

# Kernel Memory API App Service  
module "app_service_windows_kernel_memory" {
  source                                   = "../../modules/app_service_windows"
  name                                     = var.web_app_name_app_04
  location                                 = local.resource_group_app_location
  resource_group_name                      = local.resource_group_app_name
  service_plan_id                          = module.app_service_plan_apis.id
  https_only                               = var.https_only
  virtual_network_subnet_id                = local.frontend_subnet2_id
  managed_identities                       = var.managed_identities
  ftp_publish_basic_authentication_enabled = local.ftp_publish_basic_authentication_enabled
  scm_publish_basic_authentication_enabled = local.scm_publish_basic_authentication_enabled

  # App Service diagnostic settings
  diagnostic_settings = {
    workspace_resource_id = local.law_shared_app_id
    # Use existing name format for environments that already have diagnostic settings deployed
    # UAT and PROD use "diag-{resource_name}" format, QA uses "{resource_name}-diagnostic" format
    name              = contains(["UAT", "PROD"], var.env) ? "diag-${var.web_app_name_app_04}" : (var.env == "QA" ? "${var.web_app_name_app_04}-diagnostic" : null)
    log_groups        = var.diagnostic_settings_log_groups
    metric_categories = var.diagnostic_settings_metric_categories
  }

  # Basic site configuration
  site_config = {
    minimum_tls_version = var.minimum_tls_version
  }

  # Configure .NET application stack
  application_stack = {
    dotnet_stack = {
      current_stack  = var.web_app_current_stack_app_04
      dotnet_version = var.web_app_dotnet_version_app_04
    }
  }

  tags                          = local.merged_tags.app_service_kernelapi_tags
  public_network_access_enabled = false
  app_settings                  = merge(local.general_app_settings, local.general_app_settings_optional, var.app_service_windows_kernel_memory_app_settings)
  sticky_settings               = local.app_service_sticky_settings
}

#####################################
#### FUNCTION APP ########
#####################################
module "function_app_01" {
  source                                         = "../../modules/function_apps_windows"
  name                                           = var.function_app_name_app_01
  location                                       = local.resource_group_app_location
  resource_group_name                            = local.resource_group_app_name
  service_plan_id                                = module.app_service_plan_functions.id
  storage_key_vault_secret_id                    = local.function_storage_key_vault_secret_id
  virtual_network_subnet_id                      = local.frontend_subnet2_id
  identity_type                                  = "SystemAssigned"
  client_certificate_mode                        = "Required"
  application_insights_connection_string         = local.app_insights.connection_string.current
  application_insights_key                       = local.app_insights.instrumentation_key
  ftp_publish_basic_authentication_enabled       = var.function_ftp_publish_basic_authentication_enabled
  public_network_access_enabled                  = var.function_public_network_access_enabled
  webdeploy_publish_basic_authentication_enabled = true
  ip_restriction_default_action                  = var.function_ip_restriction_default_action
  scm_ip_restriction_default_action              = var.function_scm_ip_restriction_default_action
  ip_restriction = {
    Allow-EventGrid = {
      action      = "Allow"
      priority    = 100
      service_tag = "AzureEventGrid"
    }
  }
  sticky_settings = local.app_service_sticky_settings

  # Function App diagnostic settings
  diagnostic_settings = {
    workspace_resource_id = local.law_shared_app_id
    # Use existing name format for environments that already have diagnostic settings deployed
    # UAT and PROD use "diag-{resource_name}" format, QA uses "{resource_name}-diagnostic" format
    name              = contains(["UAT", "PROD"], var.env) ? "diag-${var.function_app_name_app_01}" : "${var.function_app_name_app_01}-diagnostic"
    log_groups        = var.diagnostic_settings_log_groups
    metric_categories = var.diagnostic_settings_metric_categories
  }

  # Function App site configuration
  site_config = {
    stack = {
      dotnet_version = var.dotnet_version_funct_app_01
    }
    always_on  = true
    ftps_state = "FtpsOnly"
  }

  app_settings = merge(local.general_function_app_settings, var.function_app_01_app_settings)
  tags         = local.merged_tags.function_app_01_tags
}


####################################
#### SIGNALR #######################
####################################
module "signalr_service" {
  source                     = "../../modules/signalr"
  name                       = var.signalr_name_app_01
  location                   = local.resource_group_app_location
  resource_group_name        = local.resource_group_app_name
  sku_name                   = var.sku_name_app_01
  sku_capacity               = var.sku_capacity_app_01
  tags                       = local.merged_tags.signalr_tags
  log_analytics_workspace_id = local.law_shared_app_id
  enable_autoscale           = var.signalr_enable_autoscale

  # Cross-resource autoscale sourced from App Service Plan metrics (centralized in locals.tf)
  autoscale_external_metric_enabled     = local.signalr_autoscale.external_metric_enabled
  autoscale_external_metric_resource_id = module.app_service_plan_apis.id
  autoscale_external_metric_namespace   = local.signalr_autoscale.external_metric_namespace
  autoscale_metric_name                 = local.signalr_autoscale.metric_name
  autoscale_min_capacity                = local.signalr_autoscale.min_capacity
  autoscale_default_capacity            = local.signalr_autoscale.default_capacity
  autoscale_max_capacity                = local.signalr_autoscale.max_capacity
  autoscale_scale_out_threshold         = local.signalr_autoscale.scale_out_threshold
  autoscale_scale_in_threshold          = local.signalr_autoscale.scale_in_threshold
  autoscale_scale_out_change_count      = local.signalr_autoscale.scale_out_change_count
  autoscale_scale_in_change_count       = local.signalr_autoscale.scale_in_change_count
  autoscale_scale_out_cooldown_minutes  = local.signalr_autoscale.scale_out_cooldown_minutes
  autoscale_scale_in_cooldown_minutes   = local.signalr_autoscale.scale_in_cooldown_minutes
  autoscale_scale_out_statistic         = local.signalr_autoscale.scale_out_statistic
  autoscale_scale_in_statistic          = local.signalr_autoscale.scale_in_statistic

  cors = local.signalr_cors
}

###########################
#### PRIVATE ENDPOINTS ####
###########################
module "app_private_endpoints" {
  source              = "../../modules/private_endpoint"
  for_each            = local.app_private_endpoints
  name                = each.value.name
  location            = local.resource_group_app_location
  resource_group_name = local.resource_group_app_name
  subnet_id           = each.value.subnet_id
  connection_name     = each.value.connection_name
  resource_id         = each.value.resource_id
  subresource_names   = each.value.subresource_names
  private_dns_zone_id = each.value.private_dns_zone_id
  tags                = each.value.tags
}

