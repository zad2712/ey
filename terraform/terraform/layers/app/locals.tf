locals {
  subscription_id = data.azurerm_client_config.current.subscription_id

  ##############################################
  # Remote State Helper References with Fallbacks
  # Uses terraform_remote_state when available, falls back to shared_data module
  # TODO: Remove fallback logic once all layers (core/network/admin) have outputs in state
  ##############################################

  # Core Layer Outputs - with shared_data fallback
  resource_group_app_name = (
    length(data.terraform_remote_state.core) > 0 &&
    try(data.terraform_remote_state.core[0].outputs.resource_group_name, null) != null
  ) ? data.terraform_remote_state.core[0].outputs.resource_group_name : module.shared_data.resource_group_app[0].name

  resource_group_app_location = (
    length(data.terraform_remote_state.core) > 0 &&
    try(data.terraform_remote_state.core[0].outputs.resource_group_location, null) != null
  ) ? data.terraform_remote_state.core[0].outputs.resource_group_location : module.shared_data.resource_group_app[0].location

  resource_group_app_id = (
    length(data.terraform_remote_state.core) > 0 &&
    try(data.terraform_remote_state.core[0].outputs.resource_group_id, null) != null
  ) ? data.terraform_remote_state.core[0].outputs.resource_group_id : module.shared_data.resource_group_app[0].id

  law_shared_app_id = (
    length(data.terraform_remote_state.core) > 0 &&
    try(data.terraform_remote_state.core[0].outputs.log_analytics_workspace_id, null) != null
  ) ? data.terraform_remote_state.core[0].outputs.log_analytics_workspace_id : module.shared_data.law_shared_app[0].id

  law_shared_app_name = (
    length(data.terraform_remote_state.core) > 0 &&
    try(data.terraform_remote_state.core[0].outputs.log_analytics_workspace_name, null) != null
  ) ? data.terraform_remote_state.core[0].outputs.log_analytics_workspace_name : module.shared_data.law_shared_app[0].name

  kv_shared_app_name = (
    length(data.terraform_remote_state.core) > 0 &&
    try(data.terraform_remote_state.core[0].outputs.key_vault_name, null) != null
  ) ? data.terraform_remote_state.core[0].outputs.key_vault_name : module.shared_data.kv_shared_app[0].name

  kv_shared_app_id = (
    length(data.terraform_remote_state.core) > 0 &&
    try(data.terraform_remote_state.core[0].outputs.key_vault_id, null) != null
  ) ? data.terraform_remote_state.core[0].outputs.key_vault_id : module.shared_data.kv_shared_app[0].id

  kv_shared_app_uri = (
    length(data.terraform_remote_state.core) > 0 &&
    try(data.terraform_remote_state.core[0].outputs.key_vault_uri, null) != null
  ) ? data.terraform_remote_state.core[0].outputs.key_vault_uri : module.shared_data.kv_shared_app[0].vault_uri

  kv_shared_app_storage_connection_string_secret_id = (
    length(data.terraform_remote_state.core) > 0 &&
    try(data.terraform_remote_state.core[0].outputs.key_vault_secrets_resource_ids["FuncAppStorageConnectionString"], null) != null
  ) ? data.terraform_remote_state.core[0].outputs.key_vault_secrets_resource_ids["FuncAppStorageConnectionString"] : module.shared_data.kv_shared_app_storage_connection_string_secret_id

  app_insights_instrumentation_key = (
    length(data.terraform_remote_state.core) > 0 &&
    try(data.terraform_remote_state.core[0].outputs.app_insights_instrumentation_key, null) != null
  ) ? data.terraform_remote_state.core[0].outputs.app_insights_instrumentation_key : module.shared_data.app_insights_instrumentation_key

  app_insights_connection_string = (
    length(data.terraform_remote_state.core) > 0 &&
    try(data.terraform_remote_state.core[0].outputs.app_insights_connection_string, null) != null
  ) ? data.terraform_remote_state.core[0].outputs.app_insights_connection_string : module.shared_data.app_insights_connection_string

  # Pilot and Prod App Insights are only available from shared_data (not in remote state)
  app_insights_pilot_connection_string = module.shared_data.app_insights_pilot_connection_string
  app_insights_prod_connection_string  = module.shared_data.app_insights_prod_connection_string

  app_insights_resource_id = (
    length(data.terraform_remote_state.core) > 0 &&
    try(data.terraform_remote_state.core[0].outputs.app_insights_id, null) != null
  ) ? data.terraform_remote_state.core[0].outputs.app_insights_id : module.shared_data.app_insights_resource_id

  # Network Layer Outputs - Frontend VNet (app_01) - with shared_data fallback
  vnet_app_01_subnet_ids = (
    length(data.terraform_remote_state.network) > 0 &&
    try(data.terraform_remote_state.network[0].outputs.vnet_app_01_subnet_ids, null) != null
  ) ? data.terraform_remote_state.network[0].outputs.vnet_app_01_subnet_ids : {}

  frontend_subnet1_id = (
    length(local.vnet_app_01_subnet_ids) > 0 &&
    try(local.vnet_app_01_subnet_ids[var.subnet_app_name_01], null) != null
  ) ? local.vnet_app_01_subnet_ids[var.subnet_app_name_01] : module.shared_data.subnet_app_shared_name_01.id

  frontend_subnet2_id = (
    length(local.vnet_app_01_subnet_ids) > 0 &&
    try(local.vnet_app_01_subnet_ids[var.subnet_app_name_02], null) != null
  ) ? local.vnet_app_01_subnet_ids[var.subnet_app_name_02] : module.shared_data.subnet_app_shared_name_02.id

  frontend_subnet3_id = (
    length(local.vnet_app_01_subnet_ids) > 0 &&
    try(local.vnet_app_01_subnet_ids[var.subnet_app_name_03], null) != null
  ) ? local.vnet_app_01_subnet_ids[var.subnet_app_name_03] : module.shared_data.subnet_app_shared_name_03.id

  # Network Layer Outputs - Backend VNet (app_02) - with shared_data fallback
  vnet_app_02_subnet_ids = (
    length(data.terraform_remote_state.network) > 0 &&
    try(data.terraform_remote_state.network[0].outputs.vnet_app_02_subnet_ids, null) != null
  ) ? data.terraform_remote_state.network[0].outputs.vnet_app_02_subnet_ids : {}

  subnet1_app_shared_id_app_02 = (
    length(local.vnet_app_02_subnet_ids) > 0 &&
    try(local.vnet_app_02_subnet_ids[var.subnet1_name_app_02], null) != null
  ) ? local.vnet_app_02_subnet_ids[var.subnet1_name_app_02] : module.shared_data.subnet1_app_shared_id_app_02

  subnet2_app_shared_id_app_02 = (
    length(local.vnet_app_02_subnet_ids) > 0 &&
    try(local.vnet_app_02_subnet_ids[var.subnet2_name_app_02], null) != null
  ) ? local.vnet_app_02_subnet_ids[var.subnet2_name_app_02] : module.shared_data.subnet2_app_shared_id_app_02

  subnet3_app_shared_id_app_02 = (
    length(local.vnet_app_02_subnet_ids) > 0 &&
    try(local.vnet_app_02_subnet_ids[var.subnet3_name_app_02], null) != null
  ) ? local.vnet_app_02_subnet_ids[var.subnet3_name_app_02] : module.shared_data.subnet3_app_shared_id_app_02

  # Admin Resources (outside TF) - Data Sources with fallback
  # Selects admin subnet based on environment: DEV uses admin_subnet_dev, others use admin_subnet or shared module
  admin_subnet1_id = length(data.azurerm_subnet.admin_subnet_dev) > 0 ? data.azurerm_subnet.admin_subnet_dev[0].id : (
    length(data.azurerm_subnet.admin_subnet) > 0 ? data.azurerm_subnet.admin_subnet[0].id : module.shared_data.admin_subnet1_id
  )

  # Local to select correct admin VNet
  admin_vnet_name = contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) ? (
    length(data.azurerm_virtual_network.admin_vnet_dev) > 0 ? data.azurerm_virtual_network.admin_vnet_dev[0].name : null
  ) : (
    length(data.azurerm_virtual_network.admin_vnet) > 0 ? data.azurerm_virtual_network.admin_vnet[0].name : null
  )

  # Private DNS Zones - Environment-Specific Logic
  # UAT/PROD: From shared_data module (individual outputs)
  # DEV: From data sources (USEDCXS05HRSG02)
  # QA: From data sources (USEQCXS05HRSG03)

  # Admin remote state DNS zones (for future use when admin layer outputs are available)
  admin_dns_zone_ids = length(data.terraform_remote_state.admin) > 0 && try(data.terraform_remote_state.admin[0].outputs.private_dns_zone_ids, null) != null ? data.terraform_remote_state.admin[0].outputs.private_dns_zone_ids : {}

  # UAT/PROD DNS zones from shared_data module (fallback until admin remote state is ready)
  uat_prod_dns_zone_ids = {
    app_service               = module.shared_data.app_service_private_dns_zone_id
    storage_blob              = module.shared_data.storage_blob_private_dns_zone_id
    storage_table             = module.shared_data.storage_table_private_dns_zone_id
    storage_queue             = module.shared_data.storage_queue_private_dns_zone_id
    signalr                   = module.shared_data.signalr_private_dns_zone_id
    speech                    = module.shared_data.speech_private_dns_zone_id
    document_intelligence     = module.shared_data.document_intelligence_private_dns_zone_id
    container_registry        = module.shared_data.container_registry_private_dns_zone_id
    container_app_environment = module.shared_data.container_app_environment_private_dns_zone_id
    redis_cache               = module.shared_data.redis_cache_dns_zone_id
    servicebus                = module.shared_data.servicebus_dns_zone_id
    cosmosdb                  = module.shared_data.cosmosdb_dns_zone_id
    cosmosdb_postgresql       = module.shared_data.cosmosdb_postgresql_dns_zone_id
  }

  dev_dns_zone_ids = { for k, v in data.azurerm_private_dns_zone.dev_dns_zones : k => v.id }
  qa_dns_zone_ids  = { for k, v in data.azurerm_private_dns_zone.qa_dns_zones : k => v.id }

  # Helper function to get DNS zone ID based on environment
  dns_zone_ids = merge(
    contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) ? local.dev_dns_zone_ids : {},
    upper(var.env) == "QA" ? local.qa_dns_zone_ids : {},
    contains(["UAT", "PROD"], var.env) ? (length(local.admin_dns_zone_ids) > 0 ? local.admin_dns_zone_ids : local.uat_prod_dns_zone_ids) : {}
  )

  storage_account_name_app_01               = var.deploy_resource ? module.storage_account_app_01[0].name : null
  storage_account_primary_access_key_app_01 = var.deploy_resource ? module.storage_account_app_01[0].primary_access_key : null

  ftp_publish_basic_authentication_enabled = false
  scm_publish_basic_authentication_enabled = false

  # Storage Account Network Rules
  storage_virtual_network_subnet_ids = [
    local.admin_subnet1_id,             # Admin Subnet1 ID
    local.frontend_subnet1_id,          # Frontend Subnet1 ID
    local.frontend_subnet2_id,          # Frontend Subnet2 ID
    local.frontend_subnet3_id,          # Frontend Subnet3 ID
    local.subnet1_app_shared_id_app_02, # Backend Subnet1 ID
    local.subnet2_app_shared_id_app_02, # Backend Subnet2 ID
    local.subnet3_app_shared_id_app_02  # Backend Subnet3 ID
  ]

  storage_private_link_endpoint_resource_id = "/subscriptions/${local.subscription_id}/providers/Microsoft.Security/datascanners/StorageDataScanner"

  # Malware Scan File Exclusions Default
  malware_scan_exclude_prefixes_default = [
    "avatars",                     # Exclude entire avatars container
    "azure-webjobs-hosts",         # Exclude entire azure-webjobs-hosts container
    "azure-webjobs-secrets",       # Exclude entire azure-webjobs-secrets container
    "notices",                     # Exclude entire notices container
    "openapipluginspecifications", # Exclude entire openapipluginspecifications container
    "smemory",                     # Exclude entire smemory container
    "templates",                   # Exclude entire templates container
    "testhubname-applease",        # Exclude entire testhubname-applease container
    "testhubname-leases",          # Exclude entire testhubname-leases container
    "vision-assets"                # Exclude entire vision-assets container
  ]

  # Storage Account App 01 exclusion (if different patterns needed)
  malware_scan_exclude_prefixes_app_01 = local.malware_scan_exclude_prefixes_default

  # Dev Integration DNS Zones Info
  resource_group_name_admin_dev = contains(["QA", "UAT", "PROD"], var.env) ? null : "USEDCXS05HRSG02"


  # Application Insights values surfaced from remote state
  is_lab = endswith(lower(var.hidden_title_tag_env), "-lab")

  app_insights = {
    instrumentation_key = local.app_insights_instrumentation_key
    connection_string = {
      current = local.app_insights_connection_string
      pilot   = local.app_insights_pilot_connection_string
      prod    = local.app_insights_prod_connection_string
    }
    resource_id = local.app_insights_resource_id != null ? replace(local.app_insights_resource_id, "Microsoft.Insights", "microsoft.insights") : null
  }

  promote_connection_string = local.is_lab ? local.app_insights.connection_string.pilot : local.app_insights.connection_string.current
  publish_connection_string = local.is_lab ? local.app_insights.connection_string.prod : local.app_insights.connection_string.current

  # App Services General Config
  function_storage_key_vault_secret_id = local.kv_shared_app_storage_connection_string_secret_id

  general_app_settings = {
    "APPINSIGHTS_INSTRUMENTATIONKEY"                  = local.app_insights.instrumentation_key
    "APPLICATIONINSIGHTS_CONNECTION_STRING"           = local.app_insights.connection_string.current
    "APPINSIGHTS_PROFILERFEATURE_VERSION"             = "1.0.0"
    "APPINSIGHTS_SNAPSHOTFEATURE_VERSION"             = "1.0.0"
    "ApplicationInsights.InstrumentationKey"          = local.app_insights.instrumentation_key
    "ApplicationInsightsAgent_EXTENSION_VERSION"      = "~2"
    "DiagnosticServices_EXTENSION_VERSION"            = "~3"
    "InstrumentationEngine_EXTENSION_VERSION"         = "disabled"
    "SnapshotDebugger_EXTENSION_VERSION"              = "disabled"
    "XDT_MicrosoftApplicationInsights_BaseExtensions" = "disabled"
    "XDT_MicrosoftApplicationInsights_Java"           = "1"
    "XDT_MicrosoftApplicationInsights_Mode"           = "recommended"
    "XDT_MicrosoftApplicationInsights_NodeJS"         = "1"
    "XDT_MicrosoftApplicationInsights_PreemptSdk"     = "disabled"
  }

  # optional: values used by API/NOTICE/KERNEL but not by UI — include if ok to apply to all and override when needed
  general_app_settings_optional = {
    "ASPNETCORE_ENVIRONMENT" = lookup(
      {
        "Dev-1" = "Development1"
        "Dev-2" = "Development2"
        "Dev-3" = "Development3"
      },
      var.hidden_title_tag_env,
      lower(var.hidden_title_tag_env)
    )
    "KeyVaultUrl"            = local.kv_shared_app_uri
  }

  app_service_sticky_settings = {
    app_setting_names = [
      "APPINSIGHTS_INSTRUMENTATIONKEY",
      "APPLICATIONINSIGHTS_CONNECTION_STRING",
      "APPINSIGHTS_PROFILERFEATURE_VERSION",
      "APPINSIGHTS_SNAPSHOTFEATURE_VERSION",
      "ApplicationInsightsAgent_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_BaseExtensions",
      "DiagnosticServices_EXTENSION_VERSION",
      "InstrumentationEngine_EXTENSION_VERSION",
      "SnapshotDebugger_EXTENSION_VERSION",
      "XDT_MicrosoftApplicationInsights_Mode",
      "XDT_MicrosoftApplicationInsights_PreemptSdk",
      "APPLICATIONINSIGHTS_CONFIGURATION_CONTENT",
      "XDT_MicrosoftApplicationInsightsJava",
      "XDT_MicrosoftApplicationInsights_NodeJS",
    ]
    connection_string_names = []
  }

  general_function_app_settings = {
    "AgentMigrationEnvironment"                            = "AGENTMIGRATIONENVIRONMENT"
    "AgentPerformanceNotificationSchedule"                 = "0 0 0 * * *"
    "AgentPromotionQueue"                                  = "agentpromotion"
    "AppInsight:WorkspaceID"                               = local.app_insights.instrumentation_key
    "ApplicationInsights:PromoteConnectionString"          = local.promote_connection_string
    "ApplicationInsights:PublishConnectionString"          = local.publish_connection_string
    "AppWebJobsStorage"                                    = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=FuncAppStorageConnectionString)"
    "Aspose:PrivateKey"                                    = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=Aspose--PrivateKey)"
    "Aspose:PublicKey"                                     = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=Aspose--PublicKey)"
    "Azure:SignalR:ConnectionString"                       = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=Azure--SignalR--ConnectionString)"
    "ChatStore:Cosmos:AIAcceleratorCourseContainer"        = "aiAcceleratorCourse"
    "ChatStore:Cosmos:AgentActionsContainer"               = "agentActions"
    "ChatStore:Cosmos:AgentCategoriesContainer"            = "AgentCategories"
    "ChatStore:Cosmos:AgentCategoryTypesContainer"         = "AgentCategoryTypes"
    "ChatStore:Cosmos:AgentEnvironmentStepContainer"       = "agentEnvironmentSteps"
    "ChatStore:Cosmos:AgentGroupContainer"                 = "agentGroup"
    "ChatStore:Cosmos:AgentMetadataContainer"              = "agentMetadata"
    "ChatStore:Cosmos:AgentRoleBasedActionsContainer"      = "agentRoleBasedActions"
    "ChatStore:Cosmos:AgentStepsContainer"                 = "agentSteps"
    "ChatStore:Cosmos:AgentReasoningContainer"             = "agentReasoning"
    "ChatStore:Cosmos:AgentTagsContainer"                  = "AgentTags"
    "ChatStore:Cosmos:AgentsContainer"                     = "agent"
    "ChatStore:Cosmos:ApiAgentsContainer"                  = "apiAgents"
    "ChatStore:Cosmos:BackgroundJobsContainer"             = "backgroundJobs"
    "ChatStore:Cosmos:CertifiedCodesContainer"             = "certifiedCodes"
    "ChatStore:Cosmos:ChatArchiveContainer"                = "chatArchive"
    "ChatStore:Cosmos:ChatDocumentDetailsContainer"        = "chatDocumentDetails"
    "ChatStore:Cosmos:ChatMemorySourcesContainer"          = "chatmemorysources"
    "ChatStore:Cosmos:ChatMessagesContainer"               = "chatmessages"
    "ChatStore:Cosmos:ChatParticipantsContainer"           = "chatparticipants"
    "ChatStore:Cosmos:ChatSessionsContainer"               = "chatsessions"
    "ChatStore:Cosmos:ConnectionString"                    = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=ChatStore--Cosmos--ConnectionString)"
    "ChatStore:Cosmos:ConnectionStrings:PromoteTarget"     = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=ChatStore--Cosmos--ConnectionString--PromoteTarget)"
    "ChatStore:Cosmos:ConnectionStrings:PublishTarget"     = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=ChatStore--Cosmos--ConnectionString--PublishTarget)"
    "ChatStore:Cosmos:Database"                            = "EYX-Copilot"
    "ChatStore:Cosmos:Databases:PromoteTarget"             = "EYX-Copilot"
    "ChatStore:Cosmos:Databases:PublishTarget"             = "EYX-Copilot"
    "ChatStore:Cosmos:DocumentAgentsContainer"             = "documentAgents"
    "ChatStore:Cosmos:DocumentDataMigrationContainer"      = "documentDataMigration"
    "ChatStore:Cosmos:DocumentDetailsContainer"            = "documentDetails"
    "ChatStore:Cosmos:KnowledgeMastersContainer"           = "knowledgeMasters"
    "ChatStore:Cosmos:MCPServerDirectoryContainer"         = "mcpserverdirectory"
    "ChatStore:Cosmos:NotificationTemplateContainer"       = "notificationTemplates"
    "ChatStore:Cosmos:NotificationDetailsContainer"        = "notifications"
    "ChatStore:Cosmos:PluginDirectoryContainer"            = "pluginDirectory"
    "ChatStore:Cosmos:RemoteLibraryDetailContainer"        = "remoteLibraryDetails"
    "ChatStore:Cosmos:RoleBasedPermissionsContainer"       = "roleBasedPermissions"
    "ChatStore:Cosmos:TestCaseContainer"                   = "testCase"
    "ChatStore:Cosmos:TestResultContainer"                 = "testResult"
    "ChatStore:Cosmos:TestSuiteContainer"                  = "testSuite"
    "ChatStore:Cosmos:UserContainer"                       = "users"
    "ChatStore:Cosmos:WorkspaceContainer"                  = "WorkspaceDetails"
    "ChatStore:Type"                                       = "cosmos"
    "DocProcessorQueue"                                    = "geney-docprocessor"
    "EmailService:AgentFeedbackTemplateId"                 = "d-0a4281f8bd954e32b3090b12c56895a3"
    "EmailService:ErrorNotificationTemplateId"             = "d-fa2ffd244f8f4c5c833b01555a38bd04"
    "EmailService:FromEmailAddress"                        = "^{EmailServiceFromAddress}^"
    "EmailService:FromName"                                = "TaxAssist"
    "EmailService:Key"                                     = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=EmailService--Key)"
    "EmailService:StatelessWatcherTemplateId"              = "d-babe831ad54345fc810afa66f02cf77a"
    "EnvironmentName"                                      = lookup(
      {
        "Dev-1" = "Development1"
        "Dev-2" = "Development2"
        "Dev-3" = "Development3"
      },
      var.hidden_title_tag_env,
      lower(var.hidden_title_tag_env)
    )
    "InActiveChatCleanUpQueue"                             = "geney-inactivechatcleanup"
    "IsStateLess"                                          = "false"
    "KernelMemoryService:Key"                              = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=KernelMemoryService--Key)"
    "KernelMemoryService:Url"                              = "${module.app_service_windows_kernel_memory.default_hostname_fqdn}/"
    "MailRecipientList"                                    = "dante.ciai@gds.ey.com,juan.mercade@gds.ey.com,dario.h.fernandez@gds.ey.com"
    "MemoryStore:Postgres:ConnectionString"                = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=MemoryStore--Postgres--ConnectionString)"
    "MemoryStore:Postgres:ConnectionStrings:PromoteTarget" = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=MemoryStore--Postgres--ConnectionString--PromoteTarget)"
    "MemoryStore:Postgres:ConnectionStrings:PublishTarget" = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=MemoryStore--Postgres--ConnectionString--PublishTarget)"
    "MinChatsForEmailNotification"                         = "30"
    "MinMessagesForEmailNotification"                      = "50"
    "Postgres:ConnectionString"                            = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=MemoryStore--Postgres--ConnectionString)"
    "PurgeExpiredMessagesSchedule"                         = "0 0 2 * * *"
    "PurgeNoticeFilesSchedule"                             = "0 */30 * * * *"
    "PurgeNoticeFilesTimeLimit"                            = "60"
    "PurgeNotificationDays"                                = "90"
    "PurgeStaleNotificationSchedule"                       = "0 0 1 * * *"
    "RedisCache:DocAgentExpirationTimeInSeconds"           = "3600"
    "RedisCacheConnectionString"                           = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=RedisCache--ConnectionString)"
    "ServiceBus:ConnectionString"                          = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=ServiceBus--ConnectionString)"
    "ServiceBusConnectionString"                           = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=ServiceBus--ConnectionString)"
    "SourceAgentContainer"                                 = "agent"
    "SourceCosmosConnectionString"                         = "^{SourceCosmosConnectionString}^"
    "SourceCosmosDBName"                                   = "^{SourceCosmosDBName}^"
    "SourceDocumentAgentContainer"                         = "documentAgents"
    "SourceDocumentDetailsContainer"                       = "documentDetails"
    "StateLessChatSchedule"                                = "0 */30 * * * *"
    "StateLessChatTime"                                    = "60"
    "StateLessWatcherTime"                                 = "95"
    "StatelessWatcherSchedule"                             = "0 */45 * * * *"
    "StorageAccount:ConnectionString"                      = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=StorageAccount--ConnectionString)"
    "StorageAccount:ConnectionStrings:PromoteTarget"       = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=StorageAccount--ConnectionString--PromoteTarget)"
    "StorageAccount:ConnectionStrings:PublishTarget"       = "@Microsoft.KeyVault(VaultName=${var.key_vault_name};SecretName=StorageAccount--ConnectionString--PublishTarget)"
    "TargetAgentContainer"                                 = "agent"
    "TargetCosmosConnectionString"                         = "^{TargetCosmosConnectionString}^"
    "TargetCosmosDBName"                                   = "^{TargetCosmosDBName}^"
    "TargetDocumentAgentContainer"                         = "documentAgents"
    "TargetDocumentDetailsContainer"                       = "documentDetails"
    "InactiveAgentPurgeDays"                               = tostring(var.inactive_agent_purge_days)
    "PurgeInactiveAgentsSchedule"                          = "0 0 2 * * *" # Daily at 2:00 AM UTC
    "AgentRankingSchedule"                                 = "0 0 3 * * *" # Daily at 3:00 AM UTC
    "WEBSITE_ENABLE_SYNC_UPDATE_SITE"                      = "true"
    "WEBSITE_RUN_FROM_PACKAGE"                             = "1"
    "FUNCTIONS_WORKER_RUNTIME"                             = "dotnet-isolated"
  }


  ####################
  # SIGNAL R CONFIGS #
  ####################
  # Standardized SignalR autoscale configuration shared across environments
  signalr_autoscale = {
    external_metric_enabled    = true
    external_metric_namespace  = "Microsoft.Web/serverfarms"
    metric_name                = "CpuPercentage"
    min_capacity               = 2
    default_capacity           = 2
    max_capacity               = 8
    scale_out_threshold        = 50
    scale_in_threshold         = 30
    scale_out_change_count     = 2
    scale_in_change_count      = 1
    scale_out_cooldown_minutes = 30
    scale_in_cooldown_minutes  = 30
    scale_out_statistic        = "Average"
    scale_in_statistic         = "Min"
  }

  signalr_cors = {
    allowed_origins = ["https://*.ey.net", "https://*.ey.com", "https://*.sbp.eyclienthub.com"]
  }

  ##################################################
  # CONTAINER APPS SESSION POOL MANAGED IDENTITIES #
  ##################################################

  # App Service managed identities for Container Apps Session Pool roles
  # Build a comprehensive map of all available app service managed identity principal IDs
  all_app_service_managed_identities = var.deploy_resource ? {
    (var.web_app_name_app_01) = try(module.app_service_windows_ui.principal_id, null)
    (var.web_app_name_app_02) = try(module.app_service_windows_web_api.principal_id, null)
    (var.web_app_name_app_03) = try(module.app_service_windows_notice_api.principal_id, null)
    (var.web_app_name_app_04) = try(module.app_service_windows_kernel_memory.principal_id, null)
  } : {}

  # Fetch managed identity principal IDs using current module outputs and terraform_remote_state
  app_service_managed_identity_principal_ids = var.session_pool_enabled ? {
    for app_name in var.session_pool_app_service_managed_identities :
    app_name => try(
      # First try to get from current module outputs map (preferred for new deployments)
      local.all_app_service_managed_identities[app_name],

      # Try to get from terraform_remote_state app layer outputs (for refresh/subsequent applies)
      length(data.terraform_remote_state.app) > 0 ? data.terraform_remote_state.app[0].outputs.app_service_managed_identities[app_name] : null,
      length(data.terraform_remote_state.app) > 0 ? data.terraform_remote_state.app[0].outputs["${app_name}_managed_identity_principal_id"] : null,

      # Try specific naming patterns for the notice API from remote state
      app_name == var.web_app_name_app_03 && length(data.terraform_remote_state.app) > 0 ? data.terraform_remote_state.app[0].outputs.notice_api_managed_identity_principal_id : null,
      app_name == var.web_app_name_app_03 && length(data.terraform_remote_state.app) > 0 ? data.terraform_remote_state.app[0].outputs.app_service_windows_notice_api_principal_id : null,

      null
    ) if try(length(trimspace(app_name)) > 0, false)
  } : {}

  # Use only explicitly specified app services from session_pool_app_service_managed_identities
  combined_app_service_principals = var.session_pool_enabled ? local.app_service_managed_identity_principal_ids : {}

  # Create deduplicated list of managed identities for session pool with unique principal IDs
  app_service_managed_identities_for_session_pool = var.session_pool_enabled ? [
    for app_name, principal_id in local.combined_app_service_principals :
    {
      principal_id   = principal_id
      principal_type = "ServicePrincipal"
    } if principal_id != null && length(trimspace(principal_id)) > 0
  ] : []

  # Deduplicate by principal_id to avoid duplicate role assignments
  unique_app_service_managed_identities_for_session_pool = var.session_pool_enabled ? {
    for idx, identity in local.app_service_managed_identities_for_session_pool :
    identity.principal_id => identity
  } : {}

  # Convert back to list for the module
  final_app_service_managed_identities_for_session_pool = [
    for principal_id, identity in local.unique_app_service_managed_identities_for_session_pool :
    identity
  ]

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
    storage_account_app_01_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - App",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - App"
    }
    storage_account_app_02_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - App logs",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - App logs"
    }
    app_service_plan_ui_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - UI App Service Plan",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - UI App Service Plan"
    }
    app_service_plan_apis_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - API App Service Plan",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - API App Service Plan"
    }
    app_service_plan_functions_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Function App Service Plan",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Function App Service Plan"
    }
    app_service_ui_tags = {
      "hidden-title"                           = "EYX - ${var.hidden_title_tag_env} - UI App Service"
      "hidden-link: /app-insights-resource-id" = "${local.app_insights.resource_id}"
      "ROLE_PURPOSE"                           = "EYX - ${var.hidden_title_tag_env} - UI App Service"
    }
    app_service_api_tags = {
      "hidden-title"                           = "EYX - ${var.hidden_title_tag_env} - API App Service"
      "hidden-link: /app-insights-resource-id" = "${local.app_insights.resource_id}"
      "ROLE_PURPOSE"                           = "EYX - ${var.hidden_title_tag_env} - API App Service"
    }
    app_service_noticeapi_tags = {
      "hidden-title"                           = "EYX - ${var.hidden_title_tag_env} - Notice API App Service"
      "hidden-link: /app-insights-resource-id" = "${local.app_insights.resource_id}"
      "ROLE_PURPOSE"                           = "EYX - ${var.hidden_title_tag_env} - Notice API App Service"
    }
    app_service_kernelapi_tags = {
      "hidden-title"                           = "EYX - ${var.hidden_title_tag_env} - Kernel API App Service"
      "hidden-link: /app-insights-resource-id" = "${local.app_insights.resource_id}"
      "ROLE_PURPOSE"                           = "EYX - ${var.hidden_title_tag_env} - Kernel API App Service"
    }
    function_app_01_tags = {
      "hidden-title"                           = "EYX - ${var.hidden_title_tag_env} - Functions App Service"
      "hidden-link: /app-insights-resource-id" = "${local.app_insights.resource_id}"
      "ROLE_PURPOSE"                           = "EYX - ${var.hidden_title_tag_env} - Functions App Service"
    }
    signalr_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - SignalR Service",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - SignalR Service"
    }
    container_registry_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Container Registry",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Container Registry"
    }
    container_app_environment_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Container App Environment",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Container App Environment"
    }
    container_app_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Container App",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Container App"
    }
    speech_account_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Cognitive Speech Service",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Cognitive Speech Service"
    }
    document_intelligence_account_tags = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Document Intelligence Service",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Document Intelligence Service"
    }


  }

  # Dynamic merging - automatically merges general_tags with each resource-specific tag set
  # Extra tags applied only for QA environment
  qa_extra_tags = var.env == "QA" ? {
    "CTP_SERVICE" = "Co-Dev"
    "PRODUCT_APP" = "EYX - Agent Framework"
    "TF_LAYER"    = "app"
  } : {}

  merged_tags = {
    for key, resource_tags in local.resources_specific_tags :
    key => merge(local.general_tags, resource_tags, local.qa_extra_tags)
  }

  private_endpoint_specific_tags = {
    function_app_01_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Function App PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Function App PEP"
    }
    app_service_windows_ui_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - UI Webapp PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - UI Webapp PEP"
    }
    app_service_windows_web_api_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - API Webapp PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - API Webapp PEP"
    }
    app_service_windows_notice_api_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Notice API Webapp PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Notice API Webapp PEP"
    }
    app_service_windows_kernel_memory_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Kernel Memory Webapp PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Kernel Memory Webapp PEP"
    }
    storage_account_app_01_blob_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - App Blob PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - App Blob PEP"
    }
    storage_account_app_01_table_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - App Table PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - App Table PEP"
    }
    storage_account_app_01_queue_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - App Queue PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - App Queue PEP"
    }
    storage_account_app_02_blob_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - App Blob PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - App Blob PEP"
    }
    storage_account_app_02_queue_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - App Queue PEP"
    }
    speech_account_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Speech PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Speech PEP"
    }
    document_intelligence_account_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Document Intelligence PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Document Intelligence PEP"
    }
    container_registry_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Container Registry PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Container Registry PEP"
    }
    container_app_environment_pep = {
      "hidden-title" = "EYX - ${var.hidden_title_tag_env} - Container App Environment PEP",
      "ROLE_PURPOSE" = "EYX - ${var.hidden_title_tag_env} - Container App Environment PEP"
    }
  }

  # Dynamic merging for private endpoints
  merged_private_endpoint_tags = {
    for key, pep_tags in local.private_endpoint_specific_tags :
    key => merge(local.general_tags, pep_tags)
  }

  private_dns_zones_names_app = {
    storage_blob          = "privatelink.blob.core.windows.net"
    storage_queue         = "privatelink.queue.core.windows.net"
    storage_table         = "privatelink.table.core.windows.net"
    app_service           = "privatelink.azurewebsites.net"
    document_intelligence = "privatelink.cognitiveservices.azure.com"
    speech                = "privatelink.cognitiveservices.azure.com"
    # ACR is public in DEV, not using PEP
    container_registry = contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) ? null : "privatelink.azurecr.io"

    # Conditionally include container_app_environment DNS zone only when private endpoint is configured
    # This prevents failures in environments (like UAT) where the DNS zone hasn't been created yet
    container_app_environment = try(
      coalesce(var.container_app_environment_pep_name, "") != "" ? "privatelink.${lower(local.resource_group_app_location)}.azurecontainerapps.io" : null,
      null
    )
  }

  # Define all possible private endpoints (before filtering)
  app_private_endpoints_all = {
    function_app_01 = {
      name                = var.function_app_pep_name
      subnet_id           = local.frontend_subnet1_id
      connection_name     = var.function_app_pep_name
      resource_id         = module.function_app_01.function_app_id
      subresource_names   = ["sites"]
      private_dns_zone_id = try(local.dns_zone_ids["app_service"], null)
      tags                = local.merged_private_endpoint_tags.function_app_01_pep
    }

    app_service_windows_ui = {
      name                = var.web_app_ui_pep_name
      subnet_id           = local.frontend_subnet1_id
      connection_name     = var.web_app_ui_pep_name
      resource_id         = module.app_service_windows_ui.id
      subresource_names   = ["sites"]
      private_dns_zone_id = try(local.dns_zone_ids["app_service"], null)
      tags                = local.merged_private_endpoint_tags.app_service_windows_ui_pep
    }

    app_service_windows_web_api = {
      name                = var.web_app_api_pep_name
      subnet_id           = local.frontend_subnet1_id
      connection_name     = var.web_app_api_pep_name
      resource_id         = module.app_service_windows_web_api.id
      subresource_names   = ["sites"]
      private_dns_zone_id = try(local.dns_zone_ids["app_service"], null)
      tags                = local.merged_private_endpoint_tags.app_service_windows_web_api_pep
    }

    app_service_windows_notice_api = {
      name                = var.web_app_notice_api_pep_name
      subnet_id           = local.frontend_subnet1_id
      connection_name     = var.web_app_notice_api_pep_name
      resource_id         = module.app_service_windows_notice_api.id
      subresource_names   = ["sites"]
      private_dns_zone_id = try(local.dns_zone_ids["app_service"], null)
      tags                = local.merged_private_endpoint_tags.app_service_windows_notice_api_pep
    }

    app_service_windows_kernel_memory = {
      name                = var.web_app_kernel_memory_pep_name
      subnet_id           = local.frontend_subnet1_id
      connection_name     = var.web_app_kernel_memory_pep_name
      resource_id         = module.app_service_windows_kernel_memory.id
      subresource_names   = ["sites"]
      private_dns_zone_id = try(local.dns_zone_ids["app_service"], null)
      tags                = local.merged_private_endpoint_tags.app_service_windows_kernel_memory_pep
    }

    storage_account_app_01_blob = {
      name                = var.storage_account_app_pep_name_blob
      subnet_id           = local.subnet1_app_shared_id_app_02
      connection_name     = var.storage_account_app_pep_name_blob
      resource_id         = module.storage_account_app_01[0].id
      subresource_names   = ["blob"]
      private_dns_zone_id = try(local.dns_zone_ids["storage_blob"], null)
      tags                = local.merged_private_endpoint_tags.storage_account_app_01_blob_pep
    }

    storage_account_app_01_table = {
      name                = var.storage_account_app_pep_name_table
      subnet_id           = local.subnet1_app_shared_id_app_02
      connection_name     = var.storage_account_app_pep_name_table
      resource_id         = module.storage_account_app_01[0].id
      subresource_names   = ["table"]
      private_dns_zone_id = try(local.dns_zone_ids["storage_table"], null)
      tags                = local.merged_private_endpoint_tags.storage_account_app_01_table_pep
    }

    storage_account_app_01_queue = {
      name                = var.storage_account_app_pep_name_queue
      subnet_id           = local.subnet1_app_shared_id_app_02
      connection_name     = var.storage_account_app_pep_name_queue
      resource_id         = module.storage_account_app_01[0].id
      subresource_names   = ["queue"]
      private_dns_zone_id = try(local.dns_zone_ids["storage_queue"], null)
      tags                = local.merged_private_endpoint_tags.storage_account_app_01_queue_pep
    }

    storage_account_app_02_blob = {
      name                = var.storage_account_app_logs_pep_name_blob
      subnet_id           = local.subnet1_app_shared_id_app_02
      connection_name     = var.storage_account_app_logs_pep_name_blob
      resource_id         = module.storage_account_app_02[0].id
      subresource_names   = ["blob"]
      private_dns_zone_id = try(local.dns_zone_ids["storage_blob"], null)
      tags                = local.merged_private_endpoint_tags.storage_account_app_02_blob_pep
    }

    storage_account_app_02_queue = {
      name                = var.storage_account_app_logs_pep_name_queue
      subnet_id           = local.subnet1_app_shared_id_app_02
      connection_name     = var.storage_account_app_logs_pep_name_queue
      resource_id         = module.storage_account_app_02[0].id
      subresource_names   = ["queue"]
      private_dns_zone_id = try(local.dns_zone_ids["storage_queue"], null)
      tags                = local.merged_private_endpoint_tags.storage_account_app_02_queue_pep
    }

    speech_account = {
      name                = var.speech_account_pep_name
      subnet_id           = local.subnet1_app_shared_id_app_02
      connection_name     = var.speech_account_pep_name
      resource_id         = module.speech_account[0].id
      subresource_names   = ["account"]
      private_dns_zone_id = try(local.dns_zone_ids["speech"], null)
      tags                = local.merged_private_endpoint_tags.speech_account_pep
    }

    document_intelligence_account = {
      name                = var.document_intelligence_pep_name
      subnet_id           = local.subnet1_app_shared_id_app_02
      connection_name     = var.document_intelligence_pep_name
      resource_id         = module.document_intelligence_account[0].id
      subresource_names   = ["account"]
      private_dns_zone_id = try(local.dns_zone_ids["document_intelligence"], null)
      tags                = local.merged_private_endpoint_tags.document_intelligence_account_pep
    }

    # ACR is public in DEV environments (dev1, dev2, dev3) - no private endpoint needed
    # container_registry = {
    #   name                = var.container_registry_pep_name
    #   subnet_id           = local.subnet1_app_shared_id_app_02
    #   connection_name     = var.container_registry_pep_name
    #   resource_id         = module.container_registry[0].id
    #   subresource_names   = ["registry"]
    #   private_dns_zone_id = try(local.dns_zone_ids["container_registry"], null)
    #   tags                = local.merged_private_endpoint_tags.container_registry_pep
    # }

    container_app_environment = {
      name                = var.container_app_environment_pep_name
      subnet_id           = local.subnet1_app_shared_id_app_02
      connection_name     = var.container_app_environment_pep_name
      resource_id         = module.container_app_environment[0].id
      subresource_names   = ["managedEnvironments"]
      private_dns_zone_id = try(local.dns_zone_ids["container_app_environment"], null)
      tags                = local.merged_private_endpoint_tags.container_app_environment_pep
    }
  }

  # Filter out private endpoints where name is null or empty (e.g., container_app_environment in QA)
  app_private_endpoints = {
    for key, value in local.app_private_endpoints_all :
    key => value
    if value.name != null && value.name != ""
  }

  ##############################################
  # Admin Resource Group Selection
  ##############################################
  # Selects the correct admin resource group name based on environment.
  # DEV environments use admin_dev (in dev_integration subscription),
  # while QA/UAT/PROD use admin (in default subscription).
  admin_rg_name = contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) ? (
    length(data.azurerm_resource_group.admin_dev) > 0 ? data.azurerm_resource_group.admin_dev[0].name : null
  ) : (
    length(data.azurerm_resource_group.admin) > 0 ? data.azurerm_resource_group.admin[0].name : null
  )

  ##############################################
  # Private DNS Zone Names for DEV and QA
  ##############################################
  # DEV/Dev-Integration DNS zone names (in RG: USEDCXS05HRSG02)
  # These zones are used for private endpoints in DEV1, DEV2, DEV3 environments
  dev_dns_zone_names = {
    app_service               = "privatelink.azurewebsites.net"
    storage_blob              = "privatelink.blob.core.windows.net"
    storage_table             = "privatelink.table.core.windows.net"
    storage_queue             = "privatelink.queue.core.windows.net"
    speech                    = "privatelink.cognitiveservices.azure.com"
    document_intelligence     = "privatelink.cognitiveservices.azure.com"
    # container_registry        = "privatelink.azurecr.io"  # ACR is public in DEV, no PEP needed
    container_app_environment = "privatelink.${lower(local.resource_group_app_location)}.azurecontainerapps.io"
    signalr                   = "privatelink.service.signalr.net"
  }

  # QA DNS zone names (in RG: USEQCXS05HRSG03)
  # These zones are used for private endpoints in QA environment
  qa_dns_zone_names = {
    app_service               = "privatelink.azurewebsites.net"
    storage_blob              = "privatelink.blob.core.windows.net"
    storage_table             = "privatelink.table.core.windows.net"
    storage_queue             = "privatelink.queue.core.windows.net"
    speech                    = "privatelink.cognitiveservices.azure.com"
    document_intelligence     = "privatelink.cognitiveservices.azure.com"
    # container_registry        = "privatelink.azurecr.io"  # Commented to match DEV pattern
    container_app_environment = "privatelink.${lower(local.resource_group_app_location)}.azurecontainerapps.io"
    signalr                   = "privatelink.service.signalr.net"
  }
}
