#####################
### GENERAL ##########
#####################
env = "DEV"

tags = {
  DEPLOYMENT_ID        = "CXS05H"
  ENGAGEMENT_ID        = "I-69197406"
  OWNER                = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT          = "Development"
  PEER                 = "Codev"
  ROLE_PURPOSE         = "Virtual Network"
  HUBTRANSITIVEROUTING = "false"
  TF_LAYER             = "Network"
  PRODUCT_APP          = "EYX - Agent Framework"
  CTP_SERVICE          = "Co-Dev"
}

admin_resources      = false
hidden_title_tag_env = "dev2"

# Route Table - Enable APIM UDR for all environments
enable_apim_route_table = true
route_table_apim_name   = "USEDCXS05HUDR03"

### VNET SPECIFIC TAGS
vnet_admin_tags = {
  "hidden-title"      = "EYX - Dev-2 - Runners VNET"
  "IPAM_ORGANIZATION" = "CTILEYXIPAM"
  "ROLE_PURPOSE"      = "Virtual Network - GitHub runners"
}

vnet_frontend_tags = {
  "hidden-title"      = "EYX - Frontend"
  "IPAM_ORGANIZATION" = "CTILEYXIPAM"
}

vnet_backend_tags = {
  "hidden-title"      = "EYX - Backend"
  "IPAM_ORGANIZATION" = "CTILEYXIPAM"
}

route_table_apim_tags = {
  "hidden-title" = "EYX - Dev2 - APIM UDR"
}

github_settings_tags = {
  GitHubId = "" # -> given on output
}

nsg_admin_tags = {
  "hidden-title" = "Dev-2 - Admin Runners Subnet NSG"
}

nsg_app_name_01_tags = {
  "hidden-title" = "EYX - Dev-2 - Frontend Inbound NSG"
}

nsg_app_name_02_tags = {
  "hidden-title" = "EYX - Dev-2 - App Services Outbound NSG"
}

nsg_app_name_03_tags = {
  "hidden-title" = "EYX - Dev-2 - APIM Integration"
}

nsg_app_name_04_tags = {
  "hidden-title" = "EYX - Dev-2 - Backend Inbound"
}

nsg_app_name_05_tags = {
  "hidden-title" = "EYX - Dev-2 - OpenAI Inbound"
}

nsg_app_name_06_tags = {
  "hidden-title" = "EYX - Dev-2 - ACA"
}

########################
### SHARED DATA ##########
#########################
#resource_group_name_admin                 = "USEDCXS05HRSG01"
resource_group_name_app            = "USEDCXS05HRSG05"
log_analytics_workspace_admin_name = "USEDCXS05HLAW01"
log_analytics_workspace_app_name   = "USEDCXS05HLAW04"

####################
### VNETS ##########
###################

#### vnet app 01 (frontend) IPAM -> CTILEYXIPAM-App-Dev2-IPRange01
vnet_name_app_01               = "USEDCXS05HVNT06"
vnet_address_space_app_01      = ["10.19.53.128/25"]
subnet1_name_app_01            = "USEDCXS05HSBN15"
subnet2_name_app_01            = "USEDCXS05HSBN16"
subnet3_name_app_01            = "USEDCXS05HSBN17"
subnet1_address_prefix_app_01  = "10.19.53.128/27"
subnet2_address_prefix_app_01  = "10.19.53.160/27"
subnet3_address_prefix_app_01  = "10.19.53.192/26"
ddos_protection_plan_id_app_01 = "/subscriptions/xxxxx/resourceGroups/rg-ddos/providers/Microsoft.Network/ddosProtectionPlans/ddos-standard"
enable_ddos_protection_app_01  = false

#### vnet app 02 (backend) IPAM -> CTILEYXIPAM-App-Dev2-IPRange02
vnet_name_app_02               = "USEDCXS05HVNT07"
vnet_address_space_app_02      = ["10.19.51.128/25"]
subnet1_name_app_02            = "USEDCXS05HSBN18"
subnet2_name_app_02            = "USEDCXS05HSBN19"
subnet3_name_app_02            = "USEDCXS05HSBN20"
subnet1_address_prefix_app_02  = "10.19.51.128/27"
subnet2_address_prefix_app_02  = "10.19.51.160/27"
subnet3_address_prefix_app_02  = "10.19.51.192/26"
ddos_protection_plan_id_app_02 = "/subscriptions/xxxxx/resourceGroups/rg-ddos/providers/Microsoft.Network/ddosProtectionPlans/ddos-standard"
enable_ddos_protection_app_02  = false

################
### NSG #########
#################
#### NSG admin and app
nsg_app_name_01 = "USEDCXS05HNSG03"
nsg_app_name_02 = "USEDCXS05HNSG04"
nsg_app_name_03 = "USEDCXS05HNSG05"
nsg_app_name_04 = "USEDCXS05HNSG06"
nsg_app_name_05 = "USEDCXS05HNSG07"
nsg_app_name_06 = "USEDCXS05HNSG08"


additional_security_rules_nsg_admin_01 = [
  # {
  #   name                       = "Deny-RDP-SSH-Inbound"
  #   priority                   = 110
  #   direction                  = "Inbound"
  #   access                     = "Deny"
  #   protocol                   = "Tcp"
  #   source_port_range          = "*"
  #   destination_port_range     = "22-3389"
  #   source_address_prefix      = "*"
  #   destination_address_prefix = "*"
  # },

  { # rule GH runners actions
    name                       = "AllowVnetOutBoundOverwrite"
    priority                   = 200
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "VirtualNetwork"
  },
  { # rule GH runners actions
    name                   = "AllowOutBoundActions"
    priority               = 210
    direction              = "Outbound"
    access                 = "Allow"
    protocol               = "*"
    source_port_range      = "*"
    destination_port_range = "443"
    source_address_prefix  = "*"
    destination_address_prefixes = [
      "4.175.114.51/32", "20.102.35.120/32", "4.175.114.43/32", "20.72.125.48/32", "20.19.5.100/32",
      "20.7.92.46/32", "20.232.252.48/32", "52.186.44.51/32", "20.22.98.201/32", "20.246.184.240/32",
      "20.96.133.71/32", "20.253.2.203/32", "20.102.39.220/32", "20.81.127.181/32", "52.148.30.208/32",
      "20.14.42.190/32", "20.85.159.192/32", "52.224.205.173/32", "20.118.176.156/32", "20.236.207.188/32",
      "20.242.161.191/32", "20.166.216.139/32", "20.253.126.26/32", "52.152.245.137/32", "40.118.236.116/32",
      "20.185.75.138/32", "20.96.226.211/32", "52.167.78.33/32", "20.105.13.142/32", "20.253.95.3/32",
      "20.221.96.90/32", "51.138.235.85/32", "52.186.47.208/32", "20.7.220.66/32", "20.75.4.210/32",
      "20.120.75.171/32", "20.98.183.48/32", "20.84.200.15/32", "20.14.235.135/32", "20.10.226.54/32",
      "20.22.166.15/32", "20.65.21.88/32", "20.102.36.236/32", "20.124.56.57/32", "20.94.100.174/32",
      "20.102.166.33/32", "20.31.193.160/32", "20.232.77.7/32", "20.102.38.122/32", "20.102.39.57/32",
      "20.85.108.33/32", "40.88.240.168/32", "20.69.187.19/32", "20.246.192.124/32", "20.4.161.108/32",
      "20.22.22.84/32", "20.1.250.47/32", "20.237.33.78/32", "20.242.179.206/32", "40.88.239.133/32",
      "20.121.247.125/32", "20.106.107.180/32", "20.22.118.40/32", "20.15.240.48/32", "20.84.218.150/32"
    ]
  },
  { # rule GH runners actions
    name                   = "AllowOutBoundGitHub"
    priority               = 220
    direction              = "Outbound"
    access                 = "Allow"
    protocol               = "*"
    source_port_range      = "*"
    destination_port_range = "443"
    source_address_prefix  = "*"
    destination_address_prefixes = [
      "140.82.112.0/20", "143.55.64.0/20", "185.199.108.0/22", "192.30.252.0/22", "20.175.192.146/32",
      "20.175.192.147/32", "20.175.192.149/32", "20.175.192.150/32", "20.199.39.227/32", "20.199.39.228/32",
      "20.199.39.231/32", "20.199.39.232/32", "20.200.245.241/32", "20.200.245.245/32", "20.200.245.246/32",
      "20.200.245.247/32", "20.200.245.248/32", "20.201.28.144/32", "20.201.28.148/32", "20.201.28.149/32",
      "20.201.28.151/32", "20.201.28.152/32", "20.205.243.160/32", "20.205.243.164/32", "20.205.243.165/32",
      "20.205.243.166/32", "20.205.243.168/32", "20.207.73.82/32", "20.207.73.83/32", "20.207.73.85/32",
      "20.207.73.86/32", "20.207.73.88/32", "20.217.135.1/32", "20.233.83.145/32", "20.233.83.146/32",
      "20.233.83.147/32", "20.233.83.149/32", "20.233.83.150/32", "20.248.137.48/32", "20.248.137.49/32",
      "20.248.137.50/32", "20.248.137.52/32", "20.248.137.55/32", "20.26.156.215/32", "20.26.156.216/32",
      "20.26.156.211/32", "20.27.177.113/32", "20.27.177.114/32", "20.27.177.116/32", "20.27.177.117/32",
      "20.27.177.118/32", "20.29.134.17/32", "20.29.134.18/32", "20.29.134.19/32", "20.29.134.23/32",
      "20.29.134.24/32", "20.87.245.0/32", "20.87.245.1/32", "20.87.245.4/32", "20.87.245.6/32", "20.87.245.7/32",
      "4.208.26.196/32", "4.208.26.197/32", "4.208.26.198/32", "4.208.26.199/32", "4.208.26.200/32",
      "4.225.11.196/32", "4.237.22.32/32", "108.143.221.96/28", "20.61.46.32/28", "20.224.62.160/28",
      "51.12.252.16/28", "74.241.131.48/28", "20.240.211.176/28"
    ]
  },
  { # rule GH runners actions
    name                       = "AllowStorageOutbound"
    priority                   = 230
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "Storage"
  },
]

additional_security_rules_nsg_app_01 = [
  {
    name                       = "IN_ALLOW_RUNNERS_EYX"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.47.47.0/27"] # CTILEYXIPAM-Admin-UAT-IPRange01
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
    source_address_prefixes    = ["10.19.53.160/27"] # subnet2_address_prefix_app_01
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
    source_address_prefixes    = ["10.19.53.192/26"] # subnet3_address_prefix_app_01
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
    destination_address_prefixes = ["10.19.53.128/27"] # subnet1_address_prefix_app_01
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
    destination_address_prefixes = ["10.19.53.192/26"] # subnet3_address_prefix_app_01
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
    destination_address_prefixes = ["10.19.51.128/27"] # subnet1_address_prefix_app_02
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
    destination_address_prefixes = ["10.19.51.160/27"] # subnet2_address_prefix_app_02
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
    destination_address_prefixes = ["10.19.51.192/26"] # subnet3_address_prefix_app_02
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
    source_address_prefixes    = ["10.47.47.0/27"] # CTILEYXIPAM-Admin-UAT-IPRange01
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
    source_address_prefixes    = ["10.19.53.160/27"] # subnet2_address_prefix_app_01
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
    destination_address_prefixes = ["10.19.53.128/27"] # subnet1_address_prefix_app_01
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
    destination_address_prefixes = ["10.19.51.160/27"] # subnet2_address_prefix_app_02
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
    source_address_prefixes    = ["10.47.47.0/27"] # CTILEYXIPAM-Admin-UAT-IPRange01
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
    source_address_prefixes    = ["10.19.53.160/27"] # subnet2_address_prefix_app_01
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
    source_address_prefixes    = ["10.47.47.0/27"] # CTILEYXIPAM-Admin-UAT-IPRange01
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
    source_address_prefixes    = ["10.19.53.160/27"] # subnet2_address_prefix_app_01
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
    source_address_prefixes    = ["10.19.53.192/26"] # subnet3_address_prefix_app_01
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

#################################
### GitHub Network Settings #####
#################################
github_network_settings_name = "USEDCXS05HGHNS01"
business_id                  = "8023"

###########################
### Private DNS Zones #####
###########################
enable_private_dns_zones = true