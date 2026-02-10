locals {
  # Get app insights-workspace.resource.id
  effective_workspace_id = coalesce(
    try(var.key_vault_diagnostic_settings.kv_diag.workspace_resource_id, null),
    module.core.log_analytics_workspace_id
  )
  key_vault_diagnostic_settings = {
    kv_diag = {
      name                  = try(var.key_vault_diagnostic_settings.kv_diag.name, "kv-logs")
      workspace_resource_id = local.effective_workspace_id
      log_categories        = try(var.key_vault_diagnostic_settings.kv_diag.log_categories, ["AuditEvent"])
      metric_categories     = try(var.key_vault_diagnostic_settings.kv_diag.metric_categories, ["AllMetrics"])
      retention_days        = try(var.key_vault_diagnostic_settings.kv_diag.retention_days, 365)
    }
  }

  # Key Vault Network ACLs Configuration
  # Priority: Use tfvars configuration, fallback to shared_data module for environments with shared resources
  # This supports both patterns:
  # 1. Environments with network_acls defined in tfvars (simpler, recommended)
  # 2. Environments using shared_data module variables (legacy pattern for UAT/Prod)

  # Build subnet IDs from shared_data module when available
  shared_data_subnet_ids = compact([
    try(module.shared_data.admin_subnet1_id, null),
    try(module.shared_data.subnet_app_shared_name_01.id, null),
    try(module.shared_data.subnet_app_shared_name_02.id, null),
    try(module.shared_data.subnet_app_shared_name_03.id, null),
    try(module.shared_data.subnet1_app_shared_id_app_02, null),
    try(module.shared_data.subnet2_app_shared_id_app_02, null),
    try(module.shared_data.subnet3_app_shared_id_app_02, null)
  ])

  # Use tfvars config if virtual_network_subnet_ids is non-empty, otherwise use shared_data module
  use_tfvars_network_acls = length(try(var.key_vault_network_acls.virtual_network_subnet_ids, [])) > 0

  key_vault_network_acls_final = {
    bypass                     = try(var.key_vault_network_acls.bypass, "AzureServices")
    default_action             = try(var.key_vault_network_acls.default_action, "Deny")
    ip_rules                   = try(var.key_vault_network_acls.ip_rules, [])
    virtual_network_subnet_ids = local.use_tfvars_network_acls ? var.key_vault_network_acls.virtual_network_subnet_ids : local.shared_data_subnet_ids
  }

  ## Default RSG role assignments for various environments
  # Tax Developers
  taxdev_role_assignments = {
    "taxdev_reader" = {
      role_definition_id_or_name = "Reader"
      principal_id               = "4671d2ff-b7c5-4e0f-8432-aae35707e1b2"

    },
    "taxdev_monitoring" = {
      role_definition_id_or_name = "Monitoring Reader"
      principal_id               = "4671d2ff-b7c5-4e0f-8432-aae35707e1b2"

    },
    "taxdev_storage_blob_data_reader" = {
      role_definition_id_or_name = "Storage Blob Data Reader"
      principal_id               = "4671d2ff-b7c5-4e0f-8432-aae35707e1b2"
    },
    "taxdev_cosmosdb_reader" = {
      role_definition_id_or_name = "Cosmos DB Account Reader Role"
      principal_id               = "4671d2ff-b7c5-4e0f-8432-aae35707e1b2"
    }
  }
  # EYX Developers
  eyxdev_role_assignments = {
    "eyxdev_reader" = {
      role_definition_id_or_name = "Reader"
      principal_id               = "42d654d5-f215-497e-a7c9-3c5a6f3f7574"

    },
    "eyxdev_monitoring" = {
      role_definition_id_or_name = "Monitoring Reader"
      principal_id               = "42d654d5-f215-497e-a7c9-3c5a6f3f7574"

    },
    "eyxdev_storage_blob_data_reader" = {
      role_definition_id_or_name = "Storage Blob Data Reader"
      principal_id               = "42d654d5-f215-497e-a7c9-3c5a6f3f7574"
    },
    "eyxdev_cosmosdb_reader" = {
      role_definition_id_or_name = "Cosmos DB Account Reader Role"
      principal_id               = "42d654d5-f215-497e-a7c9-3c5a6f3f7574"
    }
  }
  # Tax Admins
  taxadmin_role_assignments = {
    "taxadmin_owner" = {
      role_definition_id_or_name = "Owner"
      principal_id               = "042d637f-a83b-4f59-a34c-e556aa2a7840"

    },
  }
  devops_role_assignments = {
    "eyxdevops_owners" = {
      role_definition_id_or_name = "Owner"
      principal_id               = "c679f898-da3f-412f-b15f-1a37dad5ec42"
    }
  }
  # Default Resource Group Role Assignments
  # These role assignments are applied by default to Dev environments.
  # For QA and higher environments, these are conditionally excluded to preserve existing RBAC configurations.
  # Set var.enable_default_role_assignments = true in tfvars to enable these role assignments if needed in the future.
  default_role_assignments = var.enable_default_role_assignments ? merge(
    local.taxdev_role_assignments,
    local.eyxdev_role_assignments,
    local.taxadmin_role_assignments,
    local.devops_role_assignments
  ) : {}
  # Azure Key Vault Default Role Assignments
  key_vault_legacy_access_policies = { # 
    "sp-p-policy" = {                  # EY Fabric Certificate Automation
      object_id               = "2a0c04e4-9e36-4da9-a502-ddd49bef7edc"
      certificate_permissions = ["Import"]
      secret_permissions      = ["Get", "Set"]
    }
    "ctp-platform-policy" = { # EY Fabric Cloud Environments Automation
      object_id          = "169fd54b-fc21-4d6b-bd45-667c3e45395f"
      secret_permissions = ["List", "Set"]
    }
    "tax-dev-team-policy" = { # Tax Developers
      object_id          = "4671d2ff-b7c5-4e0f-8432-aae35707e1b2"
      secret_permissions = ["Get", "List", "Set"]
    }
    "eyx-dev-team-policy" = { # Tax Developers
      object_id          = "42d654d5-f215-497e-a7c9-3c5a6f3f7574"
      secret_permissions = ["Get", "List", "Set"]
    }
    "eyx-devops-team-policy" = { # Tax Developers
      object_id               = "c679f898-da3f-412f-b15f-1a37dad5ec42"
      secret_permissions      = ["List", "Set", "Get", "Delete", "Purge", "Recover", "Backup"]
      certificate_permissions = ["Get", "List", "Update", "Backup", "Import", "Create"]
    }
    "taxadmin-team-policy" = { # Tax Developers
      object_id          = "042d637f-a83b-4f59-a34c-e556aa2a7840"
      secret_permissions = ["Get", "List", "Set"]
    }
  }

  # Log Analytics Workspace   
  log_analytics_workspace_retention_in_days = 365
}

# locals {
#   _env_upper = upper(lookup(var.tags, var.environment_tag_key, ""))
#   # consider 'UAT' exact or any variant containing 'PROD' (e.g., 'Production')
#   _create_delete_lock_for_env = var.create_delete_lock && (local._env_upper == "UAT" || contains(local._env_upper, "PROD"))
#   _delete_lock_name = var.delete_lock_name != null ? var.delete_lock_name : "${var.resource_group_name}-delete-lock"
# }
  