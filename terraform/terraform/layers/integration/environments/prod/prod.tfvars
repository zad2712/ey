######################
### SHARED DATA ######
######################
resource_group_name_app          = "USEPEYXP01RSG04"
log_analytics_workspace_app_name = "USEPEYXP01LAW04"
vnet_app_name_01                 = "USEPEYXP01VNT06"
subnet_app_name_03               = "USEPEYXP01SBN17"


#######################
#### apim #############
#######################

apim_name       = "USEPEYXP01APM04"
publisher_name  = "EYGS"
publisher_email = "dante.ciai@gds.ey.com"

sku_name             = "Premium_1"
virtual_network_type = "External"
apim_tags = {
  "hidden-title" = "EYX - Prod - APIM",
  "ROLE_PURPOSE" = "EYX - Prod - APIM"
}


##########################
####### front door #######
##########################
profile_name      = "" # frontdoor dev
resource_group_fd = ""

### frontdoor_origin ###
fd_origin_name    = ""
origin_group_name = "EYXAPIM"
http_port         = 80
https_port        = 443
priority          = 1
weight            = 1000

### frontdoor_route ###
fd_route_name          = ""
supported_protocols    = ["Https"]
patterns_to_match      = ["/*"]
endpoint_name          = "USEPEYXP01CDN01" # frontdoor dev
origin_path            = ""
forwarding_protocols   = "MatchRequest"
https_redirect_enabled = true
catching_enabled       = false



#############################
###### GENERAL #############
############################

tags = {
  DEPLOYMENT_ID = "EYXP01"
  ENGAGEMENT_ID = "I-69197406"
  OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT   = "Production"
  ROLE_PURPOSE  = "EYX - Prod - App"
}
