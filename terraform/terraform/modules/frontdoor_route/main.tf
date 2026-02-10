resource "azurerm_cdn_frontdoor_route" "fd_route" {
    name                    = var.name
    profile_name            = var.profile_name
    endpoint_name           = var.endpoint_name
    origin_group_name       = var.origin_group_name
    resource_group_name     = var.resource_group_name
    supported_protocols     = var.supported_protocols
    patterns_to_match       = var.patterns_to_match
    forwarding_protocols    = var.forwarding_protocols
    https_redirect_enabled  = var.https_redirect_enabled
    enabled                 = var.enable
    origin_path             = var.origin_path
    catching_enabled        = var.catching_enabled
    rules_engine_name       = var.rules_engine_name
}