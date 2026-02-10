#####################
### GENERAL ##########
#####################
env = "QA"

tags = {
  DEPLOYMENT_ID        = "CXS05H"
  ENGAGEMENT_ID        = "I-68403024"
  OWNER                = "dante.ciai@gds.ey.com, juan.mercade@gds.ey.com, gustavo.sosa@gds.ey.com"
  ENVIRONMENT          = "QA"
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
route_table_apim_name   = "USEQCXS05HUDR01"

### VNET SPECIFIC TAGS
vnet_admin_tags = {
  "hidden-title"      = "EYX - QA - Runners VNET"
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
  "hidden-title" = "EYX - QA - APIM UDR"
}

github_settings_tags = {
  GitHubId = "5E2264237883C05B5BCA8C9226B1BF2B5D59B071F4DD85EF2614BA6DDF977890" # -> given on output
}

nsg_admin_tags = {
  "hidden-title" = "EYX - QA - Admin Runners Subnet NSG"
}

nsg_app_name_01_tags = {
  "hidden-title" = "EYX - QA - Frontend Inbound NSG"
}

nsg_app_name_02_tags = {
  "hidden-title" = "EYX - QA - App Services Outbound NSG"
}

nsg_app_name_03_tags = {
  "hidden-title" = "EYX - QA - APIM Integration"
}

nsg_app_name_04_tags = {
  "hidden-title" = "EYX - QA - Backend Inbound"
}

nsg_app_name_05_tags = {
  "hidden-title" = "EYX - QA - OpenAI Inbound"
}

nsg_app_name_06_tags = {
  "hidden-title" = "EYX - QA - ACA"
}

########################
### SHARED DATA ##########
#########################
resource_group_name_admin          = "USEQCXS05HRSG02"
resource_group_name_app            = "USEQCXS05HRSG03"
log_analytics_workspace_admin_name = "USEQCXS05HLAW01"
log_analytics_workspace_app_name   = "USEQCXS05HLAW02"

### VNETS
# #### vnet admin 01 IPAM -> CTILEYXIPAM-Admin-QA-IPRange01 10.47.133.32/27
# vnet_name_admin_01          = "USEQCXS05HVNT01"
# vnet_address_space_admin_01 = ["10.47.133.32/27"]
# subnet1_name                = "USEQCXS05HSBN01"
# subnet1_address_prefix      = "10.47.133.32/27"
# subnet2_name                = ""
# ddos_protection_plan_id     = "/subscriptions/xxxxx/resourceGroups/rg-ddos/providers/Microsoft.Network/ddosProtectionPlans/ddos-standard"
# enable_ddos_protection      = false

#### vnet app 01 (frontend) IPAM -> CTILEYXIPAM-App-QA-IPRange02 10.50.72.128/25
vnet_name_app_01               = "USEQCXS05HVNT02"
vnet_address_space_app_01      = ["10.50.72.128/25"]
subnet1_name_app_01            = "USEQCXS05HSBN03"
subnet2_name_app_01            = "USEQCXS05HSBN04"
subnet3_name_app_01            = "USEQCXS05HSBN05"
subnet1_address_prefix_app_01  = "10.50.72.128/28"
subnet2_address_prefix_app_01  = "10.50.72.160/27"
subnet3_address_prefix_app_01  = "10.50.72.192/26"
ddos_protection_plan_id_app_01 = "/subscriptions/xxxxx/resourceGroups/rg-ddos/providers/Microsoft.Network/ddosProtectionPlans/ddos-standard"
enable_ddos_protection_app_01  = false

#### vnet app 02 (backend) IPAM -> CTILEYXIPAM-App-QA-IPRange01 10.26.246.0/25
vnet_name_app_02               = "USEQCXS05HVNT03"
vnet_address_space_app_02      = ["10.26.246.0/25"]
subnet1_name_app_02            = "USEQCXS05HSBN06"
subnet2_name_app_02            = "USEQCXS05HSBN07"
subnet3_name_app_02            = "USEQCXS05HSBN08"
subnet1_address_prefix_app_02  = "10.26.246.0/27"
subnet2_address_prefix_app_02  = "10.26.246.32/27"
subnet3_address_prefix_app_02  = "10.26.246.64/26"
ddos_protection_plan_id_app_02 = "/subscriptions/xxxxx/resourceGroups/rg-ddos/providers/Microsoft.Network/ddosProtectionPlans/ddos-standard"
enable_ddos_protection_app_02  = false

################
### NSG #########
#################
#### NSG admin and app
# nsg_admin_name_01 = "USEQCXS05HNSG01"
# nsg_admin_name_02  = "USEQCXS05HNSG02"

nsg_app_name_01 = "USEQCXS05HNSG03"
nsg_app_name_02 = "USEQCXS05HNSG04"
nsg_app_name_03 = "USEQCXS05HNSG05"
nsg_app_name_04 = "USEQCXS05HNSG06"
nsg_app_name_05 = "USEQCXS05HNSG07"
nsg_app_name_06 = "USEQCXS05HNSG08"

# additional_security_rules_nsg_admin_01 = [

#   # {
#   #   name                       = "Deny-RDP-SSH-Inbound"
#   #   priority                   = 110
#   #   direction                  = "Inbound"
#   #   access                     = "Deny"
#   #   protocol                   = "Tcp"
#   #   source_port_range          = "*"
#   #   destination_port_range     = "22-3389"
#   #   source_address_prefix      = "*"
#   #   destination_address_prefix = "*"
#   # },

#   { # rule GH runners actions
#     name                       = "AllowVnetOutBoundOverwrite"
#     priority                   = 200
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "Tcp"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "VirtualNetwork"
#   },
#   { # rule GH runners actions
#     name                   = "AllowOutBoundActions"
#     priority               = 210
#     direction              = "Outbound"
#     access                 = "Allow"
#     protocol               = "*"
#     source_port_range      = "*"
#     destination_port_range = "443"
#     source_address_prefix  = "*"
#     destination_address_prefixes = [
#       "4.175.114.51/32", "20.102.35.120/32", "4.175.114.43/32", "20.72.125.48/32", "20.19.5.100/32",
#       "20.7.92.46/32", "20.232.252.48/32", "52.186.44.51/32", "20.22.98.201/32", "20.246.184.240/32",
#       "20.96.133.71/32", "20.253.2.203/32", "20.102.39.220/32", "20.81.127.181/32", "52.148.30.208/32",
#       "20.14.42.190/32", "20.85.159.192/32", "52.224.205.173/32", "20.118.176.156/32", "20.236.207.188/32",
#       "20.242.161.191/32", "20.166.216.139/32", "20.253.126.26/32", "52.152.245.137/32", "40.118.236.116/32",
#       "20.185.75.138/32", "20.96.226.211/32", "52.167.78.33/32", "20.105.13.142/32", "20.253.95.3/32",
#       "20.221.96.90/32", "51.138.235.85/32", "52.186.47.208/32", "20.7.220.66/32", "20.75.4.210/32",
#       "20.120.75.171/32", "20.98.183.48/32", "20.84.200.15/32", "20.14.235.135/32", "20.10.226.54/32",
#       "20.22.166.15/32", "20.65.21.88/32", "20.102.36.236/32", "20.124.56.57/32", "20.94.100.174/32",
#       "20.102.166.33/32", "20.31.193.160/32", "20.232.77.7/32", "20.102.38.122/32", "20.102.39.57/32",
#       "20.85.108.33/32", "40.88.240.168/32", "20.69.187.19/32", "20.246.192.124/32", "20.4.161.108/32",
#       "20.22.22.84/32", "20.1.250.47/32", "20.237.33.78/32", "20.242.179.206/32", "40.88.239.133/32",
#       "20.121.247.125/32", "20.106.107.180/32", "20.22.118.40/32", "20.15.240.48/32", "20.84.218.150/32"
#     ]
#   },
#   { # rule GH runners actions
#     name                   = "AllowOutBoundGitHub"
#     priority               = 220
#     direction              = "Outbound"
#     access                 = "Allow"
#     protocol               = "*"
#     source_port_range      = "*"
#     destination_port_range = "443"
#     source_address_prefix  = "*"
#     destination_address_prefixes = [
#       "140.82.112.0/20", "143.55.64.0/20", "185.199.108.0/22", "192.30.252.0/22", "20.175.192.146/32",
#       "20.175.192.147/32", "20.175.192.149/32", "20.175.192.150/32", "20.199.39.227/32", "20.199.39.228/32",
#       "20.199.39.231/32", "20.199.39.232/32", "20.200.245.241/32", "20.200.245.245/32", "20.200.245.246/32",
#       "20.200.245.247/32", "20.200.245.248/32", "20.201.28.144/32", "20.201.28.148/32", "20.201.28.149/32",
#       "20.201.28.151/32", "20.201.28.152/32", "20.205.243.160/32", "20.205.243.164/32", "20.205.243.165/32",
#       "20.205.243.166/32", "20.205.243.168/32", "20.207.73.82/32", "20.207.73.83/32", "20.207.73.85/32",
#       "20.207.73.86/32", "20.207.73.88/32", "20.217.135.1/32", "20.233.83.145/32", "20.233.83.146/32",
#       "20.233.83.147/32", "20.233.83.149/32", "20.233.83.150/32", "20.248.137.48/32", "20.248.137.49/32",
#       "20.248.137.50/32", "20.248.137.52/32", "20.248.137.55/32", "20.26.156.215/32", "20.26.156.216/32",
#       "20.26.156.211/32", "20.27.177.113/32", "20.27.177.114/32", "20.27.177.116/32", "20.27.177.117/32",
#       "20.27.177.118/32", "20.29.134.17/32", "20.29.134.18/32", "20.29.134.19/32", "20.29.134.23/32",
#       "20.29.134.24/32", "20.87.245.0/32", "20.87.245.1/32", "20.87.245.4/32", "20.87.245.6/32", "20.87.245.7/32",
#       "4.208.26.196/32", "4.208.26.197/32", "4.208.26.198/32", "4.208.26.199/32", "4.208.26.200/32",
#       "4.225.11.196/32", "4.237.22.32/32", "108.143.221.96/28", "20.61.46.32/28", "20.224.62.160/28",
#       "51.12.252.16/28", "74.241.131.48/28", "20.240.211.176/28"
#     ]
#   },
#   { # rule GH runners actions
#     name                       = "AllowStorageOutbound"
#     priority                   = 230
#     direction                  = "Outbound"
#     access                     = "Allow"
#     protocol                   = "*"
#     source_port_range          = "*"
#     destination_port_range     = "443"
#     source_address_prefix      = "*"
#     destination_address_prefix = "Storage"
#   },
# ]

additional_security_rules_nsg_app_01 = [
  # ============================================================================
  # QA NSG Rules - Synced from Azure
  # NSG: USEQCXS05HNSG03
  # Total Rules: 40
  # ============================================================================
  {
    name                       = "COBANI_PROHIBITED_INBOUND_PORTS_FROM_INTERNET_01"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Cobani Prohibited Ports. Rule to block non-compliant ports as per EY standards FROM Internet"
    source_port_range          = "*"
    destination_port_ranges    = ["21", "22", "23", "53", "69", "137", "139", "445", "1433", "1521", "3306", "3389", "5432", "6379", "16379", "26379"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  },
  {
    name                       = "COBANI_PROHIBITED_INBOUND_PORTS_FROM_INTERNET_02"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Cobani Prohibited Ports. Rule to block non-compliant ports as per EY standards FROM AzureCloud"
    source_port_range          = "*"
    destination_port_ranges    = ["21", "22", "23", "53", "69", "137", "138", "139", "445", "1433", "1521", "3306", "3389", "5432", "6379", "16379", "26379"]
    source_address_prefix      = "AzureCloud"
    destination_address_prefix = "*"
  },
  {
    name                       = "AllowClientCommunication"
    priority                   = 110
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "AllowManagementEndpoint"
    priority                   = 120
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "AllowApiManagement"
    priority                   = 130
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "ApiManagement"
  },
  {
    name                       = "IN_ALLOW_RUNNERS_EYX"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.47.133.32/27"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_APPSERVICES_EYX"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Inbound from App Services Outbound Subnet"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.50.72.160/27"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_FEAPIM_EYX"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "10.50.72.192/26"
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_SEP"
    priority                     = 3000
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow HTTPS egress for Infosec SEP Agents"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "*"
    destination_address_prefixes = ["20.198.151.200", "52.236.38.4", "23.100.75.253"]
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_CARBON_BLACK"
    priority                     = 3001
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow HTTPS egress for Infosec Carbon Black Agents"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "*"
    destination_address_prefixes = ["54.80.9.251", "54.224.202.203", "54.197.54.26", "54.179.74.200", "52.77.145.228", "52.72.67.58", "52.58.217.150", "52.58.173.11", "52.58.111.119", "52.57.221.230", "52.29.67.107", "52.29.181.196", "52.29.121.244", "52.28.35.189", "52.0.222.234", "35.171.118.30", "35.168.188.124", "35.157.199.46", "35.156.8.210", "35.156.42.146", "34.230.217.172", "34.205.118.98", "3.94.23.182", "3.93.84.172", "3.70.4.218", "3.69.203.130", "3.65.23.147", "3.226.151.161", "3.220.4.137", "3.212.56.146", "3.123.62.84", "3.123.219.203", "3.121.11.6", "3.120.221.118", "3.1.94.113", "3.0.38.166", "3.0.178.236", "23.20.250.13", "18.233.70.44", "18.233.38.138", "18.233.251.216", "18.233.186.95", "18.204.110.121", "18.198.87.35", "18.197.26.68", "18.196.67.59", "18.196.128.53", "18.195.17.51", "18.195.126.135", "18.194.170.94", "18.185.19.144", "18.184.96.108", "18.184.89.131", "18.184.110.91", "18.156.44.184", "18.139.29.16", "18.138.219.131", "18.138.148.155", "18.136.0.23", "13.251.69.42", "13.250.167.77", "13.250.163.109", "13.250.154.51", "13.250.130.161"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_DNS_IN_01"
    priority                   = 3400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Platform DNS Server to resolve DNS in tenant domains"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_DNS_OUT-01"
    priority                     = 3400
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow DNS services to resolve port 53 on platform domain controllers"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32", "168.63.129.16", "169.254.169.254"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_CYBERARK_TCP_IN"
    priority                   = 3401
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow CyberArk CPM service "
    source_port_range          = "*"
    destination_port_ranges    = ["22", "135", "139", "445", "49152-65535"]
    source_address_prefixes    = ["10.143.46.108", "10.146.156.227", "10.151.109.3", "10.151.109.4", "10.152.108.21"]
    destination_address_prefix = "10.0.0.0/8"
  },
  {
    name                       = "OUT_ALLOW_PLATFORM_SMTP_OUT-01"
    priority                   = 3401
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow SMTP Relay connectivity for use of SendGrid Email SMTP relay Services"
    source_port_range          = "*"
    destination_port_ranges    = ["25", "2525", "587", "465"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_SNAT_DNAT_OUT-01"
    priority                     = 3402
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow SNAT and DNAT pools on platform F5 servers for Site to site connectivity"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefix        = "*"
    destination_address_prefixes = ["172.22.0.0/16", "10.44.8.0/23", "10.45.8.0/23", "10.48.8.0/23", "10.48.168.0/23"]
  },
  {
    name                       = "IN_ALLOW_INFOSEC_Qualys_Scanner"
    priority                   = 3402
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Qualys Scanner to scan IP resources"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.42.46.160/27", "10.46.200.160/27", "10.47.2.0/27"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_PUPPET_OUT-01"
    priority                     = 3403
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow Puppet Agents to communicate with Master Servers"
    source_port_range            = "*"
    destination_port_range       = "8140"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.45.5.6", "10.44.5.4", "10.45.5.8"]
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_NTP"
    priority                     = 3404
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Udp"
    description                  = "Allow platform level NTP server communication"
    source_port_range            = "*"
    destination_port_range       = "123"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69"]
  },
  {
    name                       = "IN_ALLOW_F5_SNAT-DNAT_POOL_IN"
    priority                   = 3405
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow DNAT pool inbound from IPSec"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_BOTH"
    priority                     = 3405
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_ranges      = ["88", "137", "389", "464", "53", "49152-49652"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_RDS_SERVERS"
    priority                   = 3406
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow platform jump server"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.48.4.70", "10.48.4.71", "10.48.4.72", "10.48.4.73", "10.45.4.70", "10.45.4.71", "10.45.4.72", "10.45.4.73", "10.44.4.70", "10.44.4.71", "10.44.4.72", "10.44.4.73", "10.44.164.70", "10.44.164.71", "10.44.164.72", "10.44.164.73"]
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_AzureLB_In"
    priority                   = 3407
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Azure Load Balancer Access"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_F5_P2S_SNAT"
    priority                   = 3408
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow point to site SNAT addresses"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32", "10.44.164.6/32", "10.44.164.7/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_Qualys"
    priority                     = 3409
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow Qualys Agents to reach Qualys Services"
    source_port_range            = "*"
    destination_port_ranges      = ["80", "443", "8443"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["64.39.96.0/20", "162.159.152.21", "162.159.153.243"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_TCP"
    priority                   = 3410
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_ranges    = ["135", "136", "139", "445", "636", "3268", "3269", "50000", "50005", "60000"]
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_TCP"
    priority                     = 3410
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_ranges      = ["135", "136", "139", "445", "636", "3268", "3269", "50000", "50005", "60000"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_UDP"
    priority                   = 3411
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_range     = "138"
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_UDP"
    priority                     = 3411
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Udp"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_range       = "138"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_BOTH_IN"
    priority                   = 3414
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_ranges    = ["88", "137", "389", "464", "53", "49152-49652"]
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_ALLOW_FILESHARE_STORAGE_OUTBOUND-01"
    priority                   = 3420
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow 445 egress to storage service tag"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = "*"
    destination_address_prefix = "Storage"
  },
  {
    name                       = "IN_DENY_FILESHARE_INTERNET_IN"
    priority                   = 3421
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all inbound traffic ingress on known NETBIOS ports"
    source_port_range          = "*"
    destination_port_ranges    = ["137", "138", "139", "445"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_DENY_FILESHARE_INTERNET_OUTBOUND-01"
    priority                   = 3421
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all outbound traffic egress on known NETBIOS Ports"
    source_port_range          = "*"
    destination_port_ranges    = ["137", "138", "139", "445"]
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  },
  {
    name                       = "OUT_ALLOW_AZURE_PLATFORM_OUTBOUND-01"
    priority                   = 3900
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Provides outbound communication with Microsoft Azure Platform services"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  },
  {
    name                       = "OUT_ALLOW_AZURE_SITE_RECOVERY_HEALTHCHECK_OUTBOUND-01"
    priority                   = 3902
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Provides outbound communication with Microsoft Azure Site Recovery services"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  },
  {
    name                       = "OUT_ALLOW_HTTP_HTTPS_ANY_OUTBOUND-01"
    priority                   = 3990
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow HTTPS egress - TEMPORARY"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "80"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_ALLOW_MGMTPORTS_CTP_OUTBOUND-01"
    priority                   = 3999
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow CTP traffic egress on known MGMT ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32"]
    destination_address_prefix = "10.0.0.0/8"
  },
  {
    name                       = "IN_DENY_MGMTPORTS_ANY_IN"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    description                = "Deny all inbound traffic ingress on known MGMT ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_DENY_MGMTPORTS_ANY_OUTBOUND-01"
    priority                   = 4000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    description                = "Deny all outbound traffic egress on known MGMT Ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_DENY_INBOUND_TRAFFIC"
    priority                   = 4010
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all inbound traffic to any address space and any port"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Default-Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

additional_security_rules_nsg_app_02 = [
  # ============================================================================
  # QA NSG Rules - Synced from Azure
  # NSG: USEQCXS05HNSG04
  # Total Rules: 40
  # ============================================================================
  {
    name                       = "COBANI_PROHIBITED_INBOUND_PORTS_FROM_INTERNET_01"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Cobani Prohibited Ports. Rule to block non-compliant ports as per EY standards FROM Internet"
    source_port_range          = "*"
    destination_port_ranges    = ["21", "22", "23", "53", "69", "137", "139", "445", "1433", "1521", "3306", "3389", "5432", "6379", "16379", "26379"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  },
  {
    name                       = "COBANI_PROHIBITED_INBOUND_PORTS_FROM_INTERNET_02"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Cobani Prohibited Ports. Rule to block non-compliant ports as per EY standards FROM AzureCloud"
    source_port_range          = "*"
    destination_port_ranges    = ["21", "22", "23", "53", "69", "137", "138", "139", "445", "1433", "1521", "3306", "3389", "5432", "6379", "16379", "26379"]
    source_address_prefix      = "AzureCloud"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_ALLOW_APPSERVICES_EYX"
    priority                   = 1000
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "10.50.72.128/28"
  },
  {
    name                       = "OUT_ALLOW_APIM_EYX"
    priority                   = 1002
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "10.50.72.192/26"
  },
  {
    name                       = "OUT_ALLOW_BEPEP_EYX"
    priority                   = 1003
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "10.26.246.0/27"
  },
  {
    name                       = "OUT_ALLOW_OAIPEP_EYX"
    priority                   = 1004
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow Traffic to OpenAI Private Endpoints"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "10.26.246.32/27"
  },
  {
    name                       = "OUT_ALLOW_ACE_EYX"
    priority                   = 1005
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Traffic to Azure Container Environments"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "10.26.246.64/26"
  },
  {
    name                       = "OUT_ALLOW_SIGNAL_EYX"
    priority                   = 1006
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureSignalR"
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_SEP"
    priority                     = 3000
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow HTTPS egress for Infosec SEP Agents"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "*"
    destination_address_prefixes = ["20.198.151.200", "52.236.38.4", "23.100.75.253"]
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_CARBON_BLACK"
    priority                     = 3001
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow HTTPS egress for Infosec Carbon Black Agents"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "*"
    destination_address_prefixes = ["54.80.9.251", "54.224.202.203", "54.197.54.26", "54.179.74.200", "52.77.145.228", "52.72.67.58", "52.58.217.150", "52.58.173.11", "52.58.111.119", "52.57.221.230", "52.29.67.107", "52.29.181.196", "52.29.121.244", "52.28.35.189", "52.0.222.234", "35.171.118.30", "35.168.188.124", "35.157.199.46", "35.156.8.210", "35.156.42.146", "34.230.217.172", "34.205.118.98", "3.94.23.182", "3.93.84.172", "3.70.4.218", "3.69.203.130", "3.65.23.147", "3.226.151.161", "3.220.4.137", "3.212.56.146", "3.123.62.84", "3.123.219.203", "3.121.11.6", "3.120.221.118", "3.1.94.113", "3.0.38.166", "3.0.178.236", "23.20.250.13", "18.233.70.44", "18.233.38.138", "18.233.251.216", "18.233.186.95", "18.204.110.121", "18.198.87.35", "18.197.26.68", "18.196.67.59", "18.196.128.53", "18.195.17.51", "18.195.126.135", "18.194.170.94", "18.185.19.144", "18.184.96.108", "18.184.89.131", "18.184.110.91", "18.156.44.184", "18.139.29.16", "18.138.219.131", "18.138.148.155", "18.136.0.23", "13.251.69.42", "13.250.167.77", "13.250.163.109", "13.250.154.51", "13.250.130.161"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_DNS_IN_01"
    priority                   = 3400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Platform DNS Server to resolve DNS in tenant domains"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_DNS_OUT-01"
    priority                     = 3400
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow DNS services to resolve port 53 on platform domain controllers"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32", "168.63.129.16", "169.254.169.254"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_CYBERARK_TCP_IN"
    priority                   = 3401
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow CyberArk CPM service "
    source_port_range          = "*"
    destination_port_ranges    = ["22", "135", "139", "445", "49152-65535"]
    source_address_prefixes    = ["10.143.46.108", "10.146.156.227", "10.151.109.3", "10.151.109.4", "10.152.108.21"]
    destination_address_prefix = "10.0.0.0/8"
  },
  {
    name                       = "OUT_ALLOW_PLATFORM_SMTP_OUT-01"
    priority                   = 3401
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow SMTP Relay connectivity for use of SendGrid Email SMTP relay Services"
    source_port_range          = "*"
    destination_port_ranges    = ["25", "2525", "587", "465"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_SNAT_DNAT_OUT-01"
    priority                     = 3402
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow SNAT and DNAT pools on platform F5 servers for Site to site connectivity"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefix        = "*"
    destination_address_prefixes = ["172.22.0.0/16", "10.44.8.0/23", "10.45.8.0/23", "10.48.8.0/23", "10.48.168.0/23"]
  },
  {
    name                       = "IN_ALLOW_INFOSEC_Qualys_Scanner"
    priority                   = 3402
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Qualys Scanner to scan IP resources"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.42.46.160/27", "10.46.200.160/27", "10.47.2.0/27"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_PUPPET_OUT-01"
    priority                     = 3403
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow Puppet Agents to communicate with Master Servers"
    source_port_range            = "*"
    destination_port_range       = "8140"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.45.5.6", "10.44.5.4", "10.45.5.8"]
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_NTP"
    priority                     = 3404
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Udp"
    description                  = "Allow platform level NTP server communication"
    source_port_range            = "*"
    destination_port_range       = "123"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69"]
  },
  {
    name                       = "IN_ALLOW_F5_SNAT-DNAT_POOL_IN"
    priority                   = 3405
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow DNAT pool inbound from IPSec"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_BOTH"
    priority                     = 3405
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_ranges      = ["88", "137", "389", "464", "53", "49152-49652"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_RDS_SERVERS"
    priority                   = 3406
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow platform jump server"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.48.4.70", "10.48.4.71", "10.48.4.72", "10.48.4.73", "10.45.4.70", "10.45.4.71", "10.45.4.72", "10.45.4.73", "10.44.4.70", "10.44.4.71", "10.44.4.72", "10.44.4.73", "10.44.164.70", "10.44.164.71", "10.44.164.72", "10.44.164.73"]
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_AzureLB_In"
    priority                   = 3407
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Azure Load Balancer Access"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_F5_P2S_SNAT"
    priority                   = 3408
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow point to site SNAT addresses"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32", "10.44.164.6/32", "10.44.164.7/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_Qualys"
    priority                     = 3409
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow Qualys Agents to reach Qualys Services"
    source_port_range            = "*"
    destination_port_ranges      = ["80", "443", "8443"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["64.39.96.0/20", "162.159.152.21", "162.159.153.243"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_TCP"
    priority                   = 3410
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_ranges    = ["135", "136", "139", "445", "636", "3268", "3269", "50000", "50005", "60000"]
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_TCP"
    priority                     = 3410
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_ranges      = ["135", "136", "139", "445", "636", "3268", "3269", "50000", "50005", "60000"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_UDP"
    priority                   = 3411
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_range     = "138"
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_UDP"
    priority                     = 3411
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Udp"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_range       = "138"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_BOTH_IN"
    priority                   = 3414
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_ranges    = ["88", "137", "389", "464", "53", "49152-49652"]
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_ALLOW_FILESHARE_STORAGE_OUTBOUND-01"
    priority                   = 3420
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow 445 egress to storage service tag"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = "*"
    destination_address_prefix = "Storage"
  },
  {
    name                       = "IN_DENY_FILESHARE_INTERNET_IN"
    priority                   = 3421
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all inbound traffic ingress on known NETBIOS ports"
    source_port_range          = "*"
    destination_port_ranges    = ["137", "138", "139", "445"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_DENY_FILESHARE_INTERNET_OUTBOUND-01"
    priority                   = 3421
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all outbound traffic egress on known NETBIOS Ports"
    source_port_range          = "*"
    destination_port_ranges    = ["137", "138", "139", "445"]
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  },
  {
    name                       = "OUT_ALLOW_AZURE_PLATFORM_OUTBOUND-01"
    priority                   = 3900
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Provides outbound communication with Microsoft Azure Platform services"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  },
  {
    name                       = "OUT_ALLOW_AZURE_SITE_RECOVERY_HEALTHCHECK_OUTBOUND-01"
    priority                   = 3902
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Provides outbound communication with Microsoft Azure Site Recovery services"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  },
  {
    name                       = "OUT_ALLOW_HTTP_HTTPS_ANY_OUTBOUND-01"
    priority                   = 3990
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow HTTPS egress - TEMPORARY"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "80"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_ALLOW_MGMTPORTS_CTP_OUTBOUND-01"
    priority                   = 3999
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow CTP traffic egress on known MGMT ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32"]
    destination_address_prefix = "10.0.0.0/8"
  },
  {
    name                       = "IN_DENY_MGMTPORTS_ANY_IN"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    description                = "Deny all inbound traffic ingress on known MGMT ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_DENY_MGMTPORTS_ANY_OUTBOUND-01"
    priority                   = 4000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    description                = "Deny all outbound traffic egress on known MGMT Ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_DENY_INBOUND_TRAFFIC"
    priority                   = 4010
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all inbound traffic to any address space and any port"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Default-Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

additional_security_rules_nsg_app_03 = [
  # ============================================================================
  # QA NSG Rules - Synced from Azure
  # NSG: USEQCXS05HNSG05
  # Total Rules: 49
  # ============================================================================
  {
    name                       = "COBANI_PROHIBITED_INBOUND_PORTS_FROM_INTERNET_01"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Cobani Prohibited Ports. Rule to block non-compliant ports as per EY standards FROM Internet"
    source_port_range          = "*"
    destination_port_ranges    = ["21", "22", "23", "53", "69", "137", "139", "445", "1433", "1521", "3306", "3389", "5432", "6379", "16379", "26379"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  },
  {
    name                       = "COBANI_PROHIBITED_INBOUND_PORTS_FROM_INTERNET_02"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Cobani Prohibited Ports. Rule to block non-compliant ports as per EY standards FROM AzureCloud"
    source_port_range          = "*"
    destination_port_ranges    = ["21", "22", "23", "53", "69", "137", "138", "139", "445", "1433", "1521", "3306", "3389", "5432", "6379", "16379", "26379"]
    source_address_prefix      = "AzureCloud"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_RUNNERS_EYX"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.47.133.32/27"
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
    name                       = "IN_ALLOW_INTERNET_APIM_EYX"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "Internet"
    destination_address_prefix = "VirtualNetwork"
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
    destination_address_prefix = "Sql"
  },
  {
    name                       = "IN_ALLOW_APIM_EYX"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3443"
    source_address_prefix      = "ApiManagement"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "OUT_ALLOW_KVAPIM_EYX"
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
    name                       = "IN_ALLOW_APIMLB_EYX"
    priority                   = 1003
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "6390"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "OUT_ALLOW_MONAPIM_EYX"
    priority                   = 1003
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_ranges    = ["1886", "443"]
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "AzureMonitor"
  },
  {
    name                       = "IN_ALLOW_TMAPIM_EYX"
    priority                   = 1004
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureTrafficManager"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "OUT_ALLOW_WEBAPPS_EYX"
    priority                   = 1004
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "10.50.72.128/28"
  },
  {
    name                       = "IN_ALLOW_FRONTDOOR_EYX"
    priority                   = 1005
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureFrontDoor.Backend"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "OUT_ALLOW_VNET_EYX"
    priority                   = 1005
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_APPSERV_EYX"
    priority                   = 1006
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.50.72.160/27"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "OUT_ALLOW_BEOAI_EYX"
    priority                   = 1006
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "*"
    destination_address_prefix = "10.26.246.32/27"
  },
  {
    name                       = "IN_ALLOW_VNET_EYX"
    priority                   = 1007
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "VirtualNetwork"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_SEP"
    priority                     = 3000
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow HTTPS egress for Infosec SEP Agents"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "*"
    destination_address_prefixes = ["20.198.151.200", "52.236.38.4", "23.100.75.253"]
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_CARBON_BLACK"
    priority                     = 3001
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow HTTPS egress for Infosec Carbon Black Agents"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "*"
    destination_address_prefixes = ["54.80.9.251", "54.224.202.203", "54.197.54.26", "54.179.74.200", "52.77.145.228", "52.72.67.58", "52.58.217.150", "52.58.173.11", "52.58.111.119", "52.57.221.230", "52.29.67.107", "52.29.181.196", "52.29.121.244", "52.28.35.189", "52.0.222.234", "35.171.118.30", "35.168.188.124", "35.157.199.46", "35.156.8.210", "35.156.42.146", "34.230.217.172", "34.205.118.98", "3.94.23.182", "3.93.84.172", "3.70.4.218", "3.69.203.130", "3.65.23.147", "3.226.151.161", "3.220.4.137", "3.212.56.146", "3.123.62.84", "3.123.219.203", "3.121.11.6", "3.120.221.118", "3.1.94.113", "3.0.38.166", "3.0.178.236", "23.20.250.13", "18.233.70.44", "18.233.38.138", "18.233.251.216", "18.233.186.95", "18.204.110.121", "18.198.87.35", "18.197.26.68", "18.196.67.59", "18.196.128.53", "18.195.17.51", "18.195.126.135", "18.194.170.94", "18.185.19.144", "18.184.96.108", "18.184.89.131", "18.184.110.91", "18.156.44.184", "18.139.29.16", "18.138.219.131", "18.138.148.155", "18.136.0.23", "13.251.69.42", "13.250.167.77", "13.250.163.109", "13.250.154.51", "13.250.130.161"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_DNS_IN_01"
    priority                   = 3400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Platform DNS Server to resolve DNS in tenant domains"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_DNS_OUT-01"
    priority                     = 3400
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow DNS services to resolve port 53 on platform domain controllers"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32", "168.63.129.16", "169.254.169.254"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_CYBERARK_TCP_IN"
    priority                   = 3401
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow CyberArk CPM service "
    source_port_range          = "*"
    destination_port_ranges    = ["22", "135", "139", "445", "49152-65535"]
    source_address_prefixes    = ["10.143.46.108", "10.146.156.227", "10.151.109.3", "10.151.109.4", "10.152.108.21"]
    destination_address_prefix = "10.0.0.0/8"
  },
  {
    name                       = "OUT_ALLOW_PLATFORM_SMTP_OUT-01"
    priority                   = 3401
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow SMTP Relay connectivity for use of SendGrid Email SMTP relay Services"
    source_port_range          = "*"
    destination_port_ranges    = ["25", "2525", "587", "465"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_SNAT_DNAT_OUT-01"
    priority                     = 3402
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow SNAT and DNAT pools on platform F5 servers for Site to site connectivity"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefix        = "*"
    destination_address_prefixes = ["172.22.0.0/16", "10.44.8.0/23", "10.45.8.0/23", "10.48.8.0/23", "10.48.168.0/23"]
  },
  {
    name                       = "IN_ALLOW_INFOSEC_Qualys_Scanner"
    priority                   = 3402
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Qualys Scanner to scan IP resources"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.42.46.160/27", "10.46.200.160/27", "10.47.2.0/27"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_PUPPET_OUT-01"
    priority                     = 3403
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow Puppet Agents to communicate with Master Servers"
    source_port_range            = "*"
    destination_port_range       = "8140"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.45.5.6", "10.44.5.4", "10.45.5.8"]
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_NTP"
    priority                     = 3404
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Udp"
    description                  = "Allow platform level NTP server communication"
    source_port_range            = "*"
    destination_port_range       = "123"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69"]
  },
  {
    name                       = "IN_ALLOW_F5_SNAT-DNAT_POOL_IN"
    priority                   = 3405
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow DNAT pool inbound from IPSec"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_BOTH"
    priority                     = 3405
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_ranges      = ["88", "137", "389", "464", "53", "49152-49652"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_RDS_SERVERS"
    priority                   = 3406
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow platform jump server"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.48.4.70", "10.48.4.71", "10.48.4.72", "10.48.4.73", "10.45.4.70", "10.45.4.71", "10.45.4.72", "10.45.4.73", "10.44.4.70", "10.44.4.71", "10.44.4.72", "10.44.4.73", "10.44.164.70", "10.44.164.71", "10.44.164.72", "10.44.164.73"]
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_AzureLB_In"
    priority                   = 3407
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Azure Load Balancer Access"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_F5_P2S_SNAT"
    priority                   = 3408
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow point to site SNAT addresses"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32", "10.44.164.6/32", "10.44.164.7/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_Qualys"
    priority                     = 3409
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow Qualys Agents to reach Qualys Services"
    source_port_range            = "*"
    destination_port_ranges      = ["80", "443", "8443"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["64.39.96.0/20", "162.159.152.21", "162.159.153.243"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_TCP"
    priority                   = 3410
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_ranges    = ["135", "136", "139", "445", "636", "3268", "3269", "50000", "50005", "60000"]
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_TCP"
    priority                     = 3410
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_ranges      = ["135", "136", "139", "445", "636", "3268", "3269", "50000", "50005", "60000"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_UDP"
    priority                   = 3411
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_range     = "138"
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_UDP"
    priority                     = 3411
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Udp"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_range       = "138"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_BOTH_IN"
    priority                   = 3414
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_ranges    = ["88", "137", "389", "464", "53", "49152-49652"]
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_ALLOW_FILESHARE_STORAGE_OUTBOUND-01"
    priority                   = 3420
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow 445 egress to storage service tag"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = "*"
    destination_address_prefix = "Storage"
  },
  {
    name                       = "IN_DENY_FILESHARE_INTERNET_IN"
    priority                   = 3421
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all inbound traffic ingress on known NETBIOS ports"
    source_port_range          = "*"
    destination_port_ranges    = ["137", "138", "139", "445"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_DENY_FILESHARE_INTERNET_OUTBOUND-01"
    priority                   = 3421
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all outbound traffic egress on known NETBIOS Ports"
    source_port_range          = "*"
    destination_port_ranges    = ["137", "138", "139", "445"]
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  },
  {
    name                       = "OUT_ALLOW_AZURE_PLATFORM_OUTBOUND-01"
    priority                   = 3900
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Provides outbound communication with Microsoft Azure Platform services"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  },
  {
    name                       = "OUT_ALLOW_AZURE_SITE_RECOVERY_HEALTHCHECK_OUTBOUND-01"
    priority                   = 3902
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Provides outbound communication with Microsoft Azure Site Recovery services"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  },
  {
    name                       = "OUT_ALLOW_HTTP_HTTPS_ANY_OUTBOUND-01"
    priority                   = 3990
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow HTTPS egress - TEMPORARY"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "80"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_ALLOW_MGMTPORTS_CTP_OUTBOUND-01"
    priority                   = 3999
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow CTP traffic egress on known MGMT ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32"]
    destination_address_prefix = "10.0.0.0/8"
  },
  {
    name                       = "IN_DENY_MGMTPORTS_ANY_IN"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    description                = "Deny all inbound traffic ingress on known MGMT ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_DENY_MGMTPORTS_ANY_OUTBOUND-01"
    priority                   = 4000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    description                = "Deny all outbound traffic egress on known MGMT Ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_DENY_INBOUND_TRAFFIC"
    priority                   = 4010
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all inbound traffic to any address space and any port"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Default-Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

additional_security_rules_nsg_app_04 = [
  # ============================================================================
  # QA NSG Rules - Synced from Azure
  # NSG: USEQCXS05HNSG06
  # Total Rules: 35
  # ============================================================================
  {
    name                       = "IN_ALLOW_RUNNERS_EYX"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.47.133.32/27"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_FRONTEND_EYX"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.50.72.128/25"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_VNET_EYX"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.26.246.0/25"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_SEP"
    priority                     = 3000
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow HTTPS egress for Infosec SEP Agents"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "*"
    destination_address_prefixes = ["20.198.151.200", "52.236.38.4", "23.100.75.253"]
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_CARBON_BLACK"
    priority                     = 3001
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow HTTPS egress for Infosec Carbon Black Agents"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "*"
    destination_address_prefixes = ["54.80.9.251", "54.224.202.203", "54.197.54.26", "54.179.74.200", "52.77.145.228", "52.72.67.58", "52.58.217.150", "52.58.173.11", "52.58.111.119", "52.57.221.230", "52.29.67.107", "52.29.181.196", "52.29.121.244", "52.28.35.189", "52.0.222.234", "35.171.118.30", "35.168.188.124", "35.157.199.46", "35.156.8.210", "35.156.42.146", "34.230.217.172", "34.205.118.98", "3.94.23.182", "3.93.84.172", "3.70.4.218", "3.69.203.130", "3.65.23.147", "3.226.151.161", "3.220.4.137", "3.212.56.146", "3.123.62.84", "3.123.219.203", "3.121.11.6", "3.120.221.118", "3.1.94.113", "3.0.38.166", "3.0.178.236", "23.20.250.13", "18.233.70.44", "18.233.38.138", "18.233.251.216", "18.233.186.95", "18.204.110.121", "18.198.87.35", "18.197.26.68", "18.196.67.59", "18.196.128.53", "18.195.17.51", "18.195.126.135", "18.194.170.94", "18.185.19.144", "18.184.96.108", "18.184.89.131", "18.184.110.91", "18.156.44.184", "18.139.29.16", "18.138.219.131", "18.138.148.155", "18.136.0.23", "13.251.69.42", "13.250.167.77", "13.250.163.109", "13.250.154.51", "13.250.130.161"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_DNS_IN_01"
    priority                   = 3400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Platform DNS Server to resolve DNS in tenant domains"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_DNS_OUT-01"
    priority                     = 3400
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow DNS services to resolve port 53 on platform domain controllers"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32", "168.63.129.16", "169.254.169.254"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_CYBERARK_TCP_IN"
    priority                   = 3401
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow CyberArk CPM service "
    source_port_range          = "*"
    destination_port_ranges    = ["22", "135", "139", "445", "49152-65535"]
    source_address_prefixes    = ["10.143.46.108", "10.146.156.227", "10.151.109.3", "10.151.109.4", "10.152.108.21"]
    destination_address_prefix = "10.0.0.0/8"
  },
  {
    name                       = "OUT_ALLOW_PLATFORM_SMTP_OUT-01"
    priority                   = 3401
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow SMTP Relay connectivity for use of SendGrid Email SMTP relay Services"
    source_port_range          = "*"
    destination_port_ranges    = ["25", "2525", "587", "465"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_SNAT_DNAT_OUT-01"
    priority                     = 3402
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow SNAT and DNAT pools on platform F5 servers for Site to site connectivity"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefix        = "*"
    destination_address_prefixes = ["172.22.0.0/16", "10.44.8.0/23", "10.45.8.0/23", "10.48.8.0/23", "10.48.168.0/23"]
  },
  {
    name                       = "IN_ALLOW_INFOSEC_Qualys_Scanner"
    priority                   = 3402
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Qualys Scanner to scan IP resources"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.42.46.160/27", "10.46.200.160/27", "10.47.2.0/27"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_PUPPET_OUT-01"
    priority                     = 3403
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow Puppet Agents to communicate with Master Servers"
    source_port_range            = "*"
    destination_port_range       = "8140"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.45.5.6", "10.44.5.4", "10.45.5.8"]
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_NTP"
    priority                     = 3404
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Udp"
    description                  = "Allow platform level NTP server communication"
    source_port_range            = "*"
    destination_port_range       = "123"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69"]
  },
  {
    name                       = "IN_ALLOW_F5_SNAT-DNAT_POOL_IN"
    priority                   = 3405
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow DNAT pool inbound from IPSec"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_BOTH"
    priority                     = 3405
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_ranges      = ["88", "137", "389", "464", "53", "49152-49652"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_RDS_SERVERS"
    priority                   = 3406
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow platform jump server"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.48.4.70", "10.48.4.71", "10.48.4.72", "10.48.4.73", "10.45.4.70", "10.45.4.71", "10.45.4.72", "10.45.4.73", "10.44.4.70", "10.44.4.71", "10.44.4.72", "10.44.4.73", "10.44.164.70", "10.44.164.71", "10.44.164.72", "10.44.164.73"]
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_AzureLB_In"
    priority                   = 3407
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Azure Load Balancer Access"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_F5_P2S_SNAT"
    priority                   = 3408
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow point to site SNAT addresses"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32", "10.44.164.6/32", "10.44.164.7/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_Qualys"
    priority                     = 3409
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow Qualys Agents to reach Qualys Services"
    source_port_range            = "*"
    destination_port_ranges      = ["80", "443", "8443"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["64.39.96.0/20", "162.159.152.21", "162.159.153.243"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_TCP"
    priority                   = 3410
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_ranges    = ["135", "136", "139", "445", "636", "3268", "3269", "50000", "50005", "60000"]
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_TCP"
    priority                     = 3410
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_ranges      = ["135", "136", "139", "445", "636", "3268", "3269", "50000", "50005", "60000"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_UDP"
    priority                   = 3411
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_range     = "138"
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_UDP"
    priority                     = 3411
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Udp"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_range       = "138"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_BOTH_IN"
    priority                   = 3414
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_ranges    = ["88", "137", "389", "464", "53", "49152-49652"]
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_ALLOW_FILESHARE_STORAGE_OUTBOUND-01"
    priority                   = 3420
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow 445 egress to storage service tag"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = "*"
    destination_address_prefix = "Storage"
  },
  {
    name                       = "IN_DENY_FILESHARE_INTERNET_IN"
    priority                   = 3421
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all inbound traffic ingress on known NETBIOS ports"
    source_port_range          = "*"
    destination_port_ranges    = ["137", "138", "139", "445"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_DENY_FILESHARE_INTERNET_OUTBOUND-01"
    priority                   = 3421
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all outbound traffic egress on known NETBIOS Ports"
    source_port_range          = "*"
    destination_port_ranges    = ["137", "138", "139", "445"]
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  },
  {
    name                       = "OUT_ALLOW_AZURE_PLATFORM_OUTBOUND-01"
    priority                   = 3900
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Provides outbound communication with Microsoft Azure Platform services"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  },
  {
    name                       = "OUT_ALLOW_AZURE_SITE_RECOVERY_HEALTHCHECK_OUTBOUND-01"
    priority                   = 3902
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Provides outbound communication with Microsoft Azure Site Recovery services"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  },
  {
    name                       = "OUT_ALLOW_HTTP_HTTPS_ANY_OUTBOUND-01"
    priority                   = 3990
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow HTTPS egress - TEMPORARY"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "80"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_ALLOW_MGMTPORTS_CTP_OUTBOUND-01"
    priority                   = 3999
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow CTP traffic egress on known MGMT ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32"]
    destination_address_prefix = "10.0.0.0/8"
  },
  {
    name                       = "IN_DENY_MGMTPORTS_ANY_IN"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    description                = "Deny all inbound traffic ingress on known MGMT ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_DENY_MGMTPORTS_ANY_OUTBOUND-01"
    priority                   = 4000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    description                = "Deny all outbound traffic egress on known MGMT Ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_DENY_INBOUND_TRAFFIC"
    priority                   = 4010
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all inbound traffic to any address space and any port"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Default-Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

additional_security_rules_nsg_app_05 = [
  # ============================================================================
  # QA NSG Rules - Synced from Azure
  # NSG: USEQCXS05HNSG07
  # Total Rules: 37
  # ============================================================================
  {
    name                       = "COBANI_PROHIBITED_INBOUND_PORTS_FROM_INTERNET_01"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Cobani Prohibited Ports. Rule to block non-compliant ports as per EY standards FROM Internet"
    source_port_range          = "*"
    destination_port_ranges    = ["21", "22", "23", "53", "69", "137", "139", "445", "1433", "1521", "3306", "3389", "5432", "6379", "16379", "26379"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  },
  {
    name                       = "COBANI_PROHIBITED_INBOUND_PORTS_FROM_INTERNET_02"
    priority                   = 101
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Cobani Prohibited Ports. Rule to block non-compliant ports as per EY standards FROM AzureCloud"
    source_port_range          = "*"
    destination_port_ranges    = ["21", "22", "23", "53", "69", "137", "138", "139", "445", "1433", "1521", "3306", "3389", "5432", "6379", "16379", "26379"]
    source_address_prefix      = "AzureCloud"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_RUNNERS_EYX"
    priority                   = 1000
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "8080"
    source_address_prefix      = "10.47.133.32/27"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_FRONTEND_EYX"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "10.50.72.128/25"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                       = "IN_ALLOW_APIM_EYX"
    priority                   = 1002
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow APIM Traffic"
    source_port_range          = "*"
    destination_port_range     = "443"
    source_address_prefix      = "10.50.72.192/26"
    destination_address_prefix = "VirtualNetwork"
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_SEP"
    priority                     = 3000
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow HTTPS egress for Infosec SEP Agents"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "*"
    destination_address_prefixes = ["20.198.151.200", "52.236.38.4", "23.100.75.253"]
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_CARBON_BLACK"
    priority                     = 3001
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow HTTPS egress for Infosec Carbon Black Agents"
    source_port_range            = "*"
    destination_port_range       = "443"
    source_address_prefix        = "*"
    destination_address_prefixes = ["54.80.9.251", "54.224.202.203", "54.197.54.26", "54.179.74.200", "52.77.145.228", "52.72.67.58", "52.58.217.150", "52.58.173.11", "52.58.111.119", "52.57.221.230", "52.29.67.107", "52.29.181.196", "52.29.121.244", "52.28.35.189", "52.0.222.234", "35.171.118.30", "35.168.188.124", "35.157.199.46", "35.156.8.210", "35.156.42.146", "34.230.217.172", "34.205.118.98", "3.94.23.182", "3.93.84.172", "3.70.4.218", "3.69.203.130", "3.65.23.147", "3.226.151.161", "3.220.4.137", "3.212.56.146", "3.123.62.84", "3.123.219.203", "3.121.11.6", "3.120.221.118", "3.1.94.113", "3.0.38.166", "3.0.178.236", "23.20.250.13", "18.233.70.44", "18.233.38.138", "18.233.251.216", "18.233.186.95", "18.204.110.121", "18.198.87.35", "18.197.26.68", "18.196.67.59", "18.196.128.53", "18.195.17.51", "18.195.126.135", "18.194.170.94", "18.185.19.144", "18.184.96.108", "18.184.89.131", "18.184.110.91", "18.156.44.184", "18.139.29.16", "18.138.219.131", "18.138.148.155", "18.136.0.23", "13.251.69.42", "13.250.167.77", "13.250.163.109", "13.250.154.51", "13.250.130.161"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_DNS_IN_01"
    priority                   = 3400
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Platform DNS Server to resolve DNS in tenant domains"
    source_port_range          = "*"
    destination_port_range     = "53"
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_DNS_OUT-01"
    priority                     = 3400
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow DNS services to resolve port 53 on platform domain controllers"
    source_port_range            = "*"
    destination_port_range       = "53"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32", "168.63.129.16", "169.254.169.254"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_CYBERARK_TCP_IN"
    priority                   = 3401
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow CyberArk CPM service "
    source_port_range          = "*"
    destination_port_ranges    = ["22", "135", "139", "445", "49152-65535"]
    source_address_prefixes    = ["10.143.46.108", "10.146.156.227", "10.151.109.3", "10.151.109.4", "10.152.108.21"]
    destination_address_prefix = "10.0.0.0/8"
  },
  {
    name                       = "OUT_ALLOW_PLATFORM_SMTP_OUT-01"
    priority                   = 3401
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow SMTP Relay connectivity for use of SendGrid Email SMTP relay Services"
    source_port_range          = "*"
    destination_port_ranges    = ["25", "2525", "587", "465"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_SNAT_DNAT_OUT-01"
    priority                     = 3402
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow SNAT and DNAT pools on platform F5 servers for Site to site connectivity"
    source_port_range            = "*"
    destination_port_range       = "*"
    source_address_prefix        = "*"
    destination_address_prefixes = ["172.22.0.0/16", "10.44.8.0/23", "10.45.8.0/23", "10.48.8.0/23", "10.48.168.0/23"]
  },
  {
    name                       = "IN_ALLOW_INFOSEC_Qualys_Scanner"
    priority                   = 3402
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Qualys Scanner to scan IP resources"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.42.46.160/27", "10.46.200.160/27", "10.47.2.0/27"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_PUPPET_OUT-01"
    priority                     = 3403
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow Puppet Agents to communicate with Master Servers"
    source_port_range            = "*"
    destination_port_range       = "8140"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.45.5.6", "10.44.5.4", "10.45.5.8"]
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_NTP"
    priority                     = 3404
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Udp"
    description                  = "Allow platform level NTP server communication"
    source_port_range            = "*"
    destination_port_range       = "123"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69"]
  },
  {
    name                       = "IN_ALLOW_F5_SNAT-DNAT_POOL_IN"
    priority                   = 3405
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow DNAT pool inbound from IPSec"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_BOTH"
    priority                     = 3405
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "*"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_ranges      = ["88", "137", "389", "464", "53", "49152-49652"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_RDS_SERVERS"
    priority                   = 3406
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow platform jump server"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.48.4.70", "10.48.4.71", "10.48.4.72", "10.48.4.73", "10.45.4.70", "10.45.4.71", "10.45.4.72", "10.45.4.73", "10.44.4.70", "10.44.4.71", "10.44.4.72", "10.44.4.73", "10.44.164.70", "10.44.164.71", "10.44.164.72", "10.44.164.73"]
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_AzureLB_In"
    priority                   = 3407
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow Azure Load Balancer Access"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "AzureLoadBalancer"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_ALLOW_F5_P2S_SNAT"
    priority                   = 3408
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow point to site SNAT addresses"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32", "10.44.164.6/32", "10.44.164.7/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_INFOSEC_AGENTS_Qualys"
    priority                     = 3409
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow Qualys Agents to reach Qualys Services"
    source_port_range            = "*"
    destination_port_ranges      = ["80", "443", "8443"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["64.39.96.0/20", "162.159.152.21", "162.159.153.243"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_TCP"
    priority                   = 3410
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_ranges    = ["135", "136", "139", "445", "636", "3268", "3269", "50000", "50005", "60000"]
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_TCP"
    priority                     = 3410
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Tcp"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_ranges      = ["135", "136", "139", "445", "636", "3268", "3269", "50000", "50005", "60000"]
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_UDP"
    priority                   = 3411
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Udp"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_range     = "138"
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                         = "OUT_ALLOW_PLATFORM_AD_DS_TRUST_COMS_UDP"
    priority                     = 3411
    direction                    = "Outbound"
    access                       = "Allow"
    protocol                     = "Udp"
    description                  = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range            = "*"
    destination_port_range       = "138"
    source_address_prefix        = "*"
    destination_address_prefixes = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
  },
  {
    name                       = "IN_ALLOW_PLATFORM_AD_DS_TRUST_COMS_BOTH_IN"
    priority                   = 3414
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Allow domains to digest trust and AD Domain services from platform Domain"
    source_port_range          = "*"
    destination_port_ranges    = ["88", "137", "389", "464", "53", "49152-49652"]
    source_address_prefixes    = ["10.44.4.68", "10.44.4.49", "10.45.4.68", "10.45.4.69", "10.48.4.68", "10.48.4.69", "10.44.164.68", "10.44.164.69", "10.44.4.91/32", "10.44.4.92/32", "10.45.4.91/32", "10.45.4.92/32", "10.48.4.91/32", "10.48.4.92/32"]
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_ALLOW_FILESHARE_STORAGE_OUTBOUND-01"
    priority                   = 3420
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow 445 egress to storage service tag"
    source_port_range          = "*"
    destination_port_range     = "445"
    source_address_prefix      = "*"
    destination_address_prefix = "Storage"
  },
  {
    name                       = "IN_DENY_FILESHARE_INTERNET_IN"
    priority                   = 3421
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all inbound traffic ingress on known NETBIOS ports"
    source_port_range          = "*"
    destination_port_ranges    = ["137", "138", "139", "445"]
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_DENY_FILESHARE_INTERNET_OUTBOUND-01"
    priority                   = 3421
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all outbound traffic egress on known NETBIOS Ports"
    source_port_range          = "*"
    destination_port_ranges    = ["137", "138", "139", "445"]
    source_address_prefix      = "*"
    destination_address_prefix = "Internet"
  },
  {
    name                       = "OUT_ALLOW_AZURE_PLATFORM_OUTBOUND-01"
    priority                   = 3900
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Provides outbound communication with Microsoft Azure Platform services"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  },
  {
    name                       = "OUT_ALLOW_AZURE_SITE_RECOVERY_HEALTHCHECK_OUTBOUND-01"
    priority                   = 3902
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "*"
    description                = "Provides outbound communication with Microsoft Azure Site Recovery services"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "AzureCloud"
  },
  {
    name                       = "OUT_ALLOW_HTTP_HTTPS_ANY_OUTBOUND-01"
    priority                   = 3990
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow HTTPS egress - TEMPORARY"
    source_port_range          = "*"
    destination_port_ranges    = ["443", "80"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_ALLOW_MGMTPORTS_CTP_OUTBOUND-01"
    priority                   = 3999
    direction                  = "Outbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    description                = "Allow CTP traffic egress on known MGMT ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefixes    = ["10.44.6.0/23", "10.45.6.0/23", "10.48.6.0/23", "10.48.166.0/23", "10.44.4.5/32", "10.44.4.6/32", "10.45.4.5/32", "10.45.4.6/32", "10.48.4.5/32", "10.48.4.6/32", "10.44.164.5/32", "10.44.165.6/32"]
    destination_address_prefix = "10.0.0.0/8"
  },
  {
    name                       = "IN_DENY_MGMTPORTS_ANY_IN"
    priority                   = 4000
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    description                = "Deny all inbound traffic ingress on known MGMT ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "OUT_DENY_MGMTPORTS_ANY_OUTBOUND-01"
    priority                   = 4000
    direction                  = "Outbound"
    access                     = "Deny"
    protocol                   = "Tcp"
    description                = "Deny all outbound traffic egress on known MGMT Ports"
    source_port_range          = "*"
    destination_port_ranges    = ["3389", "22"]
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "IN_DENY_INBOUND_TRAFFIC"
    priority                   = 4010
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    description                = "Deny all inbound traffic to any address space and any port"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  },
  {
    name                       = "Default-Deny-All-Inbound"
    priority                   = 4096
    direction                  = "Inbound"
    access                     = "Deny"
    protocol                   = "*"
    source_port_range          = "*"
    destination_port_range     = "*"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
]

additional_security_rules_nsg_general = [
  # {
  #   name                       = "Deny-NETBIOS-Inbound"
  #   priority                   = 100
  #   direction                  = "Inbound"
  #   access                     = "Deny"
  #   protocol                   = "*"
  #   source_port_range          = "*"
  #   destination_port_range     = "137-139"
  #   source_address_prefix      = "Internet"
  #   destination_address_prefix = "*"
  # },
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
github_network_settings_name = "USEQCXS05HGHNS01"
business_id                  = "8023"
github_subnet_name           = "USEQCXS05HSBN01"
github_vnet_name             = "USEQCXS05HVNT01"
github_vnet_rg_name          = "USEQCXS05HRSG02"