data "azurerm_client_config" "current" {}

resource "azurerm_storage_account" "storage_account" {
  name                              = var.name
  resource_group_name               = var.resource_group_name
  location                          = var.location
  account_tier                      = var.account_tier
  account_replication_type          = var.account_replication_type
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public
  public_network_access_enabled     = var.public_network_access_enabled
  tags                              = var.tags
  infrastructure_encryption_enabled = var.account_infra_encryption_enabled
  network_rules {
    bypass = ["AzureServices"]
    default_action = "Deny"
    # Filter out any accidental null values to avoid provider error "Null value found in list"
    # local.app layer may supply a list with nulls when some shared_data subnets are not defined in certain envs
    virtual_network_subnet_ids = [for id in var.subnet_ids : id if id != null]
    ip_rules = var.ip_rules
    # Conditionally add exactly one private_link_access block if a resource id is provided.
    # for_each uses a single‑element LIST when the variable is non-null; otherwise an empty list (no blocks).
    dynamic "private_link_access" {
      # One element list => one block; empty list => zero blocks.
      for_each = var.private_link_endpoint_resource_id != null ? [var.private_link_endpoint_resource_id] : []
      content {
        endpoint_resource_id = private_link_access.value
        endpoint_tenant_id   = data.azurerm_client_config.current.tenant_id
      }
    }
  }
  identity {
    type = "SystemAssigned"
  }

  blob_properties {

    # Enable blob indexing
    last_access_time_enabled = true

    # Enable malware scanning and publish results
    # (Feature Preview in Azure, requires prior enablement)
    change_feed_enabled = true
    versioning_enabled  = true

    # Specifies the number of days that the blob should be retained
    delete_retention_policy {
      days                     = var.blob_delete_retention_policy_days
      permanent_delete_enabled = false # Must be false if restore_policy is used
    }

    # Specifies the number of days that the blob can be restored
    restore_policy {
      days = 7
    }

    # Specifies the number of days that the container should be retained
    container_delete_retention_policy {
      days = 14
    }
  }

}
# Event Grid Topic for Malware Scan Results
# This Event Grid topic is public and receives scan results from Microsoft Defender for Storage
resource "azurerm_eventgrid_topic" "malware_scan_topic" {
  count               = var.enable_malware_scanning ? 1 : 0
  name                = "${var.name}-malwarescan"
  resource_group_name = var.resource_group_name
  location            = var.location

  # Event Grid topic must be public to receive malware scan results
  public_network_access_enabled = true

  tags = var.tags
}

# Event Subscription to route malware scan results to Azure Function
# Azure Function App Function must exist before this Event Subscription can be created
# Only create if malware scanning is enabled, function app name is provided, and the function app data source exists
resource "azurerm_eventgrid_event_subscription" "malware_scan_subscription" {
  count = var.enable_malware_scanning && var.function_app_name_app_01 != null && length(data.azurerm_windows_function_app.function_app_01) > 0 ? 1 : 0
  name  = var.malware_scan_subscription_name
  scope = azurerm_eventgrid_topic.malware_scan_topic[0].id
  advanced_filtering_on_arrays_enabled = true

  azure_function_endpoint {
    function_id = "${data.azurerm_windows_function_app.function_app_01[0].id}/functions/${var.function_app_function_name}"
    max_events_per_batch = 1
    preferred_batch_size_in_kilobytes = 64
  }

  included_event_types = [  
    "Microsoft.Security.MalwareScanningResult"
  ]
}

# Microsoft Defender for Storage with Malware Scanning Configuration
# 
# IMPORTANT: 
# - API version 2022-12-01-preview does NOT support filters (silently ignores them)
# - Container names in excludeBlobsWithPrefix should NOT include trailing slashes
#
# Enables on-upload malware scanning with configurable monthly cap and Event Grid integration
resource "azapi_resource_action" "enable_defender_for_storage" {
  count       = var.enable_malware_scanning ? 1 : 0
  type        = "Microsoft.Security/defenderForStorageSettings@2025-06-01"
  resource_id = "${azurerm_storage_account.storage_account.id}/providers/Microsoft.Security/defenderForStorageSettings/current"
  method      = "PUT"

  body = {
    properties = {
      isEnabled = true
      malwareScanning = {
        onUpload = merge(
          {
            isEnabled              = true
            capGBPerMonth          = var.malware_scan_cap_gb_per_month
            blobScanResultsOptions = "BlobIndexTags"
          },
          # Only include filters object if there are actual exclusions to set
          (
            length(var.malware_scan_exclude_blobs_with_prefix) > 0 ||
            length(var.malware_scan_exclude_blobs_with_suffix) > 0 ||
            var.malware_scan_exclude_blobs_larger_than != null
          ) ? {
            filters = merge(
              length(var.malware_scan_exclude_blobs_with_prefix) > 0 ? {
                excludeBlobsWithPrefix = var.malware_scan_exclude_blobs_with_prefix
              } : {},
              length(var.malware_scan_exclude_blobs_with_suffix) > 0 ? {
                excludeBlobsWithSuffix = var.malware_scan_exclude_blobs_with_suffix
              } : {},
              var.malware_scan_exclude_blobs_larger_than != null ? {
                excludeBlobsLargerThan = var.malware_scan_exclude_blobs_larger_than
              } : {}
            )
          } : {}
        )
        # CRITICAL: scanResultsEventGridTopicResourceId must be at malwareScanning level, NOT inside onUpload
        # This is required by the Azure API schema (2025-06-01). Placing it inside onUpload will cause errors.
        scanResultsEventGridTopicResourceId = var.enable_malware_scanning && var.function_app_name_app_01 != null && length(azurerm_eventgrid_topic.malware_scan_topic) > 0 ? azurerm_eventgrid_topic.malware_scan_topic[0].id : null
      }
      sensitiveDataDiscovery = {
        isEnabled = var.enable_sensitive_data_discovery
      }

      overrideSubscriptionLevelSettings = true
    }
  }

  depends_on = [azurerm_storage_account.storage_account]
}

# Diagnostic settings for Storage Account
resource "azurerm_monitor_diagnostic_setting" "storage_account_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.diag_resource_name_prefix != null ? var.diag_resource_name_prefix : var.name}-diagnostic"
  target_resource_id         = azurerm_storage_account.storage_account.id
  log_analytics_workspace_id = var.log_analytics_workspace_id
  # Storage Account level only supports metrics, not logs
  # The log categories like StorageRead, StorageWrite, StorageDelete are available 
  # at the service level (blob, queue, table, file) but not at the account level

  enabled_metric {
    category = "Capacity"
  }

  enabled_metric {
    category = "Transaction"
  }
}

# Diagnostic settings for Blob Storage
resource "azurerm_monitor_diagnostic_setting" "blob_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.diag_resource_name_prefix != null ? var.diag_resource_name_prefix : var.name}-blob-diagnostic"
  target_resource_id         = "${azurerm_storage_account.storage_account.id}/blobServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_log {
    category_group = "audit"
  }
  enabled_metric {
    category = "Capacity"
  }

  enabled_metric {
    category = "Transaction"
  }
}

# Diagnostic settings for Table Storage
resource "azurerm_monitor_diagnostic_setting" "table_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.diag_resource_name_prefix != null ? var.diag_resource_name_prefix : var.name}-table-diagnostic"
  target_resource_id         = "${azurerm_storage_account.storage_account.id}/tableServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_log {
    category_group = "audit"
  }

  enabled_metric {
    category = "Capacity"
  }

  enabled_metric {
    category = "Transaction"
  }
}

# Diagnostic settings for Queue Storage
resource "azurerm_monitor_diagnostic_setting" "queue_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.diag_resource_name_prefix != null ? var.diag_resource_name_prefix : var.name}-queue-diagnostic"
  target_resource_id         = "${azurerm_storage_account.storage_account.id}/queueServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_log {
    category_group = "audit"
  }

  enabled_metric {
    category = "Capacity"
  }

  enabled_metric {
    category = "Transaction"
  }
}

# Diagnostic settings for File Storage
resource "azurerm_monitor_diagnostic_setting" "file_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.diag_resource_name_prefix != null ? var.diag_resource_name_prefix : var.name}-file-diagnostic"
  target_resource_id         = "${azurerm_storage_account.storage_account.id}/fileServices/default"
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category_group = "allLogs"
  }

  enabled_log {
    category_group = "audit"
  }

  enabled_metric {
    category = "Capacity"
  }

  enabled_metric {
    category = "Transaction"
  }
}
