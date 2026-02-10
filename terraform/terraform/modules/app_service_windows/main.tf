resource "azurerm_windows_web_app" "this" {
  name                                           = var.name
  location                                       = var.location
  resource_group_name                            = var.resource_group_name
  service_plan_id                                = coalesce(var.service_plan_resource_id, var.service_plan_id)
  https_only                                     = coalesce(var.https_only, true)
  virtual_network_subnet_id                      = var.virtual_network_subnet_id
  public_network_access_enabled                  = var.public_network_access_enabled
  ftp_publish_basic_authentication_enabled       = var.ftp_publish_basic_authentication_enabled
  webdeploy_publish_basic_authentication_enabled = var.scm_publish_basic_authentication_enabled
  key_vault_reference_identity_id                = var.storage_key_vault_secret_id
  app_settings                                   = coalesce(var.app_settings, {})
  tags                                           = var.tags

  # Runtime, network, and security configuration
  dynamic "site_config" {
    for_each = var.site_config != null || var.minimum_tls_version != null || var.application_stack != null || var.cors != null || var.ip_restriction_default_action != null || var.scm_ip_restriction_default_action != null || length(var.ip_restriction) > 0 || length(var.scm_ip_restriction) > 0 ? [1] : []
    content {
      always_on                         = try(var.site_config.always_on, null)
      ftps_state                        = try(var.site_config.ftps_state, null)
      scm_type                          = try(var.site_config.scm_type, null)
      use_32_bit_worker                 = try(var.site_config.use_32_bit_worker, null)
      websockets_enabled                = try(var.site_config.websockets_enabled, null)
      managed_pipeline_mode             = try(var.site_config.managed_pipeline_mode, null)
      remote_debugging_enabled          = try(var.site_config.remote_debugging_enabled, null)
      minimum_tls_version               = coalesce(var.minimum_tls_version, try(var.site_config.minimum_tls_version, null))
      ip_restriction_default_action     = var.ip_restriction_default_action
      scm_ip_restriction_default_action = var.scm_ip_restriction_default_action

      # Runtime stack configuration
      dynamic "application_stack" {
        for_each = var.application_stack.dotnet_stack != null ? [var.application_stack.dotnet_stack] : (try(var.site_config.stack, null) != null ? [var.site_config.stack] : [])
        content {
          current_stack  = application_stack.value.current_stack
          dotnet_version = application_stack.value.dotnet_version
        }
      }

      # CORS configuration
      dynamic "cors" {
        for_each = var.cors != null ? [var.cors] : []
        content {
          allowed_origins     = cors.value.allowed_origins
          support_credentials = cors.value.support_credentials
        }
      }

      # IP-based access restrictions for main site
      dynamic "ip_restriction" {
        for_each = var.ip_restriction
        content {
          action                    = ip_restriction.value.action
          ip_address                = ip_restriction.value.ip_address
          name                      = ip_restriction.value.name
          priority                  = ip_restriction.value.priority
          service_tag               = ip_restriction.value.service_tag
          virtual_network_subnet_id = ip_restriction.value.virtual_network_subnet_id
          description               = ip_restriction.value.description

          # HTTP header-based filtering (Azure Front Door, etc.)
          dynamic "headers" {
            for_each = ip_restriction.value.headers != null && (
              length(coalesce(ip_restriction.value.headers.x_azure_fdid, [])) > 0 ||
              length(coalesce(ip_restriction.value.headers.x_fd_health_probe, [])) > 0 ||
              length(coalesce(ip_restriction.value.headers.x_forwarded_for, [])) > 0 ||
              length(coalesce(ip_restriction.value.headers.x_forwarded_host, [])) > 0
            ) ? [ip_restriction.value.headers] : []
            content {
              x_azure_fdid      = headers.value.x_azure_fdid
              x_fd_health_probe = headers.value.x_fd_health_probe
              x_forwarded_for   = headers.value.x_forwarded_for
              x_forwarded_host  = headers.value.x_forwarded_host
            }
          }
        }
      }

      # IP-based access restrictions for SCM site (Kudu)
      dynamic "scm_ip_restriction" {
        for_each = var.scm_ip_restriction
        content {
          action                    = scm_ip_restriction.value.action
          ip_address                = scm_ip_restriction.value.ip_address
          name                      = scm_ip_restriction.value.name
          priority                  = scm_ip_restriction.value.priority
          service_tag               = scm_ip_restriction.value.service_tag
          virtual_network_subnet_id = scm_ip_restriction.value.virtual_network_subnet_id
          description               = scm_ip_restriction.value.description

          dynamic "headers" {
            for_each = scm_ip_restriction.value.headers != null && (
              length(coalesce(scm_ip_restriction.value.headers.x_azure_fdid, [])) > 0 ||
              length(coalesce(scm_ip_restriction.value.headers.x_fd_health_probe, [])) > 0 ||
              length(coalesce(scm_ip_restriction.value.headers.x_forwarded_for, [])) > 0 ||
              length(coalesce(scm_ip_restriction.value.headers.x_forwarded_host, [])) > 0
            ) ? [scm_ip_restriction.value.headers] : []
            content {
              x_azure_fdid      = headers.value.x_azure_fdid
              x_fd_health_probe = headers.value.x_fd_health_probe
              x_forwarded_for   = headers.value.x_forwarded_for
              x_forwarded_host  = headers.value.x_forwarded_host
            }
          }
        }
      }
    }
  }

  # Managed identity configuration
  dynamic "identity" {
    for_each = local.managed_identities.system_assigned || length(local.managed_identities.user_assigned_resource_ids) > 0 ? [1] : []
    content {
      type         = local.managed_identities.system_assigned && length(local.managed_identities.user_assigned_resource_ids) > 0 ? "SystemAssigned, UserAssigned" : local.managed_identities.system_assigned ? "SystemAssigned" : "UserAssigned"
      identity_ids = length(local.managed_identities.user_assigned_resource_ids) > 0 ? local.managed_identities.user_assigned_resource_ids : null
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

  # Authentication configuration
  dynamic "auth_settings" {
    for_each = var.auth_settings != null ? [1] : []
    content {
      enabled          = var.auth_settings.enabled
      default_provider = var.auth_settings.default_provider

      dynamic "active_directory" {
        for_each = var.auth_settings.active_directory != null ? [1] : []
        content {
          client_id         = var.auth_settings.active_directory.client_id
          client_secret     = var.auth_settings.active_directory.client_secret
          allowed_audiences = var.auth_settings.active_directory.allowed_audiences
        }
      }
    }
  }
}

# Diagnostic settings for monitoring and logging
resource "azurerm_monitor_diagnostic_setting" "this" {
  for_each                   = var.diagnostic_settings != null ? { send_all_to_workspace = var.diagnostic_settings } : {}
  name                       = coalesce(each.value.name, "${var.name}-diagnostic")
  target_resource_id         = azurerm_windows_web_app.this.id
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