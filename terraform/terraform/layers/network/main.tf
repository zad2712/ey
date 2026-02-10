########################
##### shared_data ######
#########################
module "shared_data" {
  source                           = "../shared"
  resource_group_name_app          = var.resource_group_name_app
  resource_group_name_admin        = var.resource_group_name_admin
  log_analytics_workspace_app_name = var.log_analytics_workspace_app_name

  providers = {
    azurerm.dev_integration = azurerm.dev_integration
  }
}

####################
###### VNETS #######
###################
#### VNET admin_01
module "vnet_admin_01" {
  count                      = var.admin_resources ? 1 : 0
  source                     = "../../modules/virtual_network"
  name                       = var.vnet_admin_name_01
  address_space              = var.vnet_address_space_admin_01
  location                   = module.shared_data.resource_group_admin[0].location
  resource_group_name        = module.shared_data.resource_group_admin[0].name
  tags                       = merge(var.tags, var.vnet_admin_tags)
  enable_ddos_protection     = var.enable_ddos_protection
  ddos_protection_plan_id    = var.ddos_protection_plan_id
  log_analytics_workspace_id = module.shared_data.law_shared_admin[0].id
  subnets = [
    {
      name              = var.subnet1_name
      address_prefix    = var.subnet1_address_prefix
      service_endpoints = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web", "Microsoft.CognitiveServices"]
    },
    {
      name              = var.subnet2_name
      address_prefix    = var.subnet2_address_prefix
      service_endpoints = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web", "Microsoft.CognitiveServices"]
      delegation = {
        name = "github-delegation"
        service_delegation = {
          name = "GitHub.Network/networkSettings"
          actions = [
            "Microsoft.Network/virtualNetworks/subnets/join/action"
          ]
        }
      }
    }
  ]
}
#### VNET app_01 (frontend)
module "vnet_app_01" {
  source                     = "../../modules/virtual_network"
  name                       = var.vnet_name_app_01
  address_space              = var.vnet_address_space_app_01
  location                   = module.shared_data.resource_group_app[0].location
  resource_group_name        = module.shared_data.resource_group_app[0].name
  tags                       = merge(var.tags, var.vnet_frontend_tags)
  enable_ddos_protection     = var.enable_ddos_protection_app_01
  ddos_protection_plan_id    = var.ddos_protection_plan_id_app_01
  log_analytics_workspace_id = module.shared_data.law_shared_app[0].id
  subnets = [
    {
      name                              = var.subnet1_name_app_01
      address_prefix                    = var.subnet1_address_prefix_app_01
      service_endpoints                 = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web", "Microsoft.CognitiveServices"]
      private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
    },
    {
      name              = var.subnet2_name_app_01
      address_prefix    = var.subnet2_address_prefix_app_01
      service_endpoints = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web", "Microsoft.CognitiveServices"]
      delegation = {
        name = "delegation-webapps"
        service_delegation = {
          name    = "Microsoft.Web/serverFarms"
          actions = ["Microsoft.Network/virtualNetworks/subnets/action"]
        }
      }
    },
    {
      name              = var.subnet3_name_app_01
      address_prefix    = var.subnet3_address_prefix_app_01
      service_endpoints = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web", "Microsoft.CognitiveServices"]
    }
  ]
}

##########################
#### ROUTE TABLES ########
##########################
# User Defined Route (UDR) for APIM subnet across all environments
# This route table ensures Azure API Management can reach Azure's management infrastructure
# 
# Purpose: Routes traffic destined for Azure API Management service endpoints to the Internet
# 
# Background: Azure API Management requires connectivity to Azure's management plane for:
# - Control plane operations (configuration, management)
# - Health monitoring and diagnostics
# - Configuration updates and synchronization
# 
# This UDR uses the "ApiManagement" service tag to route traffic to Microsoft's API Management
# infrastructure endpoints via the Internet gateway, which is essential for proper APIM functionality
# in both internal and external VNet deployment modes.
#
# Route Details:
# - Destination: ApiManagement service tag
# - Next Hop: Internet
# - Applied to: APIM subnet (subnet3_name_app_01) in each environment
resource "azurerm_route_table" "apim_route_table" {
  count               = var.enable_apim_route_table ? 1 : 0
  name                = var.route_table_apim_name
  location            = module.shared_data.resource_group_app[0].location
  resource_group_name = module.shared_data.resource_group_app[0].name
  tags                = merge(var.tags, var.route_table_apim_tags)

  # Route to ensure APIM control plane can reach Azure's management endpoints
  route {
    name                   = "APIMInternet"
    address_prefix         = "ApiManagement" # Azure service tag for APIM endpoints
    next_hop_type          = "Internet"      # Route to Internet gateway
    next_hop_in_ip_address = null            # No specific IP needed for Internet routing
  }
}

# Associate the APIM route table with the designated APIM subnet
# This applies the Internet routing rule to all traffic from the APIM subnet
resource "azurerm_subnet_route_table_association" "apim_subnet_rt" {
  count          = var.enable_apim_route_table ? 1 : 0
  subnet_id      = module.vnet_app_01.subnet_ids[var.subnet3_name_app_01]
  route_table_id = azurerm_route_table.apim_route_table[0].id
}

#### VNET app_02 (backend)
module "vnet_app_02" {
  source                     = "../../modules/virtual_network"
  name                       = var.vnet_name_app_02
  address_space              = var.vnet_address_space_app_02
  location                   = module.shared_data.resource_group_app[0].location
  resource_group_name        = module.shared_data.resource_group_app[0].name
  tags                       = merge(var.tags, var.vnet_backend_tags)
  enable_ddos_protection     = var.enable_ddos_protection_app_02
  ddos_protection_plan_id    = var.ddos_protection_plan_id_app_02
  log_analytics_workspace_id = module.shared_data.law_shared_app[0].id
  subnets = [
    {
      name                              = var.subnet1_name_app_02
      address_prefix                    = var.subnet1_address_prefix_app_02
      service_endpoints                 = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web", "Microsoft.CognitiveServices"]
      private_endpoint_network_policies = "NetworkSecurityGroupEnabled"
    },
    {
      name              = var.subnet2_name_app_02
      address_prefix    = var.subnet2_address_prefix_app_02
      service_endpoints = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web", "Microsoft.CognitiveServices"]
    },
    {
      name              = var.subnet3_name_app_02
      address_prefix    = var.subnet3_address_prefix_app_02
      service_endpoints = ["Microsoft.AzureActiveDirectory", "Microsoft.AzureCosmosDB", "Microsoft.EventHub", "Microsoft.KeyVault", "Microsoft.ServiceBus", "Microsoft.Sql", "Microsoft.Storage", "Microsoft.Web", "Microsoft.CognitiveServices"]
      delegation = {
        name = "Microsoft.App.environments"
        service_delegation = {
          name    = "Microsoft.App/environments"
          actions = ["Microsoft.Network/virtualNetworks/subnets/join/action"]
        }
      }
    }
  ]
}


########################
####### NSG ############
######################
#### NSG admin 01
module "nsg_admin_01" {
  count                      = var.admin_resources ? 1 : 0
  source                     = "../../modules/network_security_group"
  name                       = var.nsg_admin_name_01
  location                   = module.shared_data.resource_group_admin[0].location
  resource_group_name        = module.shared_data.resource_group_admin[0].name
  additional_security_rules  = var.additional_security_rules_nsg_admin_01
  log_analytics_workspace_id = module.shared_data.law_shared_admin[0].id
  tags                       = merge(var.tags, var.nsg_admin_tags)
}

#### NSG admin 02
# module "nsg_admin_02" {
#   count                       = var.admin_resources ? 1 : 0
#   source                      = "../../modules/network_security_group"
#   name                        = var.nsg_admin_name_02
#   location                    = module.shared_data.resource_group_admin[0].location
#   resource_group_name         = module.shared_data.resource_group_admin[0].name
#   additional_security_rules   = var.additional_security_rules_nsg_admin_01
#   log_analytics_workspace_id  = module.shared_data.law_shared_admin[0].id
#   tags = var.tags
# }

#### NSG app 01
module "nsg_app_01" {
  source                     = "../../modules/network_security_group"
  name                       = var.nsg_app_name_01
  location                   = module.shared_data.resource_group_app[0].location
  resource_group_name        = module.shared_data.resource_group_app[0].name
  additional_security_rules  = var.additional_security_rules_nsg_app_01
  log_analytics_workspace_id = module.shared_data.law_shared_app[0].id
  tags                       = merge(var.tags, var.nsg_app_name_01_tags)
}

#### NSG app 02
module "nsg_app_02" {
  source                     = "../../modules/network_security_group"
  name                       = var.nsg_app_name_02
  location                   = module.shared_data.resource_group_app[0].location
  resource_group_name        = module.shared_data.resource_group_app[0].name
  additional_security_rules  = var.additional_security_rules_nsg_app_02
  log_analytics_workspace_id = module.shared_data.law_shared_app[0].id
  tags                       = merge(var.tags, var.nsg_app_name_02_tags)
}

#### NSG app 03
module "nsg_app_03" {
  source                     = "../../modules/network_security_group"
  name                       = var.nsg_app_name_03
  location                   = module.shared_data.resource_group_app[0].location
  resource_group_name        = module.shared_data.resource_group_app[0].name
  additional_security_rules  = var.additional_security_rules_nsg_app_03
  log_analytics_workspace_id = module.shared_data.law_shared_app[0].id
  tags                       = merge(var.tags, var.nsg_app_name_03_tags)
}

#### NSG app 04
module "nsg_app_04" {
  source                     = "../../modules/network_security_group"
  name                       = var.nsg_app_name_04
  location                   = module.shared_data.resource_group_app[0].location
  resource_group_name        = module.shared_data.resource_group_app[0].name
  additional_security_rules  = var.additional_security_rules_nsg_app_04
  log_analytics_workspace_id = module.shared_data.law_shared_app[0].id
  tags                       = merge(var.tags, var.nsg_app_name_04_tags)
}

#### NSG app 05
module "nsg_app_05" {
  source                     = "../../modules/network_security_group"
  name                       = var.nsg_app_name_05
  location                   = module.shared_data.resource_group_app[0].location
  resource_group_name        = module.shared_data.resource_group_app[0].name
  additional_security_rules  = var.additional_security_rules_nsg_app_05
  log_analytics_workspace_id = module.shared_data.law_shared_app[0].id
  tags                       = merge(var.tags, var.nsg_app_name_05_tags)
}

#### NSG app 06
module "nsg_app_06" {
  source                     = "../../modules/network_security_group"
  name                       = var.nsg_app_name_06
  location                   = module.shared_data.resource_group_app[0].location
  resource_group_name        = module.shared_data.resource_group_app[0].name
  additional_security_rules  = var.additional_security_rules_nsg_general
  log_analytics_workspace_id = module.shared_data.law_shared_app[0].id
  tags                       = merge(var.tags, var.nsg_app_name_06_tags)
}

##########################
##########################
#### NSG Association ####
##########################
#########################
### Subnet NSG Associations
# Admin subnet NSG associations
resource "azurerm_subnet_network_security_group_association" "admin_subnet1_nsg" {
  count                     = var.admin_resources ? 1 : 0
  subnet_id                 = local.subnet_id_admin_01
  network_security_group_id = local.nsg_admin_id_01
}

# App subnet NSG associations
resource "azurerm_subnet_network_security_group_association" "app_subnet1_nsg" {
  subnet_id                 = module.vnet_app_01.subnet_ids[var.subnet1_name_app_01]
  network_security_group_id = module.nsg_app_01.id
}

resource "azurerm_subnet_network_security_group_association" "app_subnet2_nsg" {
  subnet_id                 = module.vnet_app_01.subnet_ids[var.subnet2_name_app_01]
  network_security_group_id = module.nsg_app_02.id
}

resource "azurerm_subnet_network_security_group_association" "app_subnet3_nsg" {
  subnet_id                 = module.vnet_app_01.subnet_ids[var.subnet3_name_app_01]
  network_security_group_id = module.nsg_app_03.id
}

# Backend subnet NSG associations
resource "azurerm_subnet_network_security_group_association" "backend_subnet1_nsg" {
  subnet_id                 = module.vnet_app_02.subnet_ids[var.subnet1_name_app_02]
  network_security_group_id = module.nsg_app_04.id
}

resource "azurerm_subnet_network_security_group_association" "backend_subnet2_nsg" {
  subnet_id                 = module.vnet_app_02.subnet_ids[var.subnet2_name_app_02]
  network_security_group_id = module.nsg_app_05.id
}

resource "azurerm_subnet_network_security_group_association" "backend_subnet3_nsg" {
  subnet_id                 = module.vnet_app_02.subnet_ids[var.subnet3_name_app_02]
  network_security_group_id = module.nsg_app_06.id
}


#################################
### GitHub Network Settings #####
#################################
# Only deployed in QA environment when all GitHub variables are provided
module "github_network_settings" {
  count             = local.enable_github_subnet_data ? 1 : 0
  source            = "../../modules/github_network_settings"
  name              = var.github_network_settings_name
  resource_group_id = module.shared_data.resource_group_admin[0].id
  location          = module.shared_data.resource_group_admin[0].location
  subnet_id         = data.azurerm_subnet.github_subnet[0].id
  business_id       = var.business_id
  tags              = merge(var.tags, var.github_settings_tags)

  providers = {
    azapi = azapi.azapi
  }
}

#################################
####### Private DNS Zones #######
#################################
# Private DNS Zones Link Custom Module - Development Environment
module "dev_private_dns_zones_links" {
  source   = "../../modules/private_dns_zone_link"
  for_each = var.enable_private_dns_zones ? local.private_dns_zones_dev : {}

  name                  = "${var.hidden_title_tag_env}-${each.key}"
  resource_group_name   = local.dns_zones_rg_dev
  private_dns_zone_name = each.value
  virtual_network_ids = {
    frontend = module.vnet_app_01.vnet_id
    backend  = module.vnet_app_02.vnet_id
  }
  providers = {
    azurerm.admin = azurerm.admin
  }
}