output "deployment_ids" {
  description = "IDs of the deployed models."
  value = {
    for k, deployment in azurerm_cognitive_deployment.model_deployment : k => deployment.id
  }
}

output "deployment_names" {
  description = "Names of the deployed models."
  value = {
    for k, deployment in azurerm_cognitive_deployment.model_deployment : k => deployment.name
  }
}

output "deployment_skus" {
  description = "SKUs of the deployed models."
  value = {
    for k, deployment in azurerm_cognitive_deployment.model_deployment : k => deployment.sku[0].name
  }
}