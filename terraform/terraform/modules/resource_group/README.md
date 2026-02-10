# Resource Group Module

This module creates an Azure Resource Group with optional RBAC role assignments and management locks.

## Features

- **Resource Group Creation**: Creates an Azure Resource Group with configurable name, location, and tags
- **RBAC Role Assignments**: Supports multiple role assignments with fine-grained control
- **Management Locks**: Optional CanNotDelete or ReadOnly locks to protect resources
- **Tag Lifecycle Management**: Ignores changes to system-managed tags (created_date, created_by)
- **Input Validation**: Comprehensive validation for resource names, locations, tags, and lock configurations
- **AVM Standards**: Follows Azure Verified Module output patterns for consistency

## Usage

### Basic Resource Group

```hcl
module "resource_group" {
  source = "../../modules/resource_group"
  
  name     = "USEQCXS05HRSG03"
  location = "East US"
  tags     = {
    ENVIRONMENT   = "QA"
    DEPLOYMENT_ID = "CXS05H"
  }
}
```

### Resource Group with RBAC Assignments

```hcl
module "resource_group" {
  source = "../../modules/resource_group"
  
  name     = "USEQCXS05HRSG03"
  location = "East US"
  tags     = {
    ENVIRONMENT = "QA"
  }
  
  role_assignments = {
    "eyx-dev-team" = {
      role_definition_id_or_name = "Contributor"
      principal_id               = "42d654d5-f215-497e-a7c9-3c5a6f3f7574"
      description                = "EYX Dev Team Contributor access"
    }
    "tax-admin-team" = {
      role_definition_id_or_name = "Reader"
      principal_id               = "042d637f-a83b-4f59-a34c-e556aa2a7840"
    }
  }
}
```

### Resource Group with Management Lock

```hcl
module "resource_group" {
  source = "../../modules/resource_group"
  
  name     = "USEPEYXP01RSG04"
  location = "East US"
  tags     = {
    ENVIRONMENT = "Production"
  }
  
  lock = {
    kind  = "CanNotDelete"
    name  = "prod-delete-lock"
    notes = "Prevents accidental deletion of production resources"
  }
}
```

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 1.0 |
| azurerm | >= 3.0 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| name | The name of the resource group to create | `string` | n/a | yes |
| location | The Azure region where the resource group will be created | `string` | n/a | yes |
| tags | A mapping of tags to assign to the resource group | `map(string)` | `{}` | no |
| role_assignments | A map of role assignments to create on the resource group | `map(object)` | `{}` | no |
| lock | Controls the Resource Lock configuration | `object` | `null` | no |
| enable_telemetry | This variable controls whether or not telemetry is enabled for the module | `bool` | `false` | no |

## Outputs

| Name | Description |
|------|-------------|
| resource | The full resource group object (AVM standard) |
| id | The ID of the resource group |
| name | The name of the resource group |
| location | The Azure region where the resource group is located |
| tags | The tags assigned to the resource group |
| role_assignments | A map of role assignments created on the resource group |
| lock | The management lock resource if one was created |

## Validation Rules

### Resource Group Name
- Length: 1-90 characters
- Allowed characters: alphanumerics, periods, underscores, hyphens, parenthesis
- Cannot end with a period

### Tags
- Tag keys: max 512 characters, alphanumerics, underscores, hyphens, periods, spaces
- Tag values: max 256 characters

### Management Lock
- Kind: must be "CanNotDelete" or "ReadOnly"
- Notes: max 512 characters

## Best Practices

1. **Use Meaningful Names**: Follow naming conventions (e.g., USEPEYXP01RSG04)
2. **Apply Consistent Tags**: Include ENVIRONMENT, DEPLOYMENT_ID, OWNER, ENGAGEMENT_ID
3. **Use Locks for Production**: Always apply CanNotDelete locks to production resource groups
4. **Principle of Least Privilege**: Assign Reader roles by default, Contributor only when necessary
5. **Document Role Assignments**: Use the description field to explain why access was granted

## Migration from AVM Module

This module provides a compatible replacement for the AVM resource group module:

**Before (AVM):**
```hcl
module "avm-res-resources-resourcegroup" {
  source           = "Azure/avm-res-resources-resourcegroup/azurerm"
  version          = "0.2.1"
  name             = var.resource_group_name
  location         = var.location
  role_assignments = var.resource_group_role_assignments
  lock             = var.lock
  tags             = var.tags
}

# Reference outputs
resource_group_name = module.avm-res-resources-resourcegroup.resource.name
```

**After (Custom):**
```hcl
module "resource_group" {
  source           = "../../modules/resource_group"
  name             = var.resource_group_name
  location         = var.location
  role_assignments = var.resource_group_role_assignments
  lock             = var.lock
  tags             = var.tags
}

# Reference outputs (compatible)
resource_group_name = module.resource_group.resource.name
```

## Terraform Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_terraform"></a> [terraform](#requirement\_terraform) | >= 1.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | >= 3.0 |

## Modules

No modules.

## Resources

| Name | Type |
|------|------|
| [azurerm_management_lock.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |
| [azurerm_resource_group.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/resource_group) | resource |
| [azurerm_role_assignment.this](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/role_assignment) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_location"></a> [location](#input\_location) | (Required) The Azure region where the resource group will be created. | `string` | n/a | yes |
| <a name="input_lock"></a> [lock](#input\_lock) | (Optional) Controls the Resource Lock configuration for this resource group.<br/><br/>- kind (Required): The type of lock. Possible values are 'CanNotDelete' and 'ReadOnly'.<br/>- name (Optional): The name of the lock. If not specified, a name will be generated based on the resource group name and lock kind.<br/>- notes (Optional): Specifies some notes about the lock. Maximum of 512 characters. | <pre>object({<br/>    kind  = string<br/>    name  = optional(string, null)<br/>    notes = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_name"></a> [name](#input\_name) | (Required) The name of the resource group to create. | `string` | n/a | yes |
| <a name="input_role_assignments"></a> [role\_assignments](#input\_role\_assignments) | (Optional) A map of role assignments to create on the resource group. The map key is arbitrary.<br/><br/>- role\_definition\_id\_or\_name (Required): The built-in role name or custom role definition ID.<br/>- principal\_id (Required): The ID of the principal (user, group, or service principal) to assign the role to.<br/>- description (Optional): A description for the role assignment.<br/>- skip\_service\_principal\_aad\_check (Optional): If true, skips validation that the principal exists in Azure AD. Default is false.<br/>- condition (Optional): A condition which will be used to scope the role assignment.<br/>- condition\_version (Optional): The version of the condition. Possible values are 1.0 or 2.0.<br/>- delegated\_managed\_identity\_resource\_id (Optional): The delegated Azure Resource ID which contains a Managed Identity. | <pre>map(object({<br/>    role_definition_id_or_name             = string<br/>    principal_id                           = string<br/>    description                            = optional(string, null)<br/>    skip_service_principal_aad_check       = optional(bool, false)<br/>    condition                              = optional(string, null)<br/>    condition_version                      = optional(string, null)<br/>    delegated_managed_identity_resource_id = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | (Optional) A mapping of tags to assign to the resource group. | `map(string)` | `{}` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_id"></a> [id](#output\_id) | The ID of the resource group. |
| <a name="output_location"></a> [location](#output\_location) | The Azure region where the resource group is located. |
| <a name="output_lock"></a> [lock](#output\_lock) | The management lock resource if one was created. |
| <a name="output_name"></a> [name](#output\_name) | The name of the resource group. |
| <a name="output_resource"></a> [resource](#output\_resource) | The full resource group object. This is the default output for the module following AVM standards. |
| <a name="output_role_assignments"></a> [role\_assignments](#output\_role\_assignments) | A map of role assignments created on the resource group. |
| <a name="output_tags"></a> [tags](#output\_tags) | The tags assigned to the resource group. |
<!-- END_TF_DOCS -->

## Security Considerations

- **RBAC**: All role assignments are explicitly defined and auditable
- **Locks**: Management locks prevent accidental deletion or modification
- **Tags**: System tags (created_date, created_by) are ignored to prevent drift
- **Validation**: Input validation prevents common configuration errors

---

**Last Updated**: January 2026  
**Maintained by**: EYX Infrastructure Team
