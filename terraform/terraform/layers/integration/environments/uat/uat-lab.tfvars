######################
### SHARED DATA ######
######################
resource_group_name_app          = "USEUEYXU01RSG02"
log_analytics_workspace_app_name = "USEUEYXU01LAW02"
vnet_app_name_01                 = "USEUEYXU01VNT02"
subnet_app_name_03               = "USEUEYXU01SBN05"


#######################
#### apim #############
#######################

apim_name       = "USEUEYXU01APM01"
publisher_name  = "EYGS"
publisher_email = "dante.ciai@gds.ey.com"

sku_name             = "Developer_1"
virtual_network_type = "External"
apim_tags = {
  "hidden-title" = "EYX - UAT-Lab - APIM",
  "ROLE_PURPOSE" = "EYX - UAT-Lab - APIM"

}


##########################
####### front door #######
##########################
profile_name      = "USEDCXS05HCDN01" # frontdoor dev
resource_group_fd = "USEDCXS05HRSG02"

### frontdoor_origin ###
fd_origin_name    = "fd_origin_USEDCXS05HCDN01"
origin_group_name = "EYXAPIM"
http_port         = 80
https_port        = 443
priority          = 1
weight            = 1000

### frontdoor_route ###
fd_route_name          = "fd_route_USEDCXS05HCDN01"
supported_protocols    = ["Https"]
patterns_to_match      = ["/*"]
endpoint_name          = "USEDCXS05HCDN01" # frontdoor dev
origin_path            = ""
forwarding_protocols   = "MatchRequest"
https_redirect_enabled = true
catching_enabled       = false



#############################
###### GENERAL #############
############################

tags = {
  DEPLOYMENT_ID = "EYXU01"
  ENGAGEMENT_ID = "I-69197406"
  OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT   = "UAT"
  ROLE_PURPOSE  = "EYX - UAT - App"
}
