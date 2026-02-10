resource "azurerm_container_app_environment" "cae" {
  name                       = var.cae_name
  location                   = var.location
  resource_group_name        = var.resource_group_name
  logs_destination           = var.logs_destination
  log_analytics_workspace_id = var.log_analytics_workspace_id
  tags                       = var.tags
  infrastructure_resource_group_name = "ME_${var.cae_name}_${var.resource_group_name}_${lower(var.location)}"
  infrastructure_subnet_id   = var.cae_infrastructure_subnet_id
  public_network_access = var.public_network_access_enabled 
  # Workload profiles are required for session pools
  dynamic "workload_profile" {
    for_each = var.workload_profile_enabled ? var.workload_profiles : []
    content {
      name                  = workload_profile.value.name
      workload_profile_type = workload_profile.value.workload_profile_type
      minimum_count         = workload_profile.value.minimum_count
      maximum_count         = workload_profile.value.maximum_count
    }
  }
  
  dynamic "identity" {
    for_each = [1]
    content {
      # Activate UserAssigned and add identity_ids, otherwise Terraform will not deploy the infrastructure
      type         = "SystemAssigned" #, UserAssigned"
      # identity_ids = []
    }
  }

  lifecycle {
    # There's a known issue where changes to workload profiles cause unnecessary recreations
    # https://github.com/hashicorp/terraform-provider-azurerm/pull/30139
    # Ignore user assigned identity_ids as they are managed outside Terraform
    # Using ignore_changes on the entire identity block to prevent conflicts with externally managed identities
    ignore_changes = [
      workload_profile,
      identity
    ]
  }
}

  # resource "azurerm_monitor_diagnostic_setting" "cae" {
  # count                      = var.log_analytics_workspace_id != null ? 1 : 0
  # name                       = "${azurerm_container_app_environment.cae.name}-diagnostic"
  # target_resource_id         = azurerm_container_app_environment.cae.id
  # log_analytics_workspace_id = var.log_analytics_workspace_id

  # enabled_log {
  #   # category = "GatewayLogs"
  #   category = "AuditEvent"
  # }

# }

