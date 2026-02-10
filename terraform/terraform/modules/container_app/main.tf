resource "azurerm_container_app" "ca" {
  name                         = var.container_app_name
  resource_group_name          = var.resource_group_name
  container_app_environment_id = var.container_app_environment_id
  revision_mode                = "Single"
  tags                         = var.tags
  workload_profile_name        = "Consumption"

  # Static ignore list (Terraform requires literal values here, not a variable).
  # Adjust as needed to narrow scope and reduce risk of masking unintended changes.
  lifecycle {
    ignore_changes = [
      ingress,
      template,
      max_inactive_revisions,
      registry,  # Ignore registry configuration managed outside Terraform (e.g., deployment pipelines)
      identity   # Ignore user assigned identity_ids as they are managed outside Terraform
    ]
  }

  template {
    container {
      name   = var.container_name
      image  = var.container_image
      cpu    = var.container_cpu
      memory = var.container_memory
    }
  }
  
  identity {
    # Activate UserAssigned and add identity_ids, otherwise Terraform will not deploy the infrastructure
    type         = "SystemAssigned" #, UserAssigned"
    #identity_ids = []
  }
}

resource "azurerm_monitor_diagnostic_setting" "container_app_diagnostic" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.container_app_name}-diagnostic"
  target_resource_id         = azurerm_container_app.ca.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "ContainerAppSystemLogs"
  }

  enabled_log {
    category = "ContainerAppConsoleLogs"
  }

  enabled_metric {
    category = "AllMetrics"
  }
}