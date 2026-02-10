# Admin Layer - EYX Infrastructure

## Overview

The **Admin Layer** is responsible for deploying and managing Azure Private DNS Zones and their Virtual Network Links across all environments. This layer provides centralized DNS resolution for private endpoints, enabling secure communication between Azure services over private networks without exposing them to the public internet.

This layer follows a custom module approach, migrating away from Azure Verified Modules (AVM) to provide better control over environment-specific configurations and VNet link management.

## Architecture

```
┌────────────────────────────────────────────────────────┐
│                      Admin Layer                       │
├────────────────────────────────────────────────────────┤
│                                                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │          Private DNS Zones (13 zones)            │  │
│  │                                                  │  │
│  │  • privatelink.redis.cache.windows.net           │  │
│  │  • privatelink.servicebus.windows.net            │  │
│  │  • privatelink.documents.azure.com               │  │
│  │  • privatelink.postgres.cosmos.azure.com         │  │
│  │  • privatelink.blob.core.windows.net             │  │
│  │  • privatelink.queue.core.windows.net            │  │
│  │  • privatelink.table.core.windows.net            │  │
│  │  • privatelink.azurewebsites.net                 │  │
│  │  • privatelink.service.signalr.net               │  │
│  │  • privatelink.openai.azure.com                  │  │
│  │  • privatelink.cognitiveservices.azure.com       │  │
│  │  • privatelink.azurecr.io                        │  │
│  │  • privatelink.azurecontainerapps.io             │  │
│  └──────────────────────────────────────────────────┘  │
│                                                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │       Virtual Network Links                      │  │
│  │                                                  │  │
│  │  QA:   3 VNets  (admin, frontend, backend)       │  │
│  │  UAT:  7 VNets  (admin + 6 sub-environment)      │  │
│  │  PROD: 7 VNets  (admin + 6 sub-environment)      │  │
│  └──────────────────────────────────────────────────┘  │
│                                                        │
│  ┌──────────────────────────────────────────────────┐  │
│  │        Management Locks (CanNotDelete)           │  │
│  │  • Prevents accidental DNS zone deletion         │  │
│  │  • Applied to all environments                   │  │
│  └──────────────────────────────────────────────────┘  │
│                                                        │
└────────────────────────────────────────────────────────┘
```

## Table of Contents

- [Prerequisites](#prerequisites)
- [Components](#components)
  - [Private DNS Zones](#private-dns-zones)
  - [Virtual Network Links](#virtual-network-links)
  - [Management Locks](#management-locks)
- [Environment-Specific Configuration](#environment-specific-configuration)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Migration Notes](#migration-notes)
- [Outputs](#outputs)

## Prerequisites

Before deploying the Admin Layer, ensure the following prerequisites are met:

1. **Azure Subscription**: Active Azure subscription with appropriate permissions
2. **Backend Storage**: Azure Storage Account for Terraform state (configured in `provider.tf`)
3. **Network Layer**: Virtual Networks must exist before creating VNet links
4. **Resource Groups**: 
   - Admin Resource Group (for UAT/PROD DNS zones)
   - Lab Resource Group (for QA DNS zones)
5. **Terraform Version**: >= 1.0
6. **Provider Versions**:
   - `hashicorp/azurerm` >= 3.0, < 5.0

**Important**: All VNETs referenced in `data.tf` must exist before deploying this layer. Virtual Network Links will fail if the target VNets are not already deployed.

## Components

### Private DNS Zones

Private DNS Zones provide name resolution for Azure resources using private IP addresses within virtual networks.

#### What is it?

Azure Private DNS provides a reliable and secure DNS service for your virtual network. It manages and resolves domain names in the virtual network without the need to configure a custom DNS solution.

#### What is it used for?

- Resolving private endpoint FQDNs to private IP addresses
- Enabling secure communication between Azure services
- Supporting multiple Azure service types (Storage, Cosmos DB, Key Vault, etc.)
- Providing consistent DNS resolution across linked virtual networks

#### Supported Services

This layer creates Private DNS Zones for the following Azure services:

| Service | DNS Zone | Use Case |
|---------|----------|----------|
| **Redis Cache** | `privatelink.redis.cache.windows.net` | Private endpoints for Azure Cache for Redis |
| **Service Bus** | `privatelink.servicebus.windows.net` | Private endpoints for Azure Service Bus |
| **Cosmos DB (NoSQL)** | `privatelink.documents.azure.com` | Private endpoints for Cosmos DB NoSQL API |
| **Cosmos DB (PostgreSQL)** | `privatelink.postgres.cosmos.azure.com` | Private endpoints for Cosmos DB PostgreSQL |
| **Storage (Blob)** | `privatelink.blob.core.windows.net` | Private endpoints for Blob storage |
| **Storage (Queue)** | `privatelink.queue.core.windows.net` | Private endpoints for Queue storage |
| **Storage (Table)** | `privatelink.table.core.windows.net` | Private endpoints for Table storage |
| **App Service** | `privatelink.azurewebsites.net` | Private endpoints for Web Apps & Functions |
| **SignalR** | `privatelink.service.signalr.net` | Private endpoints for SignalR Service |
| **OpenAI** | `privatelink.openai.azure.com` | Private endpoints for Azure OpenAI |
| **Cognitive Services** | `privatelink.cognitiveservices.azure.com` | Private endpoints for Document Intelligence |
| **Container Registry** | `privatelink.azurecr.io` | Private endpoints for Azure Container Registry |
| **Container Apps** | `privatelink.azurecontainerapps.io` | Private endpoints for Container Apps (UAT/PROD)<br>`privatelink.eastus.azurecontainerapps.io` (QA) |

**Note**: Speech Services and Container App Environment zones are only created in UAT/PROD environments.

#### Features

- **Auto-registration**: Disabled by default (can be enabled per VNet link)
- **Cross-environment support**: QA, UAT, and PROD configurations
- **Centralized DNS**: Single DNS zone linked to multiple VNets
- **Tag management**: Environment-specific tags with `hidden-title` for Azure Portal display

#### Usage Example

```hcl
# Private DNS Zone with VNet links and management lock
module "private_dns_zone" {
  source   = "../../modules/private_dns_zone"
  for_each = local.private_dns_zones

  domain_name         = each.value
  resource_group_name = var.env == "QA" ? var.lab_resource_group_name_app : data.azurerm_resource_group.admin.name
  tags                = local.merged_tags[each.key]
  enable_telemetry    = var.enable_telemetry
  
  virtual_network_links = local.virtual_network_links_per_zone[each.key]
  
  lock = merge(
    local.dns_zone_lock,
    { name = "${var.env}-${each.key}-dns-lock" }
  )
}
```

### Virtual Network Links

Virtual Network Links connect Private DNS Zones to Virtual Networks, enabling DNS resolution.

#### What is it?

A Virtual Network Link connects a Private DNS Zone to a Virtual Network, allowing resources in that VNet to resolve the private DNS zone's records.

#### What is it used for?

- Enabling DNS resolution for private endpoints within VNets
- Supporting multi-VNet architectures (admin, frontend, backend)
- Providing sub-environment isolation (lab, pilot, prod) in UAT/PROD
- Allowing cross-VNet name resolution when linked to the same zone

#### Environment-Specific VNet Links

**QA Environment** (3 VNets):
- `admin` VNet (USEQCXS05HVNT01)
- `frontend` VNet (USEQCXS05HVNT02)
- `backend` VNet (USEQCXS05HVNT03)

**UAT/PROD Environments** (7 VNets):
- `admin` VNet
- `lab-frontend` VNet
- `lab-backend` VNet
- `pilot-frontend` VNet
- `pilot-backend` VNet
- `prod-frontend` VNet
- `prod-backend` VNet

**Special Configurations**:

**QA Environment**:
- **app_service zone**: Custom link names (`adminvnet`, `3r4xxrz4oyvua`, `backendvnet`)
- **signalr zone**: No VNet links (SignalR not deployed in QA)
- **container_app zone**: Only admin VNet link (`useqcxs05hcae01-link`)

**UAT/PROD Environments**:
- All zones linked to all 7 VNets
- Consistent naming pattern: `{ENV}-{sub-env}-{vnet-type}-{zone-key}-link`

#### Auto-registration

Auto-registration is **disabled** by default for all VNet links. This prevents automatic DNS record creation when VMs are created, ensuring manual control over DNS entries.

To enable auto-registration for a specific link:
```hcl
virtual_network_links = {
  admin = {
    name                 = "admin-link"
    vnetid               = data.azurerm_virtual_network.admin_vnet.id
    registration_enabled = true  # Enable auto-registration
  }
}
```

### Management Locks

Management locks prevent accidental deletion of critical DNS zone resources.

#### What is it?

Azure Management Locks provide a way to lock resources to prevent accidental deletion or modification. The `CanNotDelete` lock level allows read and update operations but prevents deletion.

#### What is it used for?

- Protecting production DNS zones from accidental deletion
- Ensuring DNS resolution continuity for private endpoints
- Enforcing governance policies across all environments
- Maintaining compliance with infrastructure standards

#### Lock Configuration

All DNS zones in all environments (QA, UAT, PROD) are protected with `CanNotDelete` locks.

**Lock Details**:
- **Type**: `CanNotDelete`
- **Scope**: Applied to each Private DNS Zone
- **Naming**: `{ENV}-{zone-key}-dns-lock`
- **Notes**: Centrally managed in `locals.tf`

**Example**:
```hcl
# Centralized lock policy in locals.tf
dns_zone_lock = {
  kind  = "CanNotDelete"
  notes = "Prevents accidental deletion of ${var.env} Private DNS Zone - Managed by Terraform"
}

# Applied per zone
lock = merge(
  local.dns_zone_lock,
  { name = "${var.env}-${each.key}-dns-lock" }
)
```

**Note**: To delete a DNS zone, you must first remove the lock via Azure Portal or `terraform destroy` with lock removal.

## Environment-Specific Configuration

### QA Environment

**VNets**: 3 (admin, frontend, backend)

**DNS Zones**: 13 zones (excludes speech and container_app_environment)

**Resource Group**: `USEQCXS05HRSG03` (Lab RG)

**Special Configurations**:
- Container App zone uses region-specific FQDN: `privatelink.eastus.azurecontainerapps.io`
- SignalR zone has no VNet links
- App Service zone uses existing autogenerated link names

**Subscription**: `bcff8cd6-13ff-48f9-8a70-2e5478106b1a`

### UAT Environment

**VNets**: 7 (admin + 6 sub-environment VNets)

**DNS Zones**: 15 zones (includes speech and container_app_environment)

**Resource Group**: Admin RG

**Sub-environments**: lab, pilot, prod

### PROD Environment

**VNets**: 7 (admin + 6 sub-environment VNets)

**DNS Zones**: 15 zones (includes speech and container_app_environment)

**Resource Group**: Admin RG

**Sub-environments**: lab, pilot, prod

## Configuration

### locals.tf

Centralized configuration for all environment-specific logic:

```hcl
locals {
  # Environment-specific tags
  environment_base_tags = {
    QA   = { DEPLOYMENT_ID = "CXS05H", ENGAGEMENT_ID = "I-68403024", ... }
    UAT  = { DEPLOYMENT_ID = "EYXU01", ENGAGEMENT_ID = "I-69197406", ... }
    PROD = { DEPLOYMENT_ID = "EYXP01", ENGAGEMENT_ID = "I-69197406", ... }
  }

  # DNS zones per environment
  private_dns_zones = var.env == "QA" ? merge(
    local.base_private_dns_zones,
    local.qa_additional_zones
  ) : merge(
    local.base_private_dns_zones,
    local.uat_prod_additional_zones
  )

  # VNet links per zone and environment
  virtual_network_links_per_zone = {
    for zone_key, zone_name in local.private_dns_zones :
    zone_key => var.env == "QA" ? (
      # QA-specific VNet link logic
    ) : {
      # UAT/PROD VNet link logic
    }
  }

  # Management lock policy
  dns_zone_lock = {
    kind  = "CanNotDelete"
    notes = "Prevents accidental deletion of ${var.env} Private DNS Zone - Managed by Terraform"
  }
}
```

### data.tf

Data sources for VNets with conditional evaluation:

```hcl
# Admin VNet (all environments)
data "azurerm_virtual_network" "admin_vnet" {
  name                = var.vnet_admin_name_01
  resource_group_name = var.resource_group_name_admin
}

# Lab VNets (all environments)
data "azurerm_virtual_network" "lab_frontend_vnet" { ... }
data "azurerm_virtual_network" "lab_backend_vnet" { ... }

# Pilot/Prod VNets (UAT/PROD only - skipped in QA)
data "azurerm_virtual_network" "pilot_frontend_vnet" {
  count = var.env == "QA" ? 0 : 1
  ...
}
```

**Note**: Pilot and Prod VNet data sources use `count` to skip evaluation in QA environment, avoiding unnecessary resource queries.

### Environment Configuration Files

Environment-specific variables are stored in `environments/{env}/{env}.tfvars`:

**QA** (`environments/qa/qa.tfvars`):
```hcl
env                         = "QA"
resource_group_name_admin   = "USEQCXS05HRSG02"
vnet_admin_name_01          = "USEQCXS05HVNT01"
lab_vnet_app_name_01        = "USEQCXS05HVNT02"  # Frontend
lab_vnet_app_name_02        = "USEQCXS05HVNT03"  # Backend
lab_resource_group_name_app = "USEQCXS05HRSG03"
enable_telemetry            = true
```

**Note**: QA does not require `pilot_*` or `prod_*` variables since those data sources are skipped.

## Deployment

### Prerequisites Check

Before deployment, verify:
1. All VNets exist and are deployed
2. Resource Groups are created
3. Backend state storage is configured
4. Azure CLI authentication is active

### Initialize Terraform

```bash
cd terraform/layers/admin
terraform init
```

### Plan Deployment

```bash
# QA Environment
terraform plan -var-file="environments/qa/qa.tfvars"

# UAT Environment
terraform plan -var-file="environments/uat/uat.tfvars"

# PROD Environment
terraform plan -var-file="environments/prod/prod.tfvars"
```

### Apply Changes

```bash
# QA Environment
terraform apply -var-file="environments/qa/qa.tfvars"

# UAT Environment
terraform apply -var-file="environments/uat/uat.tfvars"

# PROD Environment
terraform apply -var-file="environments/prod/prod.tfvars"
```

### Verify Deployment

After deployment, verify:
1. Private DNS Zones are created
2. VNet Links are established
3. Management locks are applied
4. Tags are correctly applied

## Outputs

The Admin Layer provides the following outputs for use by other layers:

### Private DNS Zone IDs

```hcl
output "private_dns_zone_ids" {
  description = "Map of Private DNS Zone resource IDs"
  value = {
    redis                 = module.private_dns_zone["redis"].resource.id
    servicebus            = module.private_dns_zone["servicebus"].resource.id
    cosmosdb              = module.private_dns_zone["cosmosdb"].resource.id
    cosmosdb_postgresql   = module.private_dns_zone["cosmosdb_postgresql"].resource.id
    storage_blob          = module.private_dns_zone["storage_blob"].resource.id
    storage_queue         = module.private_dns_zone["storage_queue"].resource.id
    storage_table         = module.private_dns_zone["storage_table"].resource.id
    app_service           = module.private_dns_zone["app_service"].resource.id
    signalr               = module.private_dns_zone["signalr"].resource.id
    openai                = module.private_dns_zone["openai"].resource.id
    document_intelligence = module.private_dns_zone["document_intelligence"].resource.id
    container_registry    = module.private_dns_zone["container_registry"].resource.id
    container_app         = module.private_dns_zone["container_app"].resource.id
    # speech and container_app_environment only in UAT/PROD
  }
}
```

### Virtual Network Link Information

```hcl
output "private_dns_zone_vnet_links" {
  description = "Map of Virtual Network Links per DNS Zone"
  value = {
    for zone_key, zone in module.private_dns_zone :
    zone_key => {
      for link_key, link in zone.virtual_network_links :
      link_key => {
        id                   = link.id
        name                 = link.name
        virtual_network_id   = link.virtual_network_id
        registration_enabled = link.registration_enabled
      }
    }
  }
}
```

### Management Lock Information

```hcl
output "private_dns_zone_locks" {
  description = "Map of Management Locks per DNS Zone"
  value = {
    for zone_key, zone in module.private_dns_zone :
    zone_key => try(zone.management_lock[0].id, null)
  }
}
```

## Troubleshooting

### Common Issues

**Issue**: `Error: Virtual Network not found`
- **Cause**: VNet referenced in data source doesn't exist
- **Solution**: Ensure Network Layer is deployed before Admin Layer

**Issue**: `Error: Resource already exists`
- **Cause**: DNS zone or VNet link already exists in Azure
- **Solution**: Import existing resource using `terraform import`

**Issue**: `Error: Cannot delete resource with lock`
- **Cause**: Management lock prevents deletion
- **Solution**: Remove lock manually in Azure Portal or update Terraform config

**Issue**: `Error: No value for required variable`
- **Cause**: Missing variable in tfvars file
- **Solution**: Check `variables.tf` for required variables

### Validation Commands

```bash
# Validate configuration
terraform validate

# Check formatting
terraform fmt -check

# Show planned changes without applying
terraform plan -var-file="environments/qa/qa.tfvars"

# Force unlock if state is locked
terraform force-unlock <lock-id>
```

## Best Practices

1. **Always Plan First**: Run `terraform plan` before `terraform apply`
2. **Use Environment Files**: Keep environment-specific config in separate tfvars files
3. **Import Before Create**: Import existing resources to avoid conflicts
4. **Tag Consistently**: Use environment-specific tags for cost tracking
5. **Enable Locks**: Protect production resources with management locks
6. **Document Changes**: Update this README when making architectural changes

## Related Documentation

- [Private DNS Zone Module Documentation](../../modules/private_dns_zone/README.md)
- [Core Layer Documentation](../core/README.md)
- [App Layer Documentation](../app/README.md)
- [Network Layer Documentation](../network/README.md)

## Support

For issues or questions:
1. Check [Troubleshooting](#troubleshooting) section
2. Review module documentation
3. Contact EYX DevOps team
4. Create issue in repository

---

**Last Updated**: January 30, 2026  
**Maintained By**: EYX DevOps Team  
**Version**: 1.0.0
