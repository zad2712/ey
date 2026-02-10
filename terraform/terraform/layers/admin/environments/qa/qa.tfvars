################
### GENERAL ####
################
env                       = "QA"
resource_group_name_admin = "USEQCXS05HRSG02" # Admin RG for admin VNET
vnet_admin_name_01        = "USEQCXS05HVNT01" # Admin VNET

######################
### APP VNETS ########
######################
# QA has simpler structure with 3 VNets: admin, frontend, backend
# Using "lab" variables to reference frontend/backend VNets (consistent with data.tf)
lab_vnet_app_name_01        = "USEQCXS05HVNT02" # Frontend VNET
lab_vnet_app_name_02        = "USEQCXS05HVNT03" # Backend VNET
lab_resource_group_name_app = "USEQCXS05HRSG03" # App Resource Group (contains DNS zones and app VNETs)

# Note: QA doesn't have pilot/prod sub-environments. Those data sources are skipped using count.
