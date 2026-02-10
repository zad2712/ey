################
### GENERAL ####
################
env = "DEV2"

tags = {
  DEPLOYMENT_ID = "CXS05H"
  ENGAGEMENT_ID = "I-69197406"
  OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT   = "Development"
}

######################
### SHARED DATA ######
######################
# Admin resources (cross-subscription - in admin subscription)
# When env = "DEV2", the admin provider is used to look up these resources in the bcff8cd6 subscription.
resource_group_name_admin = "USEDCXS05HRSG01"
vnet_admin_name_01        = "USEDCXS05HVNT99"
subnet_admin_name_01      = "USEDCXS05HSBN00" # GitHub Runner Subnet

# App resources (in application subscription)
resource_group_name_app = "USEDCXS05HRSG05"
vnet_app_name_01        = "USEDCXS05HVNT06" # Frontend VNET
subnet_app_name_01      = "USEDCXS05HSBN15"
subnet_app_name_02      = "USEDCXS05HSBN16"
subnet_app_name_03      = "USEDCXS05HSBN17"
vnet_app_name_02        = "USEDCXS05HVNT07" # Backend VNET
subnet1_name_app_02     = "USEDCXS05HSBN18" # Backend Subnet1
subnet2_name_app_02     = "USEDCXS05HSBN19" # Backend Subnet2
subnet3_name_app_02     = "USEDCXS05HSBN20" # Backend Subnet3

#######################
### RESOURCE GROUP ####
#######################
resource_group_name = "USEDCXS05HRSG05"
location            = "East US"
resource_group_tags = {
  "hidden-title" = "EYX - Dev2 - App"
}


################################
### LOG ANALYTICS WORKSPACE ####
################################
log_analytics_workspace_name = "USEDCXS05HLAW04"
log_analytics_workspace_tags = {
  "hidden-title" = "EYX - Dev2 - App LAW"
}

##################
### KEY VAULT ####
##################
key_vault_name = "USEDCXS05HAKV04"

key_vault_tags = {
  "hidden-title" = "EYX - Dev2 - App Key Vault"
}

# Network ACLs are automatically configured via shared_data module
# The module queries Admin (GitHub Runner), Frontend, and Backend subnets
# See terraform/layers/core/README.md for details

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
##### This section only applies to Dev Environments.
##### DON'T REPLICATE TO HIGHER ENVIRONMENTS UNLESS REQUESTED.
##### enable_default_role_assignments controls whether default team role assignments are applied.
##### Set to false in QA/higher environments to preserve existing RBAC configurations.
enable_default_role_assignments = true

resource_group_role_assignments = {
  "taxdev_contributors" = {
    role_definition_id_or_name = "Contributor"
    principal_id               = "4671d2ff-b7c5-4e0f-8432-aae35707e1b2"
  },
  "eyxdev_contributor" = {
    role_definition_id_or_name = "Contributor"
    principal_id               = "42d654d5-f215-497e-a7c9-3c5a6f3f7574"
  },
  "taxdev_redis_cache_contributor" = {
    role_definition_id_or_name = "Redis Cache Contributor"
    principal_id               = "4671d2ff-b7c5-4e0f-8432-aae35707e1b2"
  },
  "eyxdev_redis_cache_contributor" = {
    role_definition_id_or_name = "Redis Cache Contributor"
    principal_id               = "42d654d5-f215-497e-a7c9-3c5a6f3f7574"
  }
}

###############################
### USER ASSIGNED IDENTITY ####
###############################
# Not required for dev2 environment as Skills Plugins are not deployed here.
# Skills Plugins use ACA to pull images from ACR via Managed Identity.
# Only deployed in Dev-1, Dev (Dev-Integration), and higher environments.
user_assigned_identity_name = null
user_assigned_identity_tags = {}

##########################
### APPLICATION INSIGHTS ###
##########################
app_insights_name                = "USEDCXS05HAAI02"
app_insights_sampling_percentage = 100
app_insights_tags = {
  "hidden-title" = "EYX - Dev-2 - App Insights"
}

workbook_display_name = "EYX Dashboard Workbook Dev2"