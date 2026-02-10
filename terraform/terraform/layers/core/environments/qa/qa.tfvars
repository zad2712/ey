################
### GENERAL ####
################
env = "QA"

tags = {
  DEPLOYMENT_ID = "CXS05H"
  ENGAGEMENT_ID = "I-68403024"
  OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT   = "QA"
}

######################
### SHARED DATA ######
######################
resource_group_name_admin = "USEQCXS05HRSG02"
resource_group_name_app   = "USEQCXS05HRSG03"

vnet_admin_name_01   = "USEQCXS05HVNT01" # Admin VNET
subnet_admin_name_01 = "USEQCXS05HSBN01" # GitHub Runner Subnet (corrected)
vnet_app_name_01     = "USEQCXS05HVNT02" # Frontend VNET
subnet_app_name_01   = "USEQCXS05HSBN03"
subnet_app_name_02   = "USEQCXS05HSBN04"
subnet_app_name_03   = "USEQCXS05HSBN05"
vnet_app_name_02     = "USEQCXS05HVNT03" # Backend VNET
subnet1_name_app_02  = "USEQCXS05HSBN06" # Backend Subnet1
subnet2_name_app_02  = "USEQCXS05HSBN07" # Backend Subnet2
subnet3_name_app_02  = "USEQCXS05HSBN08" # Backend Subnet3

#######################
### RESOURCE GROUP ####
#######################
resource_group_name = "USEQCXS05HRSG03"
location            = "East US"
resource_group_tags = {
  "hidden-title"   = "EYX - App - QA"
  "BUILDING_BLOCK" = "resource-group-V2.0.1"
  "CTP_SERVICE"    = "Co-Dev"
  "PRODUCT_APP"    = "EYX - Agent Framework"
  "TOWER_JOB_ID"   = "5670085"
}


################################
### LOG ANALYTICS WORKSPACE ####
################################
log_analytics_workspace_name = "USEQCXS05HLAW02"
log_analytics_workspace_tags = {
  "hidden-title"         = "EYX - QA - Main App LAW"
  "BUILDING_BLOCK"       = "azure-log-analytics-V3.0.1"
  "ENABLECOREMONITORING" = "Yes"
  "MONITORINGVERSION"    = "1.0.0"
  "ROLE_PURPOSE"         = "Azure Log Analytics Workspaces"
  "TOWER_JOB_ID"         = "5674178"
}

##################
### KEY VAULT ####
##################
key_vault_name = "USEQCXS05HAKV02"

key_vault_tags = {
  "hidden-title"   = "EYX - QA - App Key Vault"
  "BUILDING_BLOCK" = "key-vault-V2.1.0"
  "ROLE_PURPOSE"   = "Azure KeyVault"
  "TOWER_JOB_ID"   = "5670085"
}

key_vault_legacy_access_policies = {
  "admin-managed-identity" = { # Managed Identity permissions used by CI/CD Pipelines
    object_id          = "409a86aa-8581-4f77-bd38-086b32fc2f03"
    secret_permissions = ["Get", "List", "Set"]
  }
}

key_vault_enabled_for_template_deployment = true
enabled_for_deployment                    = true
enabled_for_disk_encryption               = true
key_vault_public_network_access_enabled   = true

### Resource Group RBAC Role Assignments #####
##############################################
##### QA environment - Preserve existing RBAC configurations only.
##### Default role assignments (Tax Dev, EYX Dev, Tax Admin, DevOps) are disabled to avoid creating new role assignments.
##### These roles don't exist in QA Azure environment and we want to keep it as-is without breaking changes.
##### To enable default role assignments in the future, set enable_default_role_assignments = true
enable_default_role_assignments = false
resource_group_role_assignments = {}

###############################
### USER ASSIGNED IDENTITY ####
###############################
# Required for QA environment as Skills Plugins are deployed here.
# Skills Plugins use ACA to pull images from ACR via Managed Identity.
user_assigned_identity_name = "USEQCXS05HUMI03"
user_assigned_identity_tags = {
  "hidden-title"  = "EYX - QA - User Assigned Identity"
  "ENGAGEMENT_ID" = "I-68403024"
  "ENVIRONMENT"   = "QA"
}

##########################
### APPLICATION INSIGHTS ###
##########################
app_insights_name                = "USEQCXS05HAAI01"
app_insights_sampling_percentage = 100
app_insights_tags = {
  "hidden-title" = "EYX - QA - App Insights"
  "CTP_SERVICE"  = "Co-Dev"
  "PRODUCT_APP"  = "EYX - Agent Framework"
  "TF_LAYER"     = "app"
}

workbook_display_name = "EYX Dashboard Workbook QA"
workbook_tags = {
  "DEPLOYMENT_ID" = "EYXU01"
  "ENGAGEMENT_ID" = "I-69197406"
  "ENVIRONMENT"   = "QA"
  "ROLE_PURPOSE"  = "EYX - QA - Workbook"
}
