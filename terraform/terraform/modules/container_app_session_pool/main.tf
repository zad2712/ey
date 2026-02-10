# Get current Azure client configuration
data "azurerm_client_config" "current" {}

locals {
  create_pool = var.enabled
}

# Deploy the Container App Session Pool using ARM template
resource "azurerm_resource_group_template_deployment" "session_pool" {
  count               = local.create_pool ? 1 : 0
  name                = "sessionpool-deployment-${substr(md5(var.session_pool_name), 0, 8)}"
  resource_group_name = var.resource_group_name
  deployment_mode     = "Incremental"
  
  template_content = jsonencode({
    "$schema"      = "https://schema.management.azure.com/schemas/2019-04-01/deploymentTemplate.json#"
    contentVersion = "1.0.0.0"
    parameters = {
      sessionPoolName = {
        type = "String"
      }
      location = {
        type = "String"
      }
      environmentId = {
        type = "String"
      }
      containerImage = {
        type = "String"
        defaultValue = ""
      }
      containerName = {
        type = "String"
        defaultValue = ""
      }
      containerCpu = {
        type = "String"
        defaultValue = "0.25"
      }
      containerMemory = {
        type = "String"
        defaultValue = "0.5Gi"
      }
      maxConcurrentSessions = {
        type = "Int"
      }
      readySessionInstances = {
        type = "Int"
      }
      cooldownPeriodInSeconds = {
        type = "Int"
      }
      targetPort = {
        type = "Int"
        defaultValue = 80
      }
      networkStatus = {
        type = "String"
        allowedValues = ["EgressEnabled", "EgressDisabled"]
      }
      containerType = {
        type = "String"
        allowedValues = ["PythonLTS", "CustomContainer"]
      }
    }
    resources = [
      {
        type       = "Microsoft.App/sessionPools"
        apiVersion = "2024-02-02-preview"
        name       = "[parameters('sessionPoolName')]"
        location   = "[parameters('location')]"
        properties = {
          environmentId      = "[parameters('environmentId')]"
          poolManagementType = "Dynamic"
          containerType      = "[parameters('containerType')]"
          scaleConfiguration = {
            maxConcurrentSessions = "[parameters('maxConcurrentSessions')]"
            readySessionInstances = "[parameters('readySessionInstances')]"
          }
          dynamicPoolConfiguration = {
            executionType           = "Timed"
            cooldownPeriodInSeconds = "[parameters('cooldownPeriodInSeconds')]"
          }
          sessionNetworkConfiguration = {
            status = "[parameters('networkStatus')]"
          }
          container = "[if(equals(parameters('containerType'), 'CustomContainer'), json(concat('{\"name\":\"', parameters('containerName'), '\",\"image\":\"', parameters('containerImage'), '\",\"resources\":{\"cpu\":', parameters('containerCpu'), ',\"memory\":\"', parameters('containerMemory'), '\"},\"targetPort\":', string(parameters('targetPort')), '}')), json('null'))]"
        }
      }
    ]
    outputs = {
      sessionPoolId = {
        type  = "String"
        value = "[resourceId('Microsoft.App/sessionPools', parameters('sessionPoolName'))]"
      }
      poolManagementEndpoint = {
        type  = "String"
        value = "[reference(resourceId('Microsoft.App/sessionPools', parameters('sessionPoolName'))).poolManagementEndpoint]"
      }
      sessionPoolName = {
        type  = "String"
        value = "[parameters('sessionPoolName')]"
      }
    }
  })
  
  # Pass parameters to the ARM template
  parameters_content = jsonencode({
    sessionPoolName = {
      value = var.session_pool_name
    }
    location = {
      value = var.location
    }
    environmentId = {
      value = var.container_app_environment_id
    }
    maxConcurrentSessions = {
      value = var.max_concurrent_sessions
    }
    readySessionInstances = {
      value = var.ready_session_instances
    }
    cooldownPeriodInSeconds = {
      value = var.cooldown_period_seconds
    }
    networkStatus = {
      value = var.network_status
    }
    containerType = {
      value = var.container_type
    }
    # For PythonLTS, these won't be used but ARM template expects them with defaults
    containerImage = {
      value = var.container_type == "CustomContainer" ? var.container_image : ""
    }
    containerName = {
      value = var.container_type == "CustomContainer" ? var.container_name : ""
    }
    containerCpu = {
      value = var.container_type == "CustomContainer" ? tostring(var.container_cpu) : "0.25"
    }
    containerMemory = {
      value = var.container_type == "CustomContainer" ? var.container_memory : "0.5Gi"
    }
    targetPort = {
      value = var.container_type == "CustomContainer" ? var.target_port : 80
    }
  })

  tags = var.tags
}

# Diagnostic settings for the session pool
resource "azurerm_monitor_diagnostic_setting" "session_pool_diagnostic" {
  count                      = local.create_pool && var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${var.session_pool_name}-diagnostic"
  target_resource_id         = jsondecode(azurerm_resource_group_template_deployment.session_pool[0].output_content)["sessionPoolId"]["value"]
  log_analytics_workspace_id = var.log_analytics_workspace_id

  # Session pools may have different log categories than regular container apps
  # For now, just enable metrics until we determine supported log categories
  enabled_metric {
    category = "Customer Container Session Pool"
  }
}

# Get the session pool ID from ARM template deployment output
locals {
  session_pool_id = local.create_pool ? try(
    jsondecode(azurerm_resource_group_template_deployment.session_pool[0].output_content)["sessionPoolId"]["value"],
    null
  ) : null
  
  # Filter out any principals with null/empty principal_id
  valid_role_principals = local.create_pool && var.enable_default_roles ? [
    for principal in var.default_role_principals :
    principal if try(length(trimspace(principal.principal_id)) > 0, false)
  ] : []
  
  # Calculate role assignment count once to avoid duplication
  role_assignments_count = local.create_pool && var.enable_default_roles && local.session_pool_id != null ? length(local.valid_role_principals) : 0
}

# Role assignments for Container Apps Sessions Executor
resource "azurerm_role_assignment" "sessions_executor" {
  count                = local.role_assignments_count
  scope                = local.session_pool_id
  role_definition_name = "Azure ContainerApps Session Executor"
 
  principal_id   = local.valid_role_principals[count.index].principal_id
  principal_type = try(local.valid_role_principals[count.index].principal_type, "ServicePrincipal")

  depends_on = [azurerm_resource_group_template_deployment.session_pool]
}

# Role assignments for Container Apps SessionPools Contributor  
resource "azurerm_role_assignment" "sessionpools_contributor" {
  count                = local.role_assignments_count
  scope                = local.session_pool_id
  role_definition_name = "Container Apps SessionPools Contributor"
 
  principal_id       = local.valid_role_principals[count.index].principal_id
  principal_type     = try(local.valid_role_principals[count.index].principal_type, "ServicePrincipal")

  depends_on = [azurerm_resource_group_template_deployment.session_pool]
}

# Custom role assignments
resource "azurerm_role_assignment" "custom" {
  count                = local.create_pool ? length(var.role_assignments) : 0
  scope                = jsondecode(azurerm_resource_group_template_deployment.session_pool[0].output_content)["sessionPoolId"]["value"]
  role_definition_name = var.role_assignments[count.index].role_name
  principal_id         = var.role_assignments[count.index].principal_id
}
