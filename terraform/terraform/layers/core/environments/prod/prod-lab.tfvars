######################
### SHARED DATA ######
######################
resource_group_name_admin = "USEPEYXP01RSG01"
resource_group_name_app   = "USEPEYXP01RSG02"

vnet_admin_name_01   = "USEPEYXP01VNT01" # Admin VNET
subnet_admin_name_01 = "USEPEYXP01SBN02" # Admin Subnet
vnet_app_name_01     = "USEPEYXP01VNT02" # Frontend VNET
subnet_app_name_01   = "USEPEYXP01SBN03"
subnet_app_name_02   = "USEPEYXP01SBN04"
subnet_app_name_03   = "USEPEYXP01SBN05"
vnet_app_name_02     = "USEPEYXP01VNT03" # Backend VNet
subnet1_name_app_02  = "USEPEYXP01SBN06" # Backend Subnet1 /27
subnet2_name_app_02  = "USEPEYXP01SBN07" # Backend Subnet2 /27
subnet3_name_app_02  = "USEPEYXP01SBN08" # Backend Subnet3 /27

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
resource_group_name = "USEPEYXP01RSG02"
location            = "East US"
resource_group_tags = {
  "hidden-title" = "EYX - Prod-Lab - App",
  "ROLE_PURPOSE" = "EYX - Prod-Lab - App"
}


################################
### LOG ANALYTICS WORKSPACE ####
################################
log_analytics_workspace_name = "USEPEYXP01LAW02"
log_analytics_workspace_tags = {
  "hidden-title" = "EYX - Prod-Lab - App LAW",
  "ROLE_PURPOSE" = "EYX - Prod-Lab - App LAW"
}

##################
### KEY VAULT ####
##################
key_vault_name = "USEPEYXP01AKV02"

key_vault_tags = {
  "hidden-title" = "EYX - Prod-Lab - App Key Vault",
  "ROLE_PURPOSE" = "EYX - Prod-Lab - App Key Vault"
}

### IMPORTANT: The following access policies are being synced from existing Azure resources in PROD environments.
### These policies were manually configured in Azure and now being imported into Terraform for management.
### They are specific to PROD environments (Prod-Lab, Prod-Pilot, Prod-Prod) and may not exist in UAT/QA/DEV.
key_vault_legacy_access_policies = {
  "admin-managed-identity" = { # Managed Identity permissions used by CI/CD Pipelines
    object_id          = "178406d5-79cb-4e17-86b6-ad040bb7092c"
    secret_permissions = ["Get", "List", "Set"]
  }
  "ctp-platform-policy" = { # EY Fabric Cloud Environments Automation - Synced from existing Azure config
    object_id          = "169fd54b-fc21-4d6b-bd45-667c3e45395f"
    secret_permissions = ["List", "Set"]
  }
  "eyx-dev-team-policy" = { # EYX Dev Team - Synced from existing Azure config
    object_id          = "42d654d5-f215-497e-a7c9-3c5a6f3f7574"
    secret_permissions = ["Get", "List", "Set"]
  }
  "eyx-devops-team-policy" = { # EYX DevOps Team - Synced from existing Azure config
    object_id               = "c679f898-da3f-412f-b15f-1a37dad5ec42"
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Set"]
    certificate_permissions = ["Backup", "Create", "Get", "Import", "List", "Update"]
  }
  "sp-p-policy" = { # EY Fabric Certificate Automation - Synced from existing Azure config
    object_id               = "2a0c04e4-9e36-4da9-a502-ddd49bef7edc"
    secret_permissions      = ["Get", "Set"]
    certificate_permissions = ["Import"]
  }
  "tax-dev-team-policy" = { # Tax Dev Team - Synced from existing Azure config
    object_id          = "4671d2ff-b7c5-4e0f-8432-aae35707e1b2"
    secret_permissions = ["Get", "List", "Set"]
  }
  "taxadmin-team-policy" = { # Tax Admin Team - Synced from existing Azure config
    object_id          = "042d637f-a83b-4f59-a34c-e556aa2a7840"
    secret_permissions = ["Get", "List", "Set"]
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

app_insights_name = "USEPEYXP01AAI01"

################################
######## AZURE WORKBOOK ########
################################
workbook_display_name = "EYX Dashboard Workbook Prod-LAB"
workbook_tags = {
  "ROLE_PURPOSE" = "EYX - Prod-LAB - Workbook"
}


####################################
######## AZURE Resource Lock #######
####################################

create_delete_lock = true

################################################
######## User Assigned Identity ################
################################################
# NOTE: Syncing with existing Azure resource USEPEYXP01UMI01 (not UMI11 as in other envs)
# This identity already exists in Azure for PROD-Lab and is being preserved.
user_assigned_identity_name = "USEPEYXP01UMI01"

user_assigned_identity_tags = {
  "hidden-title" = "EYX - Prod-Lab - User Assigned Identity",
  "ROLE_PURPOSE" = "EYX - Prod-Lab - User Assigned Identity"
}

##########################
#### RBAC ASSIGNMENTS ####
##########################
##### Role assignments exist in Azure - keep them synced with IaC
enable_default_role_assignments = true
resource_group_role_assignments = {}