provider "azurerm" {
  features {}
  subscription_id = "${SUBSCRIPTION_ID}"
}

# Admin resources - Dev Subscription
provider "azurerm" {
  alias           = "admin"
  features {}
  subscription_id = "${BACKEND_SUBSCRIPTION_ID}"
}

provider "azurerm" {
  alias           = "dev_integration"
  features {}
  subscription_id = "${BACKEND_SUBSCRIPTION_ID}"
}

provider "azapi" {
  alias = "azapi"
}

terraform {
  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = ">= 1.5"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "${RESOURCE_GROUP_NAME}"
    storage_account_name = "${STORAGE_ACCOUNT_NAME}"
    container_name       = "terraform"
    key                  = "layers/network/${TF_STATE_PATH}terraform.tfstate"
    subscription_id      = "${BACKEND_SUBSCRIPTION_ID}"
  }
}