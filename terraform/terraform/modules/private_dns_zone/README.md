# Azure Private DNS Zone - Custom Module

## Overview

This custom module creates and manages Azure Private DNS Zones with Virtual Network links, following Azure best practices, security standards, and Azure Verified Module (AVM) compatibility patterns.

The module is designed to seamlessly replace the AVM Private DNS Zone module (`Azure/avm-res-network-privatednszone/azurerm`) while maintaining **backward compatibility** with existing infrastructure and providing enhanced features for enterprise environments.

## Features

### Core Capabilities
- ✅ **Private DNS Zone Management**: Create and configure Azure Private DNS Zones for private endpoint DNS resolution
- ✅ **Virtual Network Linking**: Link DNS zones to multiple VNets with auto-registration support
- ✅ **SOA Record Configuration**: Customize Start of Authority records for advanced DNS scenarios
- ✅ **Management Locks**: Prevent accidental deletion or modification in production environments
- ✅ **Diagnostic Settings**: Enable monitoring and auditing via Log Analytics, Storage, or Event Hub
- ✅ **AVM Compatibility**: Drop-in replacement for AVM modules with identical output structure

### Security & Governance
- 🔒 **Input Validation**: Comprehensive validation for domain names, resource names, tags, and configurations
- 🔒 **Lifecycle Management**: Automatic handling of system-generated tags and optional `prevent_destroy`
- 🔒 **Tag Governance**: Supports enterprise tagging strategies with lifecycle ignore rules
- 🔒 **Management Locks**: Production-ready resource protection (CanNotDelete/ReadOnly)

### Enterprise Features
- 📊 **Monitoring Ready**: Built-in diagnostic settings for audit logs and metrics
- 🏗️ **Multi-Environment**: Supports DEV, QA, UAT, PROD with different configurations
- 🔗 **Cross-Layer Integration**: Outputs designed for `terraform_remote_state` consumption
- 📝 **Comprehensive Documentation**: Detailed variable descriptions with examples

## Architecture

```
┌─────────────────────────────────────────────────────────────────┐
│                    Private DNS Zone Module                      │
├─────────────────────────────────────────────────────────────────┤
│                                                                 │
│  ┌──────────────────────────────────────────────────────────┐   │
│  │          Azure Private DNS Zone                          │   │
│  │  (e.g., privatelink.blob.core.windows.net)               │   │
│  └──────────────────────────────────────────────────────────┘   │
│                           │                                     │
│                           │ Links                               │
│       ┌───────────────────┼───────────────────┐                 │
│       │                   │                   │                 │
│  ┌────▼────┐         ┌────▼────┐         ┌────▼────┐            │
│  │ VNet 1  │         │ VNet 2  │   ...   │ VNet N  │            │
│  │ (Admin) │         │  (App)  │         │ (Data)  │            │
│  └─────────┘         └─────────┘         └─────────┘            │
│                                                                 │
│  Optional Features:                                             │
│  ┌──────────────────┐  ┌──────────────────┐                     │
│  │   Diagnostic     │  │   Management     │                     │
│  │    Settings      │  │      Lock        │                     │
│  └──────────────────┘  └──────────────────┘                     │
│                                                                 │
└─────────────────────────────────────────────────────────────────┘
```

## Usage Examples

### Basic Example - Single Private DNS Zone

```hcl
module "storage_blob_dns" {
  source = "../../modules/private_dns_zone"
  
  domain_name         = "privatelink.blob.core.windows.net"
  resource_group_name = "my-resource-group"
  
  tags = {
    ENVIRONMENT   = "PROD"
    DEPLOYMENT_ID = "EYXP01"
    OWNER         = "platform-team@example.com"
    hidden-title  = "Storage Blob Private DNS Zone"
  }
}
```

### Advanced Example - With VNet Links

```hcl
module "redis_dns" {
  source = "../../modules/private_dns_zone"
  
  domain_name         = "privatelink.redis.cache.windows.net"
  resource_group_name = azurerm_resource_group.admin.name
  
  # Link to multiple VNets
  virtual_network_links = {
    admin = {
      name   = "admin-vnet-link"
      vnetid = data.azurerm_virtual_network.admin_vnet.id
    }
    frontend = {
      name   = "frontend-vnet-link"
      vnetid = data.azurerm_virtual_network.frontend_vnet.id
    }
    backend = {
      name   = "backend-vnet-link"
      vnetid = data.azurerm_virtual_network.backend_vnet.id
    }
  }
  
  tags = {
    ENVIRONMENT  = "UAT"
    hidden-title = "Redis Cache Private DNS Zone"
  }
}
```

### Production Example - Full Configuration

```hcl
module "openai_dns" {
  source = "../../modules/private_dns_zone"
  
  domain_name         = "privatelink.openai.azure.com"
  resource_group_name = azurerm_resource_group.admin.name
  
  # VNet Links with auto-registration disabled (recommended for PaaS)
  virtual_network_links = {
    admin = {
      vnetid               = data.azurerm_virtual_network.admin_vnet.id
      registration_enabled = false
    }
    app-frontend = {
      vnetid               = data.azurerm_virtual_network.app_frontend.id
      registration_enabled = false
    }
  }
  
  # Enable diagnostic settings for audit logs
  diagnostic_settings = {
    name                       = "openai-dns-diagnostics"
    log_analytics_workspace_id = data.azurerm_log_analytics_workspace.core.id
    enabled_log_categories     = ["AuditEvent"]
    enabled_metrics            = ["AllMetrics"]
  }
  
  # Prevent accidental deletion in production
  lock = {
    kind  = "CanNotDelete"
    name  = "prod-openai-dns-lock"
    notes = "Prevents accidental deletion of production OpenAI Private DNS Zone"
  }
  
  tags = {
    ENVIRONMENT   = "PROD"
    DEPLOYMENT_ID = "EYXP01"
    OWNER         = "ai-platform-team@example.com"
    hidden-title  = "OpenAI Private DNS Zone - Production"
  }
}
```

### Migration Example - Replace AVM Module

**Before (AVM Module):**
```hcl
module "avm-res-network-privatednszone" {
  source  = "Azure/avm-res-network-privatednszone/azurerm"
  version = "0.4.1"
  
  enable_telemetry = var.enable_telemetry
  parent_id        = data.azurerm_resource_group.admin.id
  domain_name      = "privatelink.blob.core.windows.net"
  tags             = local.merged_tags["storage_blob"]
  
  virtual_network_links = {
    admin = {
      name   = "admin-vnet-link"
      vnetid = data.azurerm_virtual_network.admin_vnet.id
    }
  }
}
```

**After (Custom Module):**
```hcl
module "private_dns_zone_storage_blob" {
  source = "../../modules/private_dns_zone"
  
  # Note: parent_id is replaced with resource_group_name
  domain_name         = "privatelink.blob.core.windows.net"
  resource_group_name = data.azurerm_resource_group.admin.name
  tags                = local.merged_tags["storage_blob"]
  
  virtual_network_links = {
    admin = {
      name   = "admin-vnet-link"
      vnetid = data.azurerm_virtual_network.admin_vnet.id
    }
  }
  
  enable_telemetry = var.enable_telemetry
}
```

### Multiple DNS Zones with For_Each

```hcl
locals {
  private_dns_zones = {
    redis       = "privatelink.redis.cache.windows.net"
    servicebus  = "privatelink.servicebus.windows.net"
    cosmosdb    = "privatelink.documents.azure.com"
    storage_blob = "privatelink.blob.core.windows.net"
  }
}

module "private_dns_zones" {
  source   = "../../modules/private_dns_zone"
  for_each = local.private_dns_zones
  
  domain_name         = each.value
  resource_group_name = azurerm_resource_group.admin.name
  tags                = local.merged_tags[each.key]
  
  virtual_network_links = {
    admin = {
      name   = "${var.env}-admin-vnet-${each.key}-link"
      vnetid = data.azurerm_virtual_network.admin_vnet.id
    }
    frontend = {
      name   = "${var.env}-frontend-vnet-${each.key}-link"
      vnetid = data.azurerm_virtual_network.frontend_vnet.id
    }
  }
}
```

## Migration Guide from AVM Module

### Key Differences

| Aspect | AVM Module | Custom Module |
|--------|------------|---------------|
| **Resource Group** | `parent_id` (RG resource ID) | `resource_group_name` (RG name) |
| **Output Structure** | `resource_id`, `resource` | Same (AVM-compatible) |
| **Diagnostic Settings** | Not included | Built-in support |
| **Management Locks** | Not included | Built-in support |
| **Validation** | Basic | Comprehensive |
| **Documentation** | Standard | Enhanced with examples |

### Migration Steps

1. **Update Source Path**:
   ```hcl
   # Before
   source = "Azure/avm-res-network-privatednszone/azurerm"
   
   # After
   source = "../../modules/private_dns_zone"
   ```

2. **Replace `parent_id` with `resource_group_name`**:
   ```hcl
   # Before
   parent_id = data.azurerm_resource_group.admin.id
   
   # After
   resource_group_name = data.azurerm_resource_group.admin.name
   ```

3. **Remove Version Constraint**:
   ```hcl
   # Before
   version = "0.4.1"
   
   # After
   # (no version needed for local module)
   ```

4. **Run Terraform Import** (for existing resources):
   ```bash
   # Import existing DNS zones to avoid recreation
   terraform import 'module.private_dns_zones["redis"].azurerm_private_dns_zone.this' \
     /subscriptions/{sub-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.redis.cache.windows.net
   
   # Import VNet links
   terraform import 'module.private_dns_zones["redis"].azurerm_private_dns_zone_virtual_network_link.this["admin"]' \
     /subscriptions/{sub-id}/resourceGroups/{rg-name}/providers/Microsoft.Network/privateDnsZones/privatelink.redis.cache.windows.net/virtualNetworkLinks/admin-vnet-link
   ```

5. **Verify Plan**:
   ```bash
   terraform plan
   # Should show no changes (or only minor tag updates)
   ```

## Input Variables

### Required Variables

| Name | Type | Description |
|------|------|-------------|
| `domain_name` | `string` | DNS zone domain name (e.g., privatelink.blob.core.windows.net) |
| `resource_group_name` | `string` | Resource group name where the DNS zone will be created |

### Optional Variables

| Name | Type | Default | Description |
|------|------|---------|-------------|
| `virtual_network_links` | `map(object)` | `{}` | Map of VNet links to create |
| `tags` | `map(string)` | `{}` | Tags to apply to all resources |
| `soa_record` | `object` | `null` | Custom SOA record configuration |
| `diagnostic_settings` | `object` | `null` | Diagnostic settings for monitoring |
| `lock` | `object` | `null` | Management lock configuration |
| `enable_telemetry` | `bool` | `false` | Enable Microsoft telemetry |

See [variables.tf](./variables.tf) for detailed documentation on each variable.

## Outputs

### Primary Outputs (AVM-Compatible)

| Name | Description |
|------|-------------|
| `resource_id` | Resource ID of the Private DNS Zone |
| `resource` | Full DNS Zone resource object |
| `name` | FQDN of the DNS Zone |
| `id` | Alternative resource ID output |

### Additional Outputs

| Name | Description |
|------|-------------|
| `virtual_network_links` | Map of VNet link details |
| `virtual_network_link_ids` | Map of VNet link resource IDs |
| `number_of_record_sets` | Current number of record sets |
| `max_number_of_record_sets` | Maximum allowed record sets |
| `soa_record` | SOA record details |
| `diagnostic_setting_id` | Diagnostic setting resource ID (if configured) |
| `lock_id` | Management lock resource ID (if configured) |

See [outputs.tf](./outputs.tf) for complete output documentation.

## Best Practices

### 1. **Naming Conventions**
```hcl
# Use descriptive names for VNet links
virtual_network_links = {
  "${var.env}-admin-vnet" = { ... }
  "${var.env}-frontend-vnet" = { ... }
}
```

### 2. **Auto-Registration**
```hcl
# Disable for PaaS/Private Endpoints (recommended)
registration_enabled = false

# Enable only for IaaS/VM scenarios
registration_enabled = true
```

### 3. **Management Locks**
```hcl
# Always use locks in UAT and PROD
lock = {
  kind  = "CanNotDelete"
  notes = "Prevents accidental deletion"
}
```

### 4. **Diagnostic Settings**
```hcl
# Enable in all environments for audit compliance
diagnostic_settings = {
  name                       = "${var.env}-dns-diagnostics"
  log_analytics_workspace_id = local.law_id
}
```

### 5. **Tagging Strategy**
```hcl
# Use consistent tags across all environments
tags = merge(
  local.general_tags,
  {
    hidden-title = "EYX - ${var.env} - Redis Private DNS Zone"
    SERVICE      = "Redis Cache"
  }
)
```

## Security Considerations

1. **Network Isolation**: Private DNS zones provide DNS resolution only within linked VNets
2. **RBAC**: Apply least-privilege access controls at the resource group level
3. **Management Locks**: Use `CanNotDelete` locks in production to prevent accidental deletion
4. **Audit Logging**: Enable diagnostic settings to track all configuration changes
5. **Tag Governance**: Use tags for cost allocation and compliance tracking

## Troubleshooting

### Issue: DNS Resolution Not Working

**Solution**: Verify VNet link exists and is in "Succeeded" state:
```bash
az network private-dns link vnet show \
  --resource-group <rg-name> \
  --zone-name <zone-name> \
  --name <link-name>
```

### Issue: Terraform Wants to Recreate Resources

**Solution**: Import existing resources before migrating:
```bash
terraform import 'module.dns["redis"].azurerm_private_dns_zone.this' <resource-id>
```

### Issue: Maximum VNet Links Exceeded

**Solution**: Check limit with:
```hcl
output "vnet_link_limit" {
  value = module.dns["redis"].max_number_of_virtual_network_links
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0, < 5.0 |

## Contributing

When extending this module:
1. Maintain AVM output compatibility
2. Add comprehensive validation rules
3. Update documentation with examples
4. Test across all environments (DEV/QA/UAT/PROD)
5. Preserve lifecycle ignore rules for system tags

## License

This module is proprietary and maintained by the EYX Platform Team.

## Support

For issues or questions:
- **Team**: EYX Platform Infrastructure Team
- **Documentation**: See [Core Layer README](../../layers/core/README.md)
- **Architecture**: Review [Network Layer README](../../layers/network/README.md)

---

**Module Version**: 1.0.0  
**Last Updated**: January 2026  
**Maintained By**: EYX Platform Team
