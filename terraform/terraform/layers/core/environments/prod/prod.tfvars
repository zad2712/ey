######################
### SHARED DATA ######
######################
resource_group_name_admin = "USEPEYXP01RSG01"
resource_group_name_app   = "USEPEYXP01RSG04"

vnet_admin_name_01   = "USEPEYXP01VNT01" # admin vnet
subnet_admin_name_01 = "USEPEYXP01SBN02" # Admin Subnet
vnet_app_name_01     = "USEPEYXP01VNT06" # frontend vnet
subnet_app_name_01   = "USEPEYXP01SBN15"
subnet_app_name_02   = "USEPEYXP01SBN16"
subnet_app_name_03   = "USEPEYXP01SBN17"
vnet_app_name_02     = "USEPEYXP01VNT07" # Backend VNet
subnet1_name_app_02  = "USEPEYXP01SBN18" # Backend Subnet1 /27
subnet2_name_app_02  = "USEPEYXP01SBN19" # Backend Subnet2 /27
subnet3_name_app_02  = "USEPEYXP01SBN20" # Backend Subnet3 /27

################
### GENERAL ####
################
env = "PROD"

tags = {
  DEPLOYMENT_ID = "EYXP01"
  ENGAGEMENT_ID = "I-69197406"
  OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT   = "Production"
}

#######################
### RESOURCE GROUP ####
#######################
resource_group_name = "USEPEYXP01RSG04"
location            = "East US"
resource_group_tags = {
  "hidden-title" = "EYX - Prod - App",
  "ROLE_PURPOSE" = "EYX - Prod - App"

}


################################
### LOG ANALYTICS WORKSPACE ####
################################
log_analytics_workspace_name = "USEPEYXP01LAW04"
log_analytics_workspace_tags = {
  "hidden-title" = "EYX - Prod - App LAW",
  "ROLE_PURPOSE" = "EYX - Prod - App LAW"
}

##################
### KEY VAULT ####
##################
key_vault_name = "USEPEYXP01AKV04"

key_vault_tags = {
  "hidden-title" = "EYX - Prod - App Key Vault",
  "ROLE_PURPOSE" = "EYX - Prod - App Key Vault"
}

# Key Vault Legacy Access Policies
# These policies exist in Azure and are synced here to prevent destruction
# PROD-specific: These 7 policies are managed outside Terraform and must be preserved
key_vault_legacy_access_policies = {
  admin-managed-identity = {
    object_id               = "178406d5-79cb-4e17-86b6-ad040bb7092c"
    key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "GetRotationPolicy", "SetRotationPolicy", "Rotate", "Encrypt", "Decrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release"]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
    certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
    storage_permissions     = []
  }
  # Synced from existing Azure config - DO NOT REMOVE
  ctp-platform-policy = {
    object_id               = "169fd54b-fc21-4d6b-bd45-667c3e45395f"
    key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "GetRotationPolicy", "SetRotationPolicy", "Rotate", "Encrypt", "Decrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release"]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
    certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
    storage_permissions     = []
  }
  # Synced from existing Azure config - DO NOT REMOVE
  eyx-dev-team-policy = {
    object_id               = "42d654d5-f215-497e-a7c9-3c5a6f3f7574"
    key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "GetRotationPolicy", "SetRotationPolicy", "Rotate", "Encrypt", "Decrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release"]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
    certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
    storage_permissions     = []
  }
  # Synced from existing Azure config - DO NOT REMOVE
  eyx-devops-team-policy = {
    object_id               = "c679f898-da3f-412f-b15f-1a37dad5ec42"
    key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "GetRotationPolicy", "SetRotationPolicy", "Rotate", "Encrypt", "Decrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release"]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
    certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
    storage_permissions     = []
  }
  # Synced from existing Azure config - DO NOT REMOVE
  sp-p-policy = {
    object_id               = "2a0c04e4-9e36-4da9-a502-ddd49bef7edc"
    key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "GetRotationPolicy", "SetRotationPolicy", "Rotate", "Encrypt", "Decrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release"]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
    certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
    storage_permissions     = []
  }
  # Synced from existing Azure config - DO NOT REMOVE
  tax-dev-team-policy = {
    object_id               = "4671d2ff-b7c5-4e0f-8432-aae35707e1b2"
    key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "GetRotationPolicy", "SetRotationPolicy", "Rotate", "Encrypt", "Decrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release"]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
    certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
    storage_permissions     = []
  }
  # Synced from existing Azure config - DO NOT REMOVE
  taxadmin-team-policy = {
    object_id               = "042d637f-a83b-4f59-a34c-e556aa2a7840"
    key_permissions         = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "GetRotationPolicy", "SetRotationPolicy", "Rotate", "Encrypt", "Decrypt", "UnwrapKey", "WrapKey", "Verify", "Sign", "Purge", "Release"]
    secret_permissions      = ["Get", "List", "Set", "Delete", "Recover", "Backup", "Restore", "Purge"]
    certificate_permissions = ["Get", "List", "Update", "Create", "Import", "Delete", "Recover", "Backup", "Restore", "ManageContacts", "ManageIssuers", "GetIssuers", "ListIssuers", "SetIssuers", "DeleteIssuers", "Purge"]
    storage_permissions     = []
  }
}

key_vault_enabled_for_template_deployment = true
enabled_for_deployment                    = true
enabled_for_disk_encryption               = true
key_vault_public_network_access_enabled   = true

key_vault_diagnostic_settings = {
  kv_diag = {
    name                  = "kv-logs"
    workspace_resource_id = null
    log_categories        = ["AuditEvent"]
    metric_categories     = ["AllMetrics"]
    retention_days        = 365
  }
}

########################
#### App Insights #####
########################

app_insights_name = "USEPEYXP01AAI03"

################################
######## AZURE WORKBOOK ########
################################
workbook_display_name = "EYX Dashboard Workbook Prod"
workbook_tags = {
  "ROLE_PURPOSE" = "EYX - Prod - Workbook"
}


####################################
######## AZURE Resource Lock #######
####################################
create_delete_lock = true

# User Assigned Identity Configuration
user_assigned_identity_name = "USEPEYXP01UMI03"
user_assigned_identity_tags = {
  "hidden-title" = "EYX - Prod - User Assigned Identity"
  "ROLE_PURPOSE" = "EYX - Prod - User Assigned Identity"
}

# RBAC Assignments Configuration
enable_default_role_assignments = true
resource_group_role_assignments = {}