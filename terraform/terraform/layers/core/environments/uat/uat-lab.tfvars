######################
### SHARED DATA ######
######################
resource_group_name_admin = "USEUEYXU01RSG01"
resource_group_name_app   = "USEUEYXU01RSG02"

vnet_admin_name_01   = "USEUEYXU01VNT01" # Admin VNET
subnet_admin_name_01 = "USEUEYXU01SBN02" # Admin Subnet
vnet_app_name_01     = "USEUEYXU01VNT02" # Frontend VNET
subnet_app_name_01   = "USEUEYXU01SBN03"
subnet_app_name_02   = "USEUEYXU01SBN04"
subnet_app_name_03   = "USEUEYXU01SBN05"
vnet_app_name_02     = "USEUEYXU01VNT03" # Backend VNET
subnet1_name_app_02  = "USEUEYXU01SBN06" # Backend Subnet1 /27
subnet2_name_app_02  = "USEUEYXU01SBN07" # Backend Subnet2 /27
subnet3_name_app_02  = "USEUEYXU01SBN08" # Backend Subnet3 /27

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
resource_group_name = "USEUEYXU01RSG02"
location            = "East US"
resource_group_tags = {
  "hidden-title" = "EYX - UAT-Lab - App",
  "ROLE_PURPOSE" = "EYX - UAT-Lab - App"
}


################################
### LOG ANALYTICS WORKSPACE ####
################################
log_analytics_workspace_name = "USEUEYXU01LAW02"
log_analytics_workspace_tags = {
  "hidden-title" = "EYX - UAT-Lab - App LAW",
  "ROLE_PURPOSE" = "EYX - UAT-Lab - App LAW"
}

##################
### KEY VAULT ####
##################
key_vault_name = "USEUEYXU01AKV02"

key_vault_tags = {
  "hidden-title" = "EYX - UAT-Lab - App Key Vault",
  "ROLE_PURPOSE" = "EYX - UAT-Lab - App Key Vault"
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
##### Default role assignments are enabled; manage any changes via IaC to avoid unexpected new role assignments.
##### Role assignments exist in Azure - keep them synced with IaC
enable_default_role_assignments = true
resource_group_role_assignments = {}

########################
#### App Insights #####
########################

app_insights_name                = "USEUEYXU01AAI01"
app_insights_sampling_percentage = 100
app_insights_tags = {
  "hidden-title" = "EYX - UAT-Lab - App Insights",
  "ROLE_PURPOSE" = "EYX - UAT-Lab - App Insights"
}

################################
######## AZURE WORKBOOK ########
################################
workbook_display_name = "EYX Dashboard Workbook UAT-LAB"
workbook_tags = {
  "ROLE_PURPOSE" = "EYX - UAT-LAB - Workbook"
}

######################################
#### AVM USER MANAGEDIDENTITY #######
######################################
user_assigned_identity_name = "USEUEYXU01UMI11"

user_assigned_identity_tags = {
  "hidden-title" = "EYX - UAT-Lab - User Assigned Identity",
  "ROLE_PURPOSE" = "EYX - UAT-Lab - User Assigned Identity"
}

####################################
######## AZURE Resource Lock #######
####################################

create_delete_lock = true