data "azurerm_windows_function_app" "function_app_01" {
  count = var.enable_malware_scanning && var.function_app_name_app_01 != null ? 1 : 0
  name                = var.function_app_name_app_01
  resource_group_name = var.resource_group_name
}