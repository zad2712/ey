resource "azurerm_windows_function_app" "this" {
  name                                       = var.name
  location                                   = var.location
  resource_group_name                        = var.resource_group_name
  service_plan_id                            = var.service_plan_id
  storage_key_vault_secret_id                = var.storage_key_vault_secret_id
  virtual_network_subnet_id                  = var.virtual_network_subnet_id
  client_certificate_mode                    = var.client_certificate_mode
  ftp_publish_basic_authentication_enabled   = var.ftp_publish_basic_authentication_enabled
  webdeploy_publish_basic_authentication_enabled = var.webdeploy_publish_basic_authentication_enabled
  public_network_access_enabled                   = var.public_network_access_enabled
  app_settings                               = var.app_settings
  tags                                       = var.tags

  # Managed identity configuration
  dynamic "identity" {
    for_each = var.identity_type != null ? [1] : []
    content {
      type = var.identity_type
    }
  }

  # Function app runtime and network configuration
  dynamic "site_config" {
    for_each = var.site_config != null ? [1] : []
    content {
      always_on                              = try(var.site_config.always_on, null)
      ftps_state                             = try(var.site_config.ftps_state, null)
      scm_type                               = try(var.site_config.scm_type, null)
      use_32_bit_worker                      = try(var.site_config.use_32_bit_worker, null)
      websockets_enabled                     = try(var.site_config.websockets_enabled, null)
      managed_pipeline_mode                  = try(var.site_config.managed_pipeline_mode, null)
      remote_debugging_enabled               = try(var.site_config.remote_debugging_enabled, null)
      ip_restriction_default_action          = var.ip_restriction_default_action
      scm_ip_restriction_default_action      = var.scm_ip_restriction_default_action
      application_insights_connection_string = var.application_insights_connection_string
      application_insights_key               = var.application_insights_key

      # Runtime stack configuration
      dynamic "application_stack" {
        for_each = try(var.site_config.stack, null) != null ? [1] : []
        content {
          dotnet_version = try(var.site_config.stack.dotnet_version, null)
        }
      }

      # IP-based access restrictions
      dynamic "ip_restriction" {
        for_each = var.ip_restriction
        content {
          name        = ip_restriction.key
          action      = ip_restriction.value.action
          priority    = ip_restriction.value.priority
          service_tag = try(ip_restriction.value.service_tag, null)
          ip_address  = try(ip_restriction.value.ip_address, null)
          description = try(ip_restriction.value.description, null)
        }
      }
    }
  }

  # Authentication configuration
  dynamic "auth_settings" {
    for_each = var.auth_settings != null ? [1] : []
    content {
      enabled          = try(var.auth_settings.enabled, false)
      default_provider = try(var.auth_settings.default_provider, null)
    }
  }

  # Slot-level sticky settings (non-swappable between deployment slots)
  dynamic "sticky_settings" {
    for_each = var.sticky_settings != null && (length(var.sticky_settings.app_setting_names) > 0 || length(var.sticky_settings.connection_string_names) > 0) ? [1] : []
    content {
      app_setting_names       = length(var.sticky_settings.app_setting_names) > 0 ? var.sticky_settings.app_setting_names : null
      connection_string_names = length(var.sticky_settings.connection_string_names) > 0 ? var.sticky_settings.connection_string_names : null
    }
  }
}

# Diagnostic settings for monitoring and logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each                   = var.diagnostic_settings != null ? { send_all_to_workspace = var.diagnostic_settings } : {}
  name                       = each.value.name
  target_resource_id         = azurerm_windows_function_app.this.id
  log_analytics_workspace_id = each.value.workspace_resource_id

  dynamic "enabled_log" {
    for_each = toset(coalesce(each.value.log_groups, ["allLogs"]))
    content {
      category_group = enabled_log.key
    }
  }

  dynamic "enabled_metric" {
    for_each = toset(coalesce(each.value.metric_categories, ["AllMetrics"]))
    content {
      category = enabled_metric.key
    }
  }
}