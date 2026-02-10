####################
#### shared_data####
####################
module "shared_data" {
  source                           = "../shared"
  resource_group_name_app          = var.resource_group_name_app
  log_analytics_workspace_app_name = var.log_analytics_workspace_app_name
  vnet_app_name_01                 = var.vnet_app_name_01
  subnet_app_name_03               = var.subnet_app_name_03
  providers = {
    azurerm.dev_integration = azurerm.dev_integration
  }
}

#######################
#### apim #############
#######################

module "apim" {
  source = "../../modules/api_management"

  resource_group_name = module.shared_data.resource_group_app[0].name
  location            = module.shared_data.resource_group_app[0].location

  name            = var.apim_name
  publisher_name  = var.publisher_name
  publisher_email = var.publisher_email

  sku_name                   = var.sku_name
  virtual_network_type       = var.virtual_network_type
  subnet_id                  = module.shared_data.subnet_app_shared_name_03.id
  log_analytics_workspace_id = module.shared_data.law_shared_app[0].id
  tags                       = merge(var.tags, var.apim_tags)
}



##########################
####### front door #######
##########################

# module "frontdoor_origin" {
#   source              = "../../modules/frontdoor_origin"
#   name                = var.fd_origin_name
#   origin_group_name   = var.origin_group_name
#   profile_name        = var.profile_name
#   resource_group_name = var.resource_group_fd
#   apim_hostname       = module.apim.apim_hostname
#   http_port           = var.http_port
#   https_port          = var.https_port
#   priority            = var.priority
#   weight              = var.weight
# }

# module "frontdoor_route" {
#  source                  = "../../modules/frontdoor_route"
#  name                    = var.fd_route_name
#  profile_name            = var.profile_name
#  endpoint_name           = var.endpoint_name
#  origin_group_name       = var.origin_group_name
#  resource_group_name     = module.shared_data.resource_group_app[0].name
#  supported_protocols     = var.supported_protocols
#  patterns_to_match       = var.patterns_to_match
#  origin_path             = var.origin_path
#  forwarding_protocols    = var.forwarding_protocols
#  https_redirect_enabled  = var.https_redirect_enabled
#  origin_path             = var.origin_path
#  catching_enabled        = var.catching_enabled
#}