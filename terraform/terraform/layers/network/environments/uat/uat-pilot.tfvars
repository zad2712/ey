#####################
### GENERAL ##########
#####################
env = "UAT"

tags = {
  DEPLOYMENT_ID        = "EYXU01"
  ENGAGEMENT_ID        = "I-69197406"
  OWNER                = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT          = "UAT"
  PEER                 = "Codev"
  ROLE_PURPOSE         = "Virtual Network"
  HUBTRANSITIVEROUTING = "false"
  TF_LAYER             = "Network"
  PRODUCT_APP          = "EYX - Agent Framework"
  CTP_SERVICE          = "Co-Dev"
}

admin_resources = false

# Route Table - Enable APIM UDR for all environments
enable_apim_route_table = true
route_table_apim_name   = "USEUEYXU01UDR02"

### VNET SPECIFIC TAGS
vnet_frontend_tags = {
  "hidden-title"      = "EYX - Frontend"
  "IPAM_ORGANIZATION" = "CTILEYXIPAM"
}

vnet_backend_tags = {
  "hidden-title"      = "EYX - Backend"
  "IPAM_ORGANIZATION" = "CTILEYXIPAM"
}

route_table_apim_tags = {
  "hidden-title" = "EYX - UAT-Pilot - APIM UDR"
}

nsg_app_name_01_tags = {
  "hidden-title" = "EYX - UAT-Pilot - Frontend Inbound NSG"
}

nsg_app_name_02_tags = {
  "hidden-title" = "EYX - UAT-Pilot - App Services Outbound NSG"
}

nsg_app_name_03_tags = {
  "hidden-title" = "EYX - UAT-Pilot - APIM Integration"
}

nsg_app_name_04_tags = {
  "hidden-title" = "EYX - UAT-Pilot - Backend Inbound"
}

nsg_app_name_05_tags = {
  "hidden-title" = "EYX - UAT-Pilot - OpenAI Inbound"
}

nsg_app_name_06_tags = {
  "hidden-title" = "EYX - UAT-Pilot - ACA"
}

########################
### SHARED DATA ##########
#########################
#resource_group_name_admin          = "USEUEYXU01RSG01"
resource_group_name_app            = "USEUEYXU01RSG03"
log_analytics_workspace_admin_name = "USEUEYXU01LAW01"
log_analytics_workspace_app_name   = "USEUEYXU01LAW03"

####################
### VNETS ##########
###################
#### vnet app 01 (frontend) IPAM -> CTILEYXIPAM-App-UAT-Pilot-IPRange01
vnet_name_app_01               = "USEUEYXU01VNT04"
vnet_address_space_app_01      = ["10.217.248.0/25"]
subnet1_name_app_01            = "USEUEYXU01SBN09"
subnet2_name_app_01            = "USEUEYXU01SBN10"
subnet3_name_app_01            = "USEUEYXU01SBN11"
subnet1_address_prefix_app_01  = "10.217.248.0/27"
subnet2_address_prefix_app_01  = "10.217.248.32/27"
subnet3_address_prefix_app_01  = "10.217.248.64/26"
ddos_protection_plan_id_app_01 = "/subscriptions/xxxxx/resourceGroups/rg-ddos/providers/Microsoft.Network/ddosProtectionPlans/ddos-standard"
enable_ddos_protection_app_01  = false

#### vnet app 02 (backend) IPAM -> CTILEYXIPAM-App-UAT-Pilot-IPRange02
vnet_name_app_02               = "USEUEYXU01VNT05"
vnet_address_space_app_02      = ["10.217.248.128/25"]
subnet1_name_app_02            = "USEUEYXU01SBN12"
subnet2_name_app_02            = "USEUEYXU01SBN13"
subnet3_name_app_02            = "USEUEYXU01SBN14"
subnet1_address_prefix_app_02  = "10.217.248.128/27"
subnet2_address_prefix_app_02  = "10.217.248.160/27"
subnet3_address_prefix_app_02  = "10.217.248.192/26"
ddos_protection_plan_id_app_02 = "/subscriptions/xxxxx/resourceGroups/rg-ddos/providers/Microsoft.Network/ddosProtectionPlans/ddos-standard"
enable_ddos_protection_app_02  = false

################
### NSG #########
#################
#### NSG app

nsg_app_name_01 = "USEUEYXU01NSG01"
nsg_app_name_02 = "USEUEYXU01NSG02"
nsg_app_name_03 = "USEUEYXU01NSG03"
nsg_app_name_04 = "USEUEYXU01NSG04"
nsg_app_name_05 = "USEUEYXU01NSG05"
nsg_app_name_06 = "USEUEYXU01NSG06"


additional_security_rules_nsg_app_01 = [
  {
    name                       = "IN_ALLOW_RUNNERS_EYX"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.47.17.32/27"] # CTILEYXIPAM-Admin-UAT-IPRange01
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_APPSERVICES_EYX"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.217.248.32/27"] # subnet2_address_prefix_app_01
    destination_address_prefix = "VirtualNetwork"
  },
  # This rule allows traffic from APIM to App Services Private Endpoints
  {
    name                       = "IN_ALLOW_APIM_EYX"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = ["10.217.248.64/26"] # subnet3_address_prefix_app_01
    destination_address_prefix = "VirtualNetwork"
  }
]

additional_security_rules_nsg_app_02 = [
  {
    name                         = "OUT_ALLOW_APPSERVICES_EYX"
    priority                     = 1000
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefixes = ["10.217.248.0/27"] # subnet1_address_prefix_app_01
  },
  {
    name                         = "OUT_ALLOW_APIM_EYX"
    priority                     = 1001
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefixes = ["10.217.248.64/26"] # subnet3_address_prefix_app_01
  },
  {
    name                         = "OUT_ALLOW_BEPEP_EYX"
    priority                     = 1002
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefixes = ["10.217.248.128/27"] # subnet1_address_prefix_app_02
  },
  {
    name                         = "OUT_ALLOW_BEOAI_EYX"
    priority                     = 1003
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefixes = ["10.217.248.160/27"] # subnet2_address_prefix_app_02
  },
  {
    name                         = "OUT_ALLOW_ACE_EYX"
    priority                     = 1004
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefixes = ["10.217.248.192/26"] # subnet3_address_prefix_app_02
  }
]

additional_security_rules_nsg_app_03 = [
  {
    name                       = "IN_ALLOW_RUNNERS_EYX"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.47.17.32/27"] # CTILEYXIPAM-Admin-UAT-IPRange01
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_APPSERVICES_EYX"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.217.248.32/27"] # subnet2_address_prefix_app_01
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_INTERNET_APIM_EYX"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_APIMAN_EYX"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_APIMLB_EYX"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6390"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_APIMTM_EYX"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureTrafficManager"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_FRONTDOOR_EYX"
    priority                   = 1006
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureFrontDoor.Backend"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "OUT_ALLOW_STORAGEAPIM_EYX"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "Storage"
  },
  {
    name                       = "OUT_ALLOW_SQLAPIM_EYX"
    priority                   = 1001
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "1433"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "SQL"
  },
  {
    name                       = "OUT_ALLOW_AKVAPIM_EYX"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureKeyVault"
  },
  {
    name                       = "OUT_ALLOW_MONAPIM_EYX"
    priority                   = 1003
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443-1886"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureMonitor"
  },
  {
    name                         = "OUT_ALLOW_APPSERVICES_EYX"
    priority                     = 1004
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefixes = ["10.217.248.0/27"] # subnet1_address_prefix_app_01
  },
  {
    name                         = "OUT_ALLOW_BEOAI_EYX"
    priority                     = 1005
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "VirtualNetwork"
    destination_address_prefixes = ["10.217.248.160/27"] # subnet2_address_prefix_app_02
  }
]

additional_security_rules_nsg_app_04 = [
  {
    name                       = "IN_ALLOW_RUNNERS_EYX"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.47.17.32/27"] # CTILEYXIPAM-Admin-UAT-IPRange01
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_APPSERVICES_EYX"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.217.248.32/27"] # subnet2_address_prefix_app_01
    destination_address_prefix = "VirtualNetwork"
  }
]

additional_security_rules_nsg_app_05 = [
  {
    name                       = "IN_ALLOW_RUNNERS_EYX"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.47.17.32/27"] # CTILEYXIPAM-Admin-UAT-IPRange01
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_APPSERVICES_EYX"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.217.248.32/27"] # subnet2_address_prefix_app_01
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_APIM_EYX"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefixes    = ["10.217.248.64/26"] # subnet3_address_prefix_app_01
    destination_address_prefix = "VirtualNetwork"
  }
]

additional_security_rules_nsg_general = [
  # {
  #   name                       = "AllowClientCommunication"
  #   priority                   = 110
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "443"
  #   source_address_prefix      = "Internet"
  #   destination_address_prefix = "VirtualNetwork"
  # },
  # {
  #   name                       = "AllowManagementEndpoint"
  #   priority                   = 120
  #   direction                  = "Inbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "3443"
  #   source_address_prefix      = "ApiManagement"
  #   destination_address_prefix = "VirtualNetwork"
  # },
  # {
  #   name                       = "AllowApiManagement"
  #   priority                   = 130
  #   direction                  = "Outbound"
  #   access                     = "Allow"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "*"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "ApiManagement"
  # },
  # {
  #   name                       = "Deny-NETBIOS-Inbound"
  #   priority                   = 1010
  #   direction                  = "Inbound"
  #   access                     = "Deny"
  #   protocol                   = "*"
  #   source_port_range          = "*"
  #   destination_port_range     = "137-139"
  #   source_address_prefix      = "Internet"
  #   destination_address_prefix = "*"
  # },
  # {
  #   name                       = "Default-Deny-All-Inbound"
  #   priority                   = 4096
  #   direction                  = "Inbound"
  #   access                     = "Deny"
  #   protocol                   = "*"
  #   source_port_range          = "*"
  #   destination_port_range     = "*"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # }
]
