provider "azurerm" {
  features {}
  subscription_id = "${SUBSCRIPTION_ID}"
}

provider "azuread" {
  tenant_id = "${TENANT_ID}"
}

provider "azurerm" {
  alias           = "dev_integration"
  features {}
  subscription_id = "${BACKEND_SUBSCRIPTION_ID}"
}

provider "random" {}

provider "modtm" {}

terraform {
  backend "azurerm" {
    resource_group_name  = "${RESOURCE_GROUP_NAME}"
    storage_account_name = "${STORAGE_ACCOUNT_NAME}"
    container_name       = "terraform"
    key                  = "layers/core/${TF_STATE_PATH}terraform.tfstate"
    subscription_id      = "${BACKEND_SUBSCRIPTION_ID}"
  }

  required_providers {
    azapi = {
      source  = "azure/azapi"
      version = ">= 2.0"
    }
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0"
    }
    modtm = {
      source  = "Azure/modtm"
      version = "0.3.5"
    }
  }
}