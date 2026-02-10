#######################################################################################################
#### Important Considerations:                                                                     ####
#### All VNETs Must Exist: Before running the terraform apply,                                     ####
#### ensure all VNETs referenced in the data.tf sources already exist across all sub-environments. ####
#######################################################################################################

################################
#### PRIVATE DNS ZONES #########
################################

module "private_dns_zone" {
  source   = "../../modules/private_dns_zone"
  for_each = local.private_dns_zones

  # Core Configuration
  domain_name         = each.value
  resource_group_name = var.env == "QA" ? var.lab_resource_group_name_app : data.azurerm_resource_group.admin.name
  tags                = local.merged_tags[each.key]
  enable_telemetry    = var.enable_telemetry

  # Virtual Network Links - Configured per environment and zone in locals.tf
  virtual_network_links = local.virtual_network_links_per_zone[each.key]

  # Management Lock - Policy defined in locals.tf
  lock = merge(
    local.dns_zone_lock,
    { name = "${var.env}-${each.key}-dns-lock" }
  )
}