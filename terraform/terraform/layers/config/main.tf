####################
#### SHARED DATA ###
####################
module "shared_data" {
  source                           = "../shared"
  #resource_group_name_admin_dev    = local.resource_group_name_admin_dev
  
  #resource_group_name_admin        = var.resource_group_name_admin
  resource_group_name_app          = var.resource_group_name_app
  log_analytics_workspace_app_name = var.log_analytics_workspace_app_name
  vnet_admin_name_01               = var.vnet_admin_name_01 # Admin VNET
  vnet_app_name_01                 = var.vnet_app_name_01   # Frontend VNET
  subnet_app_name_01               = var.subnet_app_name_01
  subnet_app_name_02               = var.subnet_app_name_02
  subnet_app_name_03               = var.subnet_app_name_03
  vnet_app_name_02                 = var.vnet_app_name_02    # Backend VNet
  subnet1_name_app_02              = var.subnet1_name_app_02 # Backend Subnet1 /27
  kv_shared_app                      = var.kv_shared_app
  storage_account_app_name_01       = var.storage_account_app_name_01
  env                                = var.env
  





  providers = {
    azurerm.dev_integration = azurerm.dev_integration
  }
}


####################################
### KEY VAULT SECRET################
####################################
# module "random_pass_keyvault" {
    
#   source   = "../../modules/random_pass_keyvault"

#   key_vault_id    = module.shared_data.kv_shared_app[0].id
#   secret_name     = var.secret_name 
#   password_length = 16
  
# }

# #############################################
# #### STORAGE ACCOUNT CONTAINERS #############
# #############################################

module "storage_containers" {
  source               = "../../modules/storage_account_containers"
  storage_account_name = var.storage_account_name
  resource_group_name  = var.resource_group_name
  container_names      = var.container_names

  storage_account_id   = module.shared_data.storage_account_shared_app_name_01.id
                         
}


# #############################################
# #### COSMODB ACCOUNT CONTAINERS #############
# #############################################

module "cosmosdb_containers" {
  source               = "../../modules/cosmosdb_containers"
  
  cosmosdb_account_name = var.cosmosdb_account_name
  resource_group_name   = var.resource_group_name
  database_name         = var.cosmosdb_database_name
  containers            = var.cosmosdb_containers
}

  