######################
### SHARED DATA ######
######################
resource_group_name_app          = "USEQCXS05HRSG03"
log_analytics_workspace_app_name = "USEQCXS05HLAW02"
vnet_app_name_01                 = "USEQCXS05HVNT02"
subnet_app_name_03               = "USEQCXS05HSBN05"


#######################
#### apim #############
#######################

apim_name       = "USEQCXS05HAPM01"
publisher_name  = "EYGS"
publisher_email = "dante.ciai@gds.ey.com"

sku_name             = "Developer_1"
virtual_network_type = "External"


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
  DEPLOYMENT_ID = "CXS05H"
  ENGAGEMENT_ID = "I-68933458"
  OWNER         = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT   = "QA"
}