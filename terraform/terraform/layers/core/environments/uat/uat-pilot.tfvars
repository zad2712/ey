######################
### SHARED DATA ######
######################
resource_group_name_admin = "USEUEYXU01RSG01"
resource_group_name_app   = "USEUEYXU01RSG03"

vnet_admin_name_01   = "USEUEYXU01VNT01" # Admin VNET
subnet_admin_name_01 = "USEUEYXU01SBN02" # Admin Subnet
vnet_app_name_01     = "USEUEYXU01VNT04" # Frontend VNET
subnet_app_name_01   = "USEUEYXU01SBN09"
subnet_app_name_02   = "USEUEYXU01SBN10"
subnet_app_name_03   = "USEUEYXU01SBN11"
vnet_app_name_02     = "USEUEYXU01VNT05" # Backend VNET
subnet1_name_app_02  = "USEUEYXU01SBN12" # Backend Subnet1 /27
subnet2_name_app_02  = "USEUEYXU01SBN13" # Backend Subnet2 /27
subnet3_name_app_02  = "USEUEYXU01SBN14" # Backend Subnet3 /27

################
### GENERAL ####
################
env = "UAT"

tags = {
  DEPLOYMENT_ID = "EYXU01"
  ENGAGEMENT_ID = "I-69197406"
  OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT   = "UAT"
}

#######################
### RESOURCE GROUP ####
#######################
resource_group_name = "USEUEYXU01RSG03"
location            = "East US"
resource_group_tags = {
  "hidden-title" = "EYX - UAT-Pilot - App",
  "ROLE_PURPOSE" = "EYX - UAT-Pilot - App"
}


################################
### LOG ANALYTICS WORKSPACE ####
################################
log_analytics_workspace_name = "USEUEYXU01LAW03"
log_analytics_workspace_tags = {
  "hidden-title" = "EYX - UAT-Pilot - App LAW",
  "ROLE_PURPOSE" = "EYX - UAT-Pilot - App LAW"
}

##################
### KEY VAULT ####
##################
key_vault_name = "USEUEYXU01AKV03"

key_vault_tags = {
  "hidden-title" = "EYX - UAT-Pilot - App Key Vault",
  "ROLE_PURPOSE" = "EYX - UAT-Pilot - App Key Vault"
}

key_vault_legacy_access_policies = {
  "admin-managed-identity" = { # Managed Identity permissions used by CI/CD Pipelines
    object_id          = "ce17b3d3-9c64-4083-904c-d79665424183"
    secret_permissions = ["Get", "List", "Set"]
  }
}

key_vault_enabled_for_template_deployment = true
enabled_for_deployment                    = true
enabled_for_disk_encryption               = true
key_vault_public_network_access_enabled   = true


### Resource Group RBAC Role Assignments #####
##############################################
##### UAT environments - Preserve existing RBAC configurations only.
##### Default role assignments are enabled and may create new role assignments.
##### Role assignments exist in Azure - keep them synced with IaC
enable_default_role_assignments = true
resource_group_role_assignments = {}

########################
#### App Insights #####
########################

app_insights_name                = "USEUEYXU01AAI02"
app_insights_sampling_percentage = 100
app_insights_tags = {
  "hidden-title" = "EYX - UAT-Pilot - App Insights",
  "ROLE_PURPOSE" = "EYX - UAT-Pilot - App Insights"
}

################################
######## AZURE WORKBOOK ########
################################
workbook_display_name = "EYX Dashboard Workbook UAT-PILOT"
workbook_tags = {
  "ROLE_PURPOSE" = "EYX - UAT-PILOT - Workbook"
}


####################################
######## AZURE Resource Lock #######
####################################
create_delete_lock = true

######################################
#### AVM USER MANAGEDIDENTITY #######
######################################
user_assigned_identity_name = "USEUEYXU01UMI02"

user_assigned_identity_tags = {
  "hidden-title" = "EYX - UAT-Pilot - User Assigned Identity",
  "ROLE_PURPOSE" = "EYX - UAT-Pilot - User Assigned Identity"
}
