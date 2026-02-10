######################
### SHARED DATA ######
######################
resource_group_name_app          = "USEDCXS05HRSG04"
log_analytics_workspace_app_name = "USEDCXS05HLAW03"
vnet_app_name_01                 = "USEDCXS05HVNT04"
subnet_app_name_03               = "USEDCXS05HSBN11"

#######################
#### apim #############
#######################

apim_name       = "USEDCXS05HAPM02"
publisher_name  = "EYGS"
publisher_email = "dante.ciai@gds.ey.com"

sku_name             = "Developer_1"
virtual_network_type = "External"
apim_tags = {
  "hidden-title" = "EYX - Dev-1 - APIM"
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
endpoint_name          = "USEDCXS05HCDN01" # frontdoor dev
origin_path            = ""
forwarding_protocols   = "MatchRequest"
https_redirect_enabled = true
catching_enabled       = false



#############################
###### GENERAL #############
############################

tags = {
  DEPLOYMENT_ID = "CXS05H"
  ENGAGEMENT_ID = "I-69197406"
  OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT   = "Development"
}
