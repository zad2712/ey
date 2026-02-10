resource "azurerm_cognitive_deployment" "model_deployment" {
  for_each = var.deployments

  name                 = each.value.deployment_name
  cognitive_account_id = var.openai_account_id

  model {
    format  = each.value.model_format
    name    = each.value.model_name
    version = each.value.model_version
  }

  sku {
    name     = each.value.sku_name
    capacity = each.value.sku_capacity
  }
  

  
} 


