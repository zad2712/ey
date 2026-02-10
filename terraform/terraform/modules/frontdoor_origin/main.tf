resource "azurerm_cdn_frontdoor_origin" "fd_origin" {
    name                            = var.name
    origin_group_name               = var.origin_group_name
    profile_name                    = var.profile_name
    resource_group_name             = var.resource_group_name
    enabled                         = var.enabled
    certificate_name_check_enabled  = var.certificate_name_check_enabled
    host_name                       = var.apim_hostname
    http_port                       = var.http_port
    https_port                      = var.https_port
    origin_host_header              = var.origin_host_header
    priority                        = var.priority
    weight                          = var.weight
    
}