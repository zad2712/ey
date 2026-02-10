variable "subnet_id" {
  description = "Name of the existing subnet"
  type        = string
}

variable "app_service_id" {
  description = "ID of the App Service to which the subnet will connect"
  type        = string
}