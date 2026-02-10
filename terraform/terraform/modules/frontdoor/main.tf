resource "azurerm_frontdoor" "azure_frontdoor" {
  name                                         = var.name
  resource_group_name                          = var.resource_group_name
  location                                     = var.location
  enforce_backend_pools_certificate_name_check = false

  identity {
    type = "SystemAssigned"
  }

  

  frontend_endpoint {
    name                              = var.endpoint_name
    host_name                         = "${var.name}.azurefd.net"
    session_affinity_enabled          = false
    web_application_firewall_policy_link_id = var.waf_policy_id
  }

  backend_pool {
    name = var.backend_pool_name

    backend {
      host_header = var.backend_host
      address     = var.backend_address
      http_port   = 80
      https_port  = 443
      priority    = 1
      weight      = 50
    }

    load_balancing_name = "loadBalancingSettings"
    health_probe_name   = "healthProbeSettings"
  }

  backend_pool_health_probe {
    name                = "healthProbeSettings"
    protocol            = "Https"
    path                = "/"
    interval_in_seconds = 30
  }

  backend_pool_load_balancing {
    name = "loadBalancingSettings"
  }

  routing_rule {
    name               = "route-all"
    accepted_protocols = ["Https"]
    patterns_to_match  = ["/*"]
    frontend_endpoints = [var.endpoint_name]
    forwarding_configuration {
      forwarding_protocol = "MatchRequest"
      backend_pool_name   = var.backend_pool_name
    }
  }
  
}

resource "azurerm_frontdoor_custom_https_configuration" "https" {
  frontend_endpoint_id              = azurerm_frontdoor.azure_frontdoor.frontend_endpoints[0].id
  custom_https_provisioning_enabled = true
  custom_https_configuration {
    certificate_source = "FrontDoor"
  }
}

  resource "azurerm_monitor_diagnostic_setting" "frontdoor" {
  count                      = var.log_analytics_workspace_id != null ? 1 : 0
  name                       = "${azurerm_frontdoor.azure_frontdoor.name}-diagnostic"
  target_resource_id         = azurerm_frontdoor.azure_frontdoor.id
  log_analytics_workspace_id = var.log_analytics_workspace_id

  enabled_log {
    category = "GatewayLogs"
  }

}

