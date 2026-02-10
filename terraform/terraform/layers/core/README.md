# Core Layer - EYX Infrastructure

## Overview

The **Core Layer** is the foundational layer of the EYX infrastructure, responsible for deploying essential shared services that all other layers depend on. This layer creates the base resources including Resource Groups, Log Analytics Workspace, Key Vault, Application Insights, and managed identities.

This layer follows Azure Verified Modules (AVM) standards and provides a secure, monitored foundation for all application workloads.

## Architecture

```
┌────────────────────────────────────────────────────────┐
│                      Core Layer                        │
├────────────────────────────────────────────────────────┤
│                                                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Resource    │  │     Log      │  │  Application │  │
│  │    Group     │  │  Analytics   │  │   Insights   │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Key Vault   │  │  Workbook    │  │   Managed    │  │
│  │  + Policies  │  │              │  │   Identity   │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                        │
│  ┌──────────────┐  ┌──────────────┐                    │
│  │ RBAC Roles   │  │  Management  │                    │
│  │ Assignment   │  │    Locks     │                    │
│  └──────────────┘  └──────────────┘                    │
│                                                        │
└────────────────────────────────────────────────────────┘
```

## Table of Contents

- [Prerequisites](#prerequisites)
- [Components](#components)
  - [Resource Group](#resource-group)
  - [Log Analytics Workspace](#log-analytics-workspace)
  - [Key Vault](#key-vault)
  - [Application Insights](#application-insights)
  - [Workbook](#workbook)
  - [User Assigned Identity](#user-assigned-identity)
  - [RBAC Roles](#rbac-roles)
  - [Management Locks](#management-locks)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Outputs](#outputs)

## Prerequisites

Before deploying the Core Layer, ensure the following prerequisites are met:

1. **Azure Subscription**: Active Azure subscription with appropriate permissions
2. **Backend Storage**: Azure Storage Account for Terraform state (configured in `provider.tf`)
3. **Terraform Version**: >= 1.0
4. **Provider Versions**:
   - `hashicorp/azurerm` >= 3.0
   - `azure/azapi` >= 2.0
   - `Azure/modtm` 0.3.5

**Note**: Network Layer (VNets and Subnets) is deployed after Core Layer. Key Vault network ACLs are optional on first deployment and can be configured after the Network Layer is in place.

## Components

### Resource Group

Container for all core infrastructure resources using a custom module with enhanced security features.

#### What is it?

Azure Resource Group is a logical container that holds related Azure resources. It provides lifecycle management, access control, and cost tracking for grouped resources. This layer uses a custom resource group module that follows Azure Verified Module (AVM) standards while providing additional validation and security features.

#### What is it used for?

- Organizing and managing core infrastructure resources
- Applying RBAC permissions at the group level
- Tracking costs for the core infrastructure
- Enforcing governance policies with management locks
- Protecting production resources from accidental deletion

#### Features

- **RBAC Role Assignments**: Multiple role assignments with fine-grained access control
- **Management Locks**: CanNotDelete or ReadOnly locks for production protection
- **Tag Lifecycle Management**: Automatically ignores system-managed tags (created_date, created_by)
- **Input Validation**: Comprehensive validation for resource names (1-90 chars, alphanumerics only), tags (512-char keys, 256-char values), and lock configurations
- **AVM Compliance**: Follows Azure Verified Module output patterns for consistency

#### Usage Example

```hcl
# Resource Group with RBAC assignments and management lock
module "resource_group" {
  source           = "../../modules/resource_group"
  name             = var.resource_group_name
  location         = var.location
  role_assignments = var.resource_group_role_assignments
  lock             = var.lock
  tags             = merge(var.tags, var.resource_group_tags)
}

# Example with role assignments
role_assignments = {
  "eyx-dev-team" = {
    role_definition_id_or_name = "Contributor"
    principal_id               = "42d654d5-f215-497e-a7c9-3c5a6f3f7574"
    description                = "EYX Dev Team access"
  }
  "tax-admin-team" = {
    role_definition_id_or_name = "Reader"
    principal_id               = "042d637f-a83b-4f59-a34c-e556aa2a7840"
  }
}

# Example with management lock (UAT/PROD)
lock = {
  kind  = "CanNotDelete"
  name  = "prod-delete-lock"
  notes = "Prevents accidental deletion of production resources"
}
```

### Log Analytics Workspace

Centralized logging and monitoring platform for all Azure resources.

#### What is it?

Azure Log Analytics Workspace is a centralized repository for collecting, analyzing, and acting on telemetry data from Azure and on-premises resources. It powers Azure Monitor and provides powerful querying capabilities using KQL (Kusto Query Language).

#### What is it used for?

- Collecting diagnostic logs from all Azure services
- Monitoring application and infrastructure performance
- Security analytics and threat detection
- Capacity planning and cost optimization
- Troubleshooting and root cause analysis

#### Configuration Options

- **Retention**: Configurable retention period (default: 30-90 days based on environment)
- **Internet Access**: Control ingestion and query endpoints (enabled for Dev, restricted for Prod)
- **SKU**: Pay-as-you-go pricing model (PerGB2018)

#### Usage Example

```hcl
# Log Analytics Workspace (QA configuration)
module "avm-res-operationalinsights-workspace" {
  source                                              = "Azure/avm-res-operationalinsights-workspace/azurerm"
  version                                             = "0.4.2"
  name                                                = var.log_analytics_workspace_name
  location                                            = module.avm-res-resources-resourcegroup.resource.location
  resource_group_name                                 = module.avm-res-resources-resourcegroup.resource.name
  log_analytics_workspace_retention_in_days           = 30
  log_analytics_workspace_sku                         = "PerGB2018"
  log_analytics_workspace_internet_ingestion_enabled  = true
  log_analytics_workspace_internet_query_enabled      = true
  tags                                                = merge(var.tags, var.log_analytics_workspace_tags)
}
```

### Key Vault

Secure secrets, keys, and certificates management service.

#### What is it?

Azure Key Vault is a cloud service for securely storing and accessing secrets, encryption keys, and certificates. It provides hardware security module (HSM) backed key storage with centralized secret management.

#### What is it used for?

- Storing connection strings, passwords, and API keys
- Managing encryption keys for data protection
- Storing SSL/TLS certificates for applications
- Providing managed identity-based secret access
- Auditing and monitoring secret access

#### Security Features

- **Network ACLs**: Restricted to specific VNets and subnets
- **Access Policies**: Team-based access control (Dev, DevOps, Tax Admin teams)
- **Soft Delete**: 90-day retention for deleted secrets (configurable)
- **Purge Protection**: Prevents permanent deletion during retention period
- **Diagnostic Logging**: All access logged to Log Analytics

#### Access Policies

Standard access policies for teams:
- **EYX Dev Team**: Get, List, Set secrets
- **EYX DevOps Team**: Full secret, certificate, and key management
- **Tax Admin Team**: Get, List, Set secrets
- **CTP Platform**: Get, List secrets
- **Service Principals**: Environment-specific permissions

#### Network ACLs Configuration

**How ACLs Work:**
- Network ACLs control access when using public endpoints
- Only authorized subnets (Admin/GitHub Runner, Frontend, Backend) can access Key Vaults
- Configuration works for both Private Endpoint and non-Private Endpoint scenarios
- All environments use 7 subnets: 1 Admin + 3 Frontend + 3 Backend

**Architecture Pattern:**
The shared module uses an `env` variable to conditionally select the correct data sources:
- **DEV Environments** (`env = "DEV1"/"DEV2"/"DEV3"`): Admin resources queried from cross-subscription (`bcff8cd6`) using `dev_integration` provider alias
- **QA/UAT/PROD Environments** (`env = "QA"/"UAT"/"PROD"`): All resources in same subscription, standard data source queries

**Required Variables (All Environments):**
```hcl
# tfvars configuration
env                       = "DEV1"  # or DEV2, DEV3, QA, UAT, PROD
resource_group_name_admin = "USEDCXS05HRSG01"
resource_group_name_app   = "USEDCXS05HRSG04"
vnet_admin_name_01        = "USEDCXS05HVNT99"
subnet_admin_name_01      = "USEDCXS05HSBN00"  # GitHub Runner
vnet_app_name_01          = "USEDCXS05HVNT04"  # Frontend
subnet_app_name_01        = "USEDCXS05HSBN09"
subnet_app_name_02        = "USEDCXS05HSBN10"
subnet_app_name_03        = "USEDCXS05HSBN11"
vnet_app_name_02          = "USEDCXS05HVNT05"  # Backend
subnet1_name_app_02       = "USEDCXS05HSBN12"
subnet2_name_app_02       = "USEDCXS05HSBN13"
subnet3_name_app_02       = "USEDCXS05HSBN14"
```

**Configuration Flow:**
```
1. tfvars defines env variable and VNET/subnet names
2. Core layer passes env + subnet names to shared_data module
3. Shared module uses env to select correct data source:
   - DEV: Uses shared_vnet_admin_01_dev with dev_integration provider
   - Others: Uses shared_vnet_admin_01 with default provider
4. Locals.tf builds subnet ID list from shared_data outputs
5. Main.tf applies network_acls to Key Vault
```

**Shared Module Logic (simplified):**
```hcl
# Admin VNet for DEV (cross-subscription)
data "azurerm_virtual_network" "shared_vnet_admin_01_dev" {
  provider            = azurerm.dev_integration
  count               = var.env != null && contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) ? 1 : 0
  name                = var.vnet_admin_name_01
  resource_group_name = "USEDCXS05HRSG01"  # Admin RG in dev_integration subscription
}

# Admin VNet for QA/UAT/PROD (same subscription)
data "azurerm_virtual_network" "shared_vnet_admin_01" {
  count               = var.env != null && !contains(["DEV", "DEV1", "DEV2", "DEV3"], upper(var.env)) ? 1 : 0
  name                = var.vnet_admin_name_01
  resource_group_name = var.resource_group_name_admin
}

# Output uses fallback logic
output "admin_subnet1_id" {
  value = local.shared_subnet_admin_01_id  # Uses dev-specific or standard based on env value
}
```

**Core Layer ACL Resolution (locals.tf):**
```hcl
shared_data_subnet_ids = compact([
  try(module.shared_data.admin_subnet1_id, null),         # Admin (dev or standard)
  try(module.shared_data.subnet_app_shared_name_01.id, null),  # Frontend 1
  try(module.shared_data.subnet_app_shared_name_02.id, null),  # Frontend 2
  try(module.shared_data.subnet_app_shared_name_03.id, null),  # Frontend 3
  try(module.shared_data.subnet1_app_shared_id_app_02, null),  # Backend 1
  try(module.shared_data.subnet2_app_shared_id_app_02, null),  # Backend 2
  try(module.shared_data.subnet3_app_shared_id_app_02, null)   # Backend 3
])

key_vault_network_acls_final = {
  bypass                     = "AzureServices"
  default_action             = "Deny"
  ip_rules                   = []
  virtual_network_subnet_ids = local.shared_data_subnet_ids
}
```

**Troubleshooting Access Denied:**
```powershell
# Check current KV ACLs
az keyvault show --name <kv-name> --query "properties.networkAcls"

# Verify subnet count (should be 7)
terraform plan -var-file="environments/dev/dev1.tfvars" | Select-String -Pattern "HSBN"

# Validate env variable is set
grep "^env" environments/dev/dev1.tfvars
```

#### Usage Example

```hcl
# Key Vault with dynamic network ACLs
module "avm-res-keyvault-vault" {
  source                            = "./../azurerm_key_vault"
  name                              = var.key_vault_name
  location                          = module.avm-res-resources-resourcegroup.resource.location
  resource_group_name               = module.avm-res-resources-resourcegroup.resource.name
  tenant_id                         = data.azurerm_client_config.current.tenant_id
  
  enabled_for_template_deployment   = true
  enabled_for_deployment            = false
  enabled_for_disk_encryption       = false
  
  public_network_access_enabled     = false
  purge_protection_enabled          = true
  soft_delete_retention_days        = 90
  
  # Uses smart ACL resolution from locals
  network_acls = local.key_vault_network_acls_final
  
  legacy_access_policies = var.key_vault_legacy_access_policies
  diagnostic_settings    = var.key_vault_diagnostic_settings
  
  tags = merge(var.tags, var.key_vault_tags)
}
```

### Application Insights

Application performance monitoring and analytics.

#### What is it?

Azure Application Insights is an extensible Application Performance Management (APM) service that monitors live applications. It automatically detects performance anomalies and includes powerful analytics tools to diagnose issues.

#### What is it used for?

- Monitoring application performance and availability
- Tracking user behavior and usage patterns
- Detecting and diagnosing exceptions and failures
- Analyzing dependencies and external API calls
- Custom telemetry and business metrics

#### Configuration Options

- **Sampling Percentage**: 0-100% (100% = full telemetry, 0% = disabled)
  - DEV: 100% for full debugging
  - QA/UAT/PROD: 100% for comprehensive monitoring
- **Retention**: 30-90 days based on environment
- **Application Type**: web (for web applications and APIs)

#### Usage Example

```hcl
# Application Insights linked to Log Analytics
module "application_insights" {
  source                = "../application_insights"
  name                  = var.app_insights_name
  location              = module.avm-res-resources-resourcegroup.resource.location
  resource_group_name   = module.avm-res-resources-resourcegroup.resource.name
  workspace_id          = module.avm-res-operationalinsights-workspace.resource.id
  application_type      = "web"
  retention_in_days     = 30
  sampling_percentage   = 100
  tags                  = merge(var.tags, var.app_insights_tags)
}
```

### Workbook

Custom Azure Monitor Workbook for visualizing telemetry data.

#### What is it?

Azure Workbooks provide a flexible canvas for data analysis and the creation of rich visual reports within the Azure Portal. They combine text, analytics queries, metrics, and parameters into interactive reports.

#### What is it used for?

- Creating custom dashboards for monitoring
- Visualizing Application Insights data
- Building operational reports for teams
- Sharing insights across the organization

#### Features

- Linked to Application Insights component
- Uses random UUID for stable resource naming
- Lifecycle management ignores data_json changes (allows portal edits)
- Tagged with environment-specific metadata

#### Usage Example

```hcl
# Azure Workbook linked to Application Insights
resource "azurerm_application_insights_workbook" "this" {
  name                = random_uuid.workbook.result
  resource_group_name = module.avm-res-resources-resourcegroup.resource.name
  location            = module.avm-res-resources-resourcegroup.resource.location
  source_id           = module.application_insights[0].id
  display_name        = var.workbook_display_name
  category            = "workbook"
  tags                = merge(var.tags, var.workbook_tags)
  
  lifecycle {
    ignore_changes = [data_json]
  }
}
```

### User Assigned Identity

Managed identity for Azure Container Apps to access Azure Container Registry.

#### What is it?

Azure User Assigned Managed Identity is a standalone Azure resource that provides an identity for applications to use when connecting to resources that support Azure AD authentication.

#### What is it used for?

- Enabling Azure Container Apps to pull images from ACR without admin credentials
- Providing secure, credential-free access to Azure resources
- Supporting Skills Plugins deployment in Dev-1, Dev-Integration, and higher environments
- Eliminating the need for storing and rotating service principal credentials

#### Deployment Conditions

- **Required**: Dev-1, Dev (Integration), QA, UAT, PROD environments with Skills Plugins
- **Not Required**: Dev-2, Dev-3 (no Skills Plugins or ACA deployments)

#### Usage Example

```hcl
# User Assigned Identity for ACA image pulls
module "avm-res-userassignedidentity" {
  count               = var.user_assigned_identity_name != null ? 1 : 0
  source              = "Azure/avm-res-managedidentity-userassignedidentity/azurerm"
  version             = "0.3.4"
  name                = var.user_assigned_identity_name
  location            = module.avm-res-resources-resourcegroup.resource.location
  resource_group_name = module.avm-res-resources-resourcegroup.resource.name
  tags                = merge(var.tags, var.user_assigned_identity_tags)
}
```

### RBAC Roles

Role-based access control assignments for team collaboration.

#### What is it?

Azure RBAC (Role-Based Access Control) is Azure's authorization system built on Azure Resource Manager that provides fine-grained access management of Azure resources.

#### What is it used for?

- Granting teams appropriate access to resource groups
- Implementing least-privilege security principles
- Enabling collaboration without over-permissioning
- Auditing access through Azure Activity Logs

#### Default Role Assignments

When `enable_default_role_assignments = true` (Dev environments):
- **Tax Dev Team**: Contributor role
- **EYX Dev Team**: Contributor role
- **Tax Admin Team**: Reader role
- **EYX DevOps Team**: Contributor role

**Note**: Set to `false` for QA/UAT/PROD to preserve manually configured RBAC.

#### Usage Example

```hcl
# Default RBAC roles for Dev environment
variable "enable_default_role_assignments" {
  description = "When true, applies default RBAC roles for dev teams"
  type        = bool
  default     = true  # Dev only
}

# In QA/UAT/PROD tfvars
enable_default_role_assignments = false
```

### Management Locks

Resource protection to prevent accidental deletion.

#### What is it?

Azure Management Locks prevent accidental deletion or modification of critical resources. They override user permissions and must be explicitly removed before resources can be deleted.

#### What is it used for?

- Protecting production resources from accidental deletion
- Enforcing governance policies
- Adding an extra safety layer for critical infrastructure
- Preventing unauthorized resource changes

#### Lock Types

- **CanNotDelete**: Users can read and modify the resource, but cannot delete it
- **ReadOnly**: Users can read the resource, but cannot delete or modify it

#### Usage Example

```hcl
# Management lock for UAT/PROD environments
resource "azurerm_management_lock" "core_resource_group_delete" {
  count      = var.create_delete_lock ? 1 : 0
  name       = var.resource_group_name_app
  scope      = module.core.resource_group_id
  lock_level = "CanNotDelete"
  notes      = "Enforced by Core layer"
}

# In PROD tfvars
create_delete_lock = true
```

## Configuration

### Required Variables

| Variable | Type | Description |
|----------|------|-------------|
| `location` | string | Azure region (e.g., "East US") |
| `resource_group_name` | string | Resource group name |
| `resource_group_name_app` | string | App resource group name |
| `log_analytics_workspace_name` | string | Log Analytics Workspace name |
| `key_vault_name` | string | Key Vault name |
| `resource_group_name_admin` | string | Admin resource group name for network ACLs |
| `vnet_admin_name_01` | string | Admin VNET name |
| `subnet_admin_name_01` | string | Admin subnet name (GitHub Runner) |
| `vnet_app_name_01` | string | Frontend VNET name |
| `subnet_app_name_01` | string | Frontend subnet 1 name |
| `subnet_app_name_02` | string | Frontend subnet 2 name |
| `subnet_app_name_03` | string | Frontend subnet 3 name |
| `vnet_app_name_02` | string | Backend VNET name |
| `subnet1_name_app_02` | string | Backend subnet 1 name |
| `subnet2_name_app_02` | string | Backend subnet 2 name |
| `subnet3_name_app_02` | string | Backend subnet 3 name |

### Optional Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `env` | string | null | Environment identifier (DEV1, DEV2, DEV3, QA, UAT, PROD) for conditional logic (for example, network ACL configuration). Defaults to `null` if not set and should typically be provided via tfvars. |
| `app_insights_name` | string | null | Application Insights name (null = not deployed) |
| `user_assigned_identity_name` | string | null | Managed identity name (null = not deployed) |
| `app_insights_sampling_percentage` | number | 100 | Telemetry sampling (0-100, 100 = full) |
| `log_analytics_workspace_retention_in_days` | number | 30 | Log retention period |
| `key_vault_purge_protection_enabled` | bool | true | Enable purge protection |
| `key_vault_soft_delete_retention_days` | number | 90 | Soft delete retention |
| `enable_default_role_assignments` | bool | true | Apply default RBAC roles (Dev only) |
| `create_delete_lock` | bool | false | Create management lock (UAT/PROD) |

### Key Vault Access Policies

Access policies are environment-specific. Example for QA:

```hcl
key_vault_legacy_access_policies = {
  "eyx-dev-team-policy" = {
    object_id          = "42d654d5-f215-497e-a7c9-3c5a6f3f7574"
    secret_permissions = ["Get", "List", "Set"]
  }
  "eyx-devops-team-policy" = {
    object_id               = "c679f898-da3f-412f-b15f-1a37dad5ec42"
    secret_permissions      = ["Backup", "Delete", "Get", "List", "Purge", "Recover", "Set"]
    certificate_permissions = ["Backup", "Create", "Get", "Import", "List", "Update"]
  }
  "taxadmin-team-policy" = {
    object_id          = "042d637f-a83b-4f59-a34c-e556aa2a7840"
    secret_permissions = ["Get", "List", "Set"]
  }
}
```

### Environment-Specific Configurations

#### DEV Environments
- Full telemetry (100% sampling)
- Extended retention (90 days)
- Internet access enabled
- Default RBAC roles applied
- No management locks

#### QA/UAT Environments
- Full telemetry (100% sampling)
- Standard retention (30 days)
- Restricted network access
- Manual RBAC configuration
- Optional management locks

#### PROD Environments
- Full telemetry (100% sampling)
- Standard retention (30 days)
- Fully restricted network access
- Manual RBAC configuration
- Management locks enforced

## Deployment

### Environment Setup

1. **Configure Backend** (in `provider.tf`):
   ```hcl
   terraform {
     backend "azurerm" {
       resource_group_name  = "USEQCXS05HRSG02"
       storage_account_name = "useqcxs05hsta01"
       container_name       = "terraform"
       key                  = "layers/core/qa/terraform.tfstate"
       subscription_id      = "bcff8cd6-13ff-48f9-8a70-2e5478106b1a"
     }
   }
   ```

2. **Initialize Terraform**:
   ```bash
   terraform init
   ```

3. **Plan Deployment**:
   ```bash
   terraform plan -var-file="environments/qa/qa.tfvars"
   ```

4. **Apply Changes**:
   ```bash
   terraform apply -var-file="environments/qa/qa.tfvars"
   ```

### Deployment Order

Core layer is deployed **first**, followed by other layers:

1. ✅ **Core Layer** (this layer)
2. ✅ **Network Layer** (VNets and Subnets)
3. Backend Layer
4. App Layer
5. Integration Layer
6. Config Layer

**Note**: After Network Layer is deployed, update Core Layer configuration to add Key Vault network ACLs referencing the deployed subnets.

## Outputs

The Core Layer provides the following outputs for consumption by other layers:

### Resource Group Outputs

| Output | Description | Sensitive |
|--------|-------------|-----------|
| `resource_group_name` | Resource group name | No |
| `resource_group_id` | Resource group ID | No |
| `resource_group_location` | Resource group location | No |

### Log Analytics Outputs

| Output | Description | Sensitive |
|--------|-------------|-----------|
| `log_analytics_workspace_id` | Workspace resource ID | Yes |

### Key Vault Outputs

| Output | Description | Sensitive |
|--------|-------------|-----------|
| `key_vault_name` | Key Vault name | No |
| `key_vault_id` | Key Vault resource ID | No |
| `key_vault_uri` | Key Vault URI | No |
| `key_vault_keys` | Stored keys | No |
| `key_vault_keys_ids` | Key IDs | No |
| `key_vault_secrets` | Stored secrets | No |
| `key_vault_secrets_ids` | Secret IDs | No |

### Application Insights Outputs

| Output | Description | Sensitive |
|--------|-------------|-----------|
| `app_insights_id` | Application Insights resource ID | No |
| `app_insights_instrumentation_key` | Instrumentation key | Yes |
| `app_insights_connection_string` | Connection string | Yes |

### Managed Identity Outputs

| Output | Description | Sensitive |
|--------|-------------|-----------|
| `user_assigned_identity_client_id` | Client ID of managed identity | No |

### Usage in Other Layers

```hcl
# Reference Core Layer outputs from App Layer
data "terraform_remote_state" "core" {
  backend = "azurerm"
  config = {
    resource_group_name  = "USEQCXS05HRSG02"
    storage_account_name = "useqcxs05hsta01"
    container_name       = "terraform"
    key                  = "layers/core/qa/terraform.tfstate"
  }
}

# Use outputs
log_analytics_workspace_id = data.terraform_remote_state.core.outputs.log_analytics_workspace_id
key_vault_id               = data.terraform_remote_state.core.outputs.key_vault_id
```

## Contributing

When contributing to this layer:

1. Follow Azure Verified Modules (AVM) patterns
2. Add appropriate variable validation
3. Update this README with examples
4. Test changes in DEV environment first
5. Never commit sensitive values (use .tfvars, exclude from git)

## Terraform Documentation

<!-- BEGIN_TF_DOCS -->
## Requirements

| Name | Version |
|------|---------|
| <a name="requirement_azapi"></a> [azapi](#requirement\_azapi) | >= 2.0 |
| <a name="requirement_azurerm"></a> [azurerm](#requirement\_azurerm) | >= 3.0 |
| <a name="requirement_modtm"></a> [modtm](#requirement\_modtm) | 0.3.5 |

## Providers

| Name | Version |
|------|---------|
| <a name="provider_azurerm"></a> [azurerm](#provider\_azurerm) | 4.57.0 |

## Modules

| Name | Source | Version |
|------|--------|---------|
| <a name="module_core"></a> [core](#module\_core) | ../../modules/core | n/a |
| <a name="module_shared_data"></a> [shared\_data](#module\_shared\_data) | ../shared | n/a |

## Resources

| Name | Type |
|------|------|
| [azurerm_management_lock.core_resource_group_delete](https://registry.terraform.io/providers/hashicorp/azurerm/latest/docs/resources/management_lock) | resource |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| <a name="input_app_insights_application_type"></a> [app\_insights\_application\_type](#input\_app\_insights\_application\_type) | The type of application being monitored. Valid values are: ios, java, MobileCenter, Node.JS, other, phone, store, web. | `string` | `"web"` | no |
| <a name="input_app_insights_name"></a> [app\_insights\_name](#input\_app\_insights\_name) | The name of the Application Insights component. | `string` | `null` | no |
| <a name="input_app_insights_retention_in_days"></a> [app\_insights\_retention\_in\_days](#input\_app\_insights\_retention\_in\_days) | The retention period in days. Possible values are 30, 60, 90, 120, 180, 270, 365, 550 or 730. | `number` | `90` | no |
| <a name="input_app_insights_sampling_percentage"></a> [app\_insights\_sampling\_percentage](#input\_app\_insights\_sampling\_percentage) | The percentage of telemetry items tracked that are sampled. Valid range: 0-100. | `number` | `100` | no |
| <a name="input_app_insights_tags"></a> [app\_insights\_tags](#input\_app\_insights\_tags) | Specific tags for the Application Insights component. | `map(string)` | `{}` | no |
| <a name="input_create_delete_lock"></a> [create\_delete\_lock](#input\_create\_delete\_lock) | (Optional). When true, create a management lock (CanNotDelete) on the core resource group. Intended to be set in environment tfvars for UAT/Prod. | `bool` | `false` | no |
| <a name="input_delete_lock_name"></a> [delete\_lock\_name](#input\_delete\_lock\_name) | (Optional). Name to assign to the delete lock. If not set, a name will be generated from the resource group name. | `string` | `null` | no |
| <a name="input_enable_default_role_assignments"></a> [enable\_default\_role\_assignments](#input\_enable\_default\_role\_assignments) | (Optional). When true, applies default RBAC role assignments for Tax Dev, EYX Dev, Tax Admin, and DevOps teams.<br/>Set to false for QA and higher environments to preserve existing RBAC configurations.<br/>Default is true for Dev environments. | `bool` | `true` | no |
| <a name="input_enable_telemetry"></a> [enable\_telemetry](#input\_enable\_telemetry) | (Optional). Enable or disable telemetry for the module. Default is false. | `bool` | `false` | no |
| <a name="input_enabled_for_deployment"></a> [enabled\_for\_deployment](#input\_enabled\_for\_deployment) | Specifies whether Azure Virtual Machines are permitted to retrieve certificates stored as secrets from the vault. | `bool` | `true` | no |
| <a name="input_enabled_for_disk_encryption"></a> [enabled\_for\_disk\_encryption](#input\_enabled\_for\_disk\_encryption) | Specifies whether Azure Disk Encryption is permitted to retrieve secrets from the vault and unwrap keys. | `bool` | `true` | no |
| <a name="input_environment_tag_key"></a> [environment\_tag\_key](#input\_environment\_tag\_key) | Tag key used to identify the environment (e.g., ENVIRONMENT, Environment, env) | `string` | `"ENVIRONMENT"` | no |
| <a name="input_key_vault_diagnostic_settings"></a> [key\_vault\_diagnostic\_settings](#input\_key\_vault\_diagnostic\_settings) | A map of diagnostic settings to create on the Key Vault. The map key is arbitrary. See AVM module documentation for details.<br/>- name (Optional): The name of the diagnostic setting. One will be generated if not set, but this will not be unique if you want to create multiple diagnostic setting resources.<br/>- log\_categories (Optional): A set of log categories to send to the log analytics workspace. Defaults to [].<br/>- log\_groups (Optional): A set of log groups to send to the log analytics workspace. Defaults to ["allLogs"].<br/>- metric\_categories (Optional): A set of metric categories to send to the log analytics workspace. Defaults to ["AllMetrics"].<br/>- log\_analytics\_destination\_type (Optional): The destination type for the diagnostic setting. Possible values are "Dedicated" and "AzureDiagnostics". Defaults to "Dedicated".<br/>- workspace\_resource\_id (Optional): The resource ID of the log analytics workspace to send logs and metrics to.<br/>- storage\_account\_resource\_id (Optional): The resource ID of the storage account to send logs and metrics to.<br/>- event\_hub\_authorization\_rule\_resource\_id (Optional): The resource ID of the event hub authorization rule to send logs and metrics to.<br/>- event\_hub\_name (Optional): The name of the event hub. If none is specified, the default event hub will be selected. | <pre>map(object({<br/>    workspace_resource_id = optional(string, null)<br/>  }))</pre> | `{}` | no |
| <a name="input_key_vault_enabled_for_template_deployment"></a> [key\_vault\_enabled\_for\_template\_deployment](#input\_key\_vault\_enabled\_for\_template\_deployment) | Specifies whether Azure Resource Manager is permitted to retrieve secrets from the vault. | `bool` | `false` | no |
| <a name="input_key_vault_legacy_access_policies"></a> [key\_vault\_legacy\_access\_policies](#input\_key\_vault\_legacy\_access\_policies) | A map of legacy access policies to create on the Key Vault. The map key is arbitrary. Requires `var.key_vault_legacy_access_policies_enabled` to be `true`. See AVM module documentation for details.<br/>- object\_id: (Required) The object ID of the principal to assign the access policy to.<br/>- application\_id: (Optional) The object ID of an Application in Azure Active Directory. Changing this forces a new resource to be created.<br/>- certificate\_permissions: (Optional) A list of certificate permissions. Possible values are: Backup, Create, Delete, DeleteIssuers, Get, GetIssuers, Import, List, ListIssuers, ManageContacts, ManageIssuers, Purge, Recover, Restore, SetIssuers, Update.<br/>- key\_permissions: (Optional) A list of key permissions. Possible values are: Backup, Create, Decrypt, Delete, Encrypt, Get, Import, List, Purge, Recover, Restore, Sign, UnwrapKey, Update, Verify, WrapKey, Release, Rotate, GetRotationPolicy, SetRotationPolicy.<br/>- secret\_permissions: (Optional) A list of secret permissions. Possible values are: Backup, Delete, Get, List, Purge, Recover, Restore, Set.<br/>- storage\_permissions: (Optional) A list of storage permissions. Possible values are: Backup, Delete, DeleteSAS, Get, GetSAS, List, ListSAS, Purge, Recover, RegenerateKey, Restore, Set, SetSAS, Update. | <pre>map(object({<br/>    object_id               = string<br/>    application_id          = optional(string, null)<br/>    certificate_permissions = optional(set(string), [])<br/>    key_permissions         = optional(set(string), [])<br/>    secret_permissions      = optional(set(string), [])<br/>    storage_permissions     = optional(set(string), [])<br/>  }))</pre> | `{}` | no |
| <a name="input_key_vault_name"></a> [key\_vault\_name](#input\_key\_vault\_name) | (Required). The name of the Key Vault to create. | `string` | n/a | yes |
| <a name="input_key_vault_network_acls"></a> [key\_vault\_network\_acls](#input\_key\_vault\_network\_acls) | The network ACL configuration for the Key Vault. If not specified then the Key Vault will be created with a firewall that blocks access. Specify `null` to create the Key Vault with no firewall.<br/>- bypass: (Optional) Should Azure Services bypass the ACL. Possible values are `AzureServices` and `None`. Defaults to `None`.<br/>- default\_action: (Optional) The default action when no rule matches. Possible values are `Allow` and `Deny`. Defaults to `Deny`.<br/>- ip\_rules: (Optional) A list of IP rules in CIDR format. Defaults to [].<br/>- virtual\_network\_subnet\_ids: (Optional) When using with Service Endpoints, a list of subnet IDs to associate with the Key Vault. Defaults to []. | <pre>object({<br/>    bypass                     = optional(string, "None")<br/>    default_action             = optional(string, "Deny")<br/>    ip_rules                   = optional(list(string), [])<br/>    virtual_network_subnet_ids = optional(list(string), [])<br/>  })</pre> | `{}` | no |
| <a name="input_key_vault_public_network_access_enabled"></a> [key\_vault\_public\_network\_access\_enabled](#input\_key\_vault\_public\_network\_access\_enabled) | Specifies whether public network access is enabled for the Key Vault. Defaults to true. | `bool` | `true` | no |
| <a name="input_key_vault_sku_name"></a> [key\_vault\_sku\_name](#input\_key\_vault\_sku\_name) | The SKU name of the Key Vault. Default is `premium`. Possible values are `standard` and `premium`. | `string` | `"premium"` | no |
| <a name="input_key_vault_tags"></a> [key\_vault\_tags](#input\_key\_vault\_tags) | Specific tags for the Key Vault. | `map(string)` | `{}` | no |
| <a name="input_location"></a> [location](#input\_location) | (Required). The location where the resource group will be created. | `string` | n/a | yes |
| <a name="input_lock"></a> [lock](#input\_lock) | Controls the Resource Lock configuration for this resource. The following properties can be specified:<br/>- kind (Required): The type of lock. Possible values are "CanNotDelete" and "ReadOnly".<br/>- name (Optional): The name of the lock. If not specified, a name will be generated based on the kind value. Changing this forces the creation of a new resource. | <pre>object({<br/>    kind = string<br/>    name = optional(string, null)<br/>  })</pre> | `null` | no |
| <a name="input_log_analytics_workspace_identity"></a> [log\_analytics\_workspace\_identity](#input\_log\_analytics\_workspace\_identity) | Specifies the identity configuration for the Log Analytics Workspace.<br/>- identity\_ids (Optional): Specifies a list of user managed identity ids to be assigned. Required if `type` is `UserAssigned`.<br/>- type (Required): Specifies the identity type of the Log Analytics Workspace. Possible values are `SystemAssigned` and `UserAssigned`. | <pre>object({<br/>    identity_ids = optional(set(string))<br/>    type         = string<br/>  })</pre> | `null` | no |
| <a name="input_log_analytics_workspace_name"></a> [log\_analytics\_workspace\_name](#input\_log\_analytics\_workspace\_name) | (Required). The name of the Log Analytics Workspace to create. | `string` | n/a | yes |
| <a name="input_log_analytics_workspace_retention_in_days"></a> [log\_analytics\_workspace\_retention\_in\_days](#input\_log\_analytics\_workspace\_retention\_in\_days) | (Optional). The retention period (in days) for the Log Analytics Workspace data. Default is 365 days. | `number` | `365` | no |
| <a name="input_log_analytics_workspace_tags"></a> [log\_analytics\_workspace\_tags](#input\_log\_analytics\_workspace\_tags) | Specific tags for the Log Analytics Workspace. | `map(string)` | `{}` | no |
| <a name="input_resource_group_name"></a> [resource\_group\_name](#input\_resource\_group\_name) | (Required). The name of the resource group to create. | `string` | n/a | yes |
| <a name="input_resource_group_name_admin"></a> [resource\_group\_name\_admin](#input\_resource\_group\_name\_admin) | The name of the resource group for the admin environment. | `string` | `null` | no |
| <a name="input_resource_group_name_app"></a> [resource\_group\_name\_app](#input\_resource\_group\_name\_app) | The name of the resource group for the app environment. | `string` | `null` | no |
| <a name="input_resource_group_role_assignments"></a> [resource\_group\_role\_assignments](#input\_resource\_group\_role\_assignments) | (Optional). A map of role assignments to create on this resource. The map key is arbitrary. See AVM module documentation for details. | <pre>map(object({<br/>    role_definition_id_or_name       = string<br/>    principal_id                     = string<br/>    skip_service_principal_aad_check = optional(bool, false)<br/>  }))</pre> | `{}` | no |
| <a name="input_resource_group_tags"></a> [resource\_group\_tags](#input\_resource\_group\_tags) | Specific tags for the resource group. | `map(string)` | `{}` | no |
| <a name="input_subnet1_name_app_01"></a> [subnet1\_name\_app\_01](#input\_subnet1\_name\_app\_01) | The name of the first subnet for the app environment. | `string` | `null` | no |
| <a name="input_subnet1_name_app_02"></a> [subnet1\_name\_app\_02](#input\_subnet1\_name\_app\_02) | The name of the first subnet for the app environment. | `string` | `null` | no |
| <a name="input_subnet1_name_app_03"></a> [subnet1\_name\_app\_03](#input\_subnet1\_name\_app\_03) | The name of the first subnet for the app environment. | `string` | `null` | no |
| <a name="input_subnet3_name_app_02"></a> [subnet3\_name\_app\_02](#input\_subnet3\_name\_app\_02) | The name of the third subnet for the app environment | `string` | `null` | no |
| <a name="input_subnet_admin_name_01"></a> [subnet\_admin\_name\_01](#input\_subnet\_admin\_name\_01) | The name of the subnet for the admin environment. | `string` | `null` | no |
| <a name="input_subnet_app_name_01"></a> [subnet\_app\_name\_01](#input\_subnet\_app\_name\_01) | The name of the subnet for the app environment. | `string` | `null` | no |
| <a name="input_subnet_app_name_02"></a> [subnet\_app\_name\_02](#input\_subnet\_app\_name\_02) | The name of the subnet for the app environment. | `string` | `null` | no |
| <a name="input_subnet_app_name_03"></a> [subnet\_app\_name\_03](#input\_subnet\_app\_name\_03) | The name of the subnet for the app environment. | `string` | `null` | no |
| <a name="input_tags"></a> [tags](#input\_tags) | A map of tags to assign to the resources. | `map(string)` | `{}` | no |
| <a name="input_user_assigned_identity_name"></a> [user\_assigned\_identity\_name](#input\_user\_assigned\_identity\_name) | (Required). The name of the User Assigned Identity to create. | `string` | n/a | yes |
| <a name="input_user_assigned_identity_tags"></a> [user\_assigned\_identity\_tags](#input\_user\_assigned\_identity\_tags) | Specific tags for the User Assigned Identity. | `map(string)` | `{}` | no |
| <a name="input_vnet_admin_name_01"></a> [vnet\_admin\_name\_01](#input\_vnet\_admin\_name\_01) | The name of the virtual network for the admin environment. | `string` | `null` | no |
| <a name="input_vnet_app_name_01"></a> [vnet\_app\_name\_01](#input\_vnet\_app\_name\_01) | The name of the virtual network for the app environment. | `string` | `null` | no |
| <a name="input_vnet_app_name_02"></a> [vnet\_app\_name\_02](#input\_vnet\_app\_name\_02) | The name of the virtual network for the app environment. | `string` | `null` | no |
| <a name="input_workbook_display_name"></a> [workbook\_display\_name](#input\_workbook\_display\_name) | The display name of the workbook. | `string` | `null` | no |
| <a name="input_workbook_tags"></a> [workbook\_tags](#input\_workbook\_tags) | Specific tags for the Azure Workbook. | `map(string)` | `{}` | no |
| <a name="input_workspace_resource_id"></a> [workspace\_resource\_id](#input\_workspace\_resource\_id) | Resource ID del Log Analytics Workspace para los diagnósticos del Key Vault | `string` | `null` | no |

## Outputs

| Name | Description |
|------|-------------|
| <a name="output_app_insights_connection_string"></a> [app\_insights\_connection\_string](#output\_app\_insights\_connection\_string) | The connection string of the Application Insights component. |
| <a name="output_app_insights_id"></a> [app\_insights\_id](#output\_app\_insights\_id) | The ID of the Application Insights component. |
| <a name="output_app_insights_instrumentation_key"></a> [app\_insights\_instrumentation\_key](#output\_app\_insights\_instrumentation\_key) | The instrumentation key of the Application Insights component. |
| <a name="output_key_vault_id"></a> [key\_vault\_id](#output\_key\_vault\_id) | The ID of the Key Vault created by the core module. |
| <a name="output_key_vault_keys"></a> [key\_vault\_keys](#output\_key\_vault\_keys) | The keys stored in the Key Vault created by the core module. |
| <a name="output_key_vault_keys_ids"></a> [key\_vault\_keys\_ids](#output\_key\_vault\_keys\_ids) | The IDs of the keys stored in the Key Vault created by the core module. |
| <a name="output_key_vault_name"></a> [key\_vault\_name](#output\_key\_vault\_name) | The name of the Key Vault created by the core module. |
| <a name="output_key_vault_secrets"></a> [key\_vault\_secrets](#output\_key\_vault\_secrets) | The secrets stored in the Key Vault created by the core module. |
| <a name="output_key_vault_secrets_ids"></a> [key\_vault\_secrets\_ids](#output\_key\_vault\_secrets\_ids) | The IDs of the secrets stored in the Key Vault. |
| <a name="output_key_vault_uri"></a> [key\_vault\_uri](#output\_key\_vault\_uri) | The URI of the Key Vault. |
| <a name="output_log_analytics_workspace_id"></a> [log\_analytics\_workspace\_id](#output\_log\_analytics\_workspace\_id) | The ID of the Log Analytics workspace created by this module. |
| <a name="output_resource_group_id"></a> [resource\_group\_id](#output\_resource\_group\_id) | The ID of the resource group created by this module. |
| <a name="output_resource_group_location"></a> [resource\_group\_location](#output\_resource\_group\_location) | The location of the resource group created by this module. |
| <a name="output_resource_group_name"></a> [resource\_group\_name](#output\_resource\_group\_name) | The name of the resource group created by this module. |
| <a name="output_user_assigned_identity_client_id"></a> [user\_assigned\_identity\_client\_id](#output\_user\_assigned\_identity\_client\_id) | The client ID of the user-assigned managed identity created or referenced by the core module. |
<!-- END_TF_DOCS -->

## Support

For issues or questions, contact the infrastructure team.

---

**Last Updated**: January 2026  
**Maintained by**: EYX Infrastructure Team  
**Terraform Version**: >= 1.0  
**Provider Versions**: azurerm >= 3.0, azapi >= 2.0, modtm 0.3.5
