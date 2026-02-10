 provider "azurerm" {
   features {}
   subscription_id = "${SUBSCRIPTION_ID}"
 }

 provider "azurerm" {
  alias           = "dev_integration"
  features {}
  subscription_id = "${BACKEND_SUBSCRIPTION_ID}"
}

 terraform {
   backend "azurerm" {
     resource_group_name  = "${RESOURCE_GROUP_NAME}"
     storage_account_name = "${STORAGE_ACCOUNT_NAME}"
     container_name       = "terraform"
     key                  = "layers/config/${TF_STATE_PATH}terraform.tfstate"
     subscription_id      = "${BACKEND_SUBSCRIPTION_ID}"
   }
}






