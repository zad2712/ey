# ============================================================================
# Terraform and Provider Version Constraints
# ============================================================================

terraform {
  required_version = ">= 1.0"

  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">= 3.0, < 5.0"
    }
  }
}

# Note: Provider configuration is inherited from the calling module/layer.
# Do not configure provider blocks in reusable modules.
