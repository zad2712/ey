# App Layer - EYX Infrastructure

## Overview

The **App Layer** is responsible for deploying and managing application-level resources in the EYX infrastructure. This layer orchestrates multiple Azure services including App Services, Container Apps, Storage Accounts, Cognitive Services, and supporting infrastructure components.

This layer follows a modular architecture where each component is encapsulated in a reusable module, promoting consistency, maintainability, and scalability across environments (DEV, QA, UAT, PROD).

## Architecture

```
┌────────────────────────────────────────────────────────┐
│                        App Layer                       │
├────────────────────────────────────────────────────────┤
│                                                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │ App Service  │  │ Container    │  │  Storage     │  │
│  │   Plans      │  │    Apps      │  │  Accounts    │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │   Web Apps   │  │  Functions   │  │  SignalR     │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                        │
│  ┌──────────────┐  ┌──────────────┐  ┌──────────────┐  │
│  │  Cognitive   │  │   Container  │  │   Private    │  │
│  │  Services    │  │   Registry   │  │  Endpoints   │  │
│  └──────────────┘  └──────────────┘  └──────────────┘  │
│                                                        │
└────────────────────────────────────────────────────────┘
```

## Table of Contents

- [Prerequisites](#prerequisites)
- [Components](#components)
  - [App Service Plans](#app-service-plans)
  - [Web Applications](#web-applications)
  - [Azure Functions](#azure-functions)
  - [Container Apps](#container-apps)
  - [Storage Accounts](#storage-accounts)
  - [Cognitive Services](#cognitive-services)
  - [SignalR Service](#signalr-service)
  - [Container Registry](#container-registry)
  - [Private Endpoints](#private-endpoints)
- [Configuration](#configuration)
- [Deployment](#deployment)
- [Outputs](#outputs)

## Prerequisites

Before deploying the App Layer, ensure the following prerequisites are met:

1. **Azure Subscription**: Active Azure subscription with appropriate permissions
2. **Backend Storage**: Azure Storage Account for Terraform state (configured in `provider.tf`)
3. **Network Layer**: Virtual Networks, Subnets, and Private DNS Zones must be deployed
4. **Core Layer**: Log Analytics Workspace, Application Insights must exist
5. **Admin Layer**: Key Vault with required secrets must be deployed
6. **Terraform Version**: >= 1.0
7. **Provider Versions**:
   - `hashicorp/azurerm` >= 3.0
   - `azure/azapi` >= 2.0

## Components

### App Service Plans

App Service Plans provide the compute resources for hosting web applications and functions. This layer supports multiple App Service Plans for different workload types.

#### What is it?

An App Service Plan defines the compute resources (CPU, memory, storage) for hosting web applications and Azure Functions. It determines the pricing tier, scaling capabilities, and features available to the hosted applications.

#### What is it used for?

- Hosting Windows-based web applications (.NET, Node.js, etc.)
- Running Azure Functions on dedicated compute
- Providing auto-scaling capabilities for API workloads
- Ensuring high availability with multiple instances

#### Modules Used

- **UI App Service Plan** (`app_service_plan_ui`): Hosts frontend web applications
- **API App Service Plan** (`app_service_plan_apis`): Hosts backend API services with auto-scaling enabled
- **Functions App Service Plan** (`app_service_plan_functions`): Dedicated plan for Azure Functions

#### Auto-scaling Configuration

Auto-scaling is available for Premium v2/v3 SKUs:

**Scale-Out Rule:**
- Trigger: CPU > 50% (Average) over 1 minute
- Action: Add 2 instances
- Cooldown: 1 minute

**Scale-In Rule:**
- Trigger: CPU < 30% (Minimum) over 10 minutes
- Action: Remove 1 instance
- Cooldown: 5 minutes

**Instance Limits:**
- Minimum: 2 instances
- Maximum: 8 instances
- Default: 2 instances

#### Usage Example

```hcl
# API App Service Plan with auto-scaling (UAT-Lab configuration)
module "app_service_plan_apis" {
  source                     = "../../modules/app_service_plan"
  name                       = var.app_service_plan_name_app_02
  location                   = local.resource_group_app_location
  resource_group_name        = local.resource_group_app_name
  os_type                    = var.os_type_service_plan_app_02
  sku_name                   = var.sku_name_service_plan_app_02
  tags                       = local.merged_tags.app_service_plan_apis_tags
  log_analytics_workspace_id = local.law_shared_app_id
  
  # Enable auto-scaling
  enable_autoscale = var.enable_autoscale_app_02
}
```

### Web Applications

Windows-based web applications hosted on App Service.

#### What is it?

Azure App Service is a fully managed platform for building, deploying, and scaling web applications. It provides built-in infrastructure maintenance, security patching, and scaling capabilities.

#### What is it used for?

- Hosting the frontend UI application (microfrontend)
- Running backend API services (.NET Core)
- Providing notice generation services
- Hosting kernel memory integration APIs

#### Application Types

1. **UI Application** (`web_app_name_app_01`): Frontend microfrontend application
2. **Web API** (`web_app_name_app_02`): Main backend API service
3. **Notice API** (`web_app_name_app_03`): Notice generation service
4. **Kernel Memory API** (`web_app_name_app_04`): Kernel memory integration service

#### Usage Example

```hcl
# Web API Application (UAT-Lab configuration)
module "app_service_windows_web_api" {
  source                     = "../../modules/app_service_windows"
  name                       = var.web_app_name_app_02
  location                   = local.resource_group_app_location
  resource_group_name        = local.resource_group_app_name
  service_plan_id            = module.app_service_plan_apis.service_plan_id
  virtual_network_subnet_id  = local.subnet_app_02_id
  
  identity_type              = "SystemAssigned, UserAssigned"
  identity_ids               = []
  
  app_settings               = local.app_settings_web_api
  site_config                = local.site_config_web_api
  
  diagnostic_settings = {
    send_all_to_workspace = {
      workspace_id = local.law_shared_app_id
    }
  }
  
  tags = local.merged_tags.app_service_web_api_tags
}
```

### Azure Functions

Serverless compute for event-driven workloads and background processing.

#### What is it?

Azure Functions is a serverless compute service that allows you to run event-driven code without managing infrastructure. Functions automatically scale based on demand and you only pay for the compute time consumed.

#### What is it used for?

- Processing malware scan results from Storage Account events
- Running scheduled background jobs
- Handling event-driven workflows
- Executing API integrations

#### Usage Example

```hcl
# Azure Function App (UAT-Lab configuration)
module "function_app_01" {
  source                     = "../../modules/windows_function_app"
  name                       = var.function_app_name_app_01
  location                   = local.resource_group_app_location
  resource_group_name        = local.resource_group_app_name
  service_plan_id            = module.app_service_plan_functions.service_plan_id
  storage_account_name       = local.storage_account_app_01_name
  
  virtual_network_subnet_id  = local.subnet_app_02_id
  identity_type              = "SystemAssigned, UserAssigned"
  identity_ids               = []
  
  app_settings               = local.app_settings_function_app_01
  site_config                = local.site_config_function_app_01
  
  diagnostic_settings = {
    send_all_to_workspace = {
      workspace_id = local.law_shared_app_id
    }
  }
  
  tags = local.merged_tags.function_app_01_tags
}
```

### Container Apps

Serverless container hosting with Azure Container Apps, supporting dynamic scaling and session pools.

#### What is it?

Azure Container Apps is a fully managed serverless container service that enables you to run containerized applications without managing infrastructure. It provides built-in support for Dapr, KEDA-based scaling, and microservices patterns.

#### What is it used for?

- Hosting containerized microservices
- Running Python code execution environments (session pools)
- Providing dynamic scaling based on HTTP requests or custom metrics
- Managing containerized workloads with automatic HTTPS and custom domains

#### Components

1. **Container App Environment**: Provides the execution environment for container apps
2. **Container App**: Main application container
3. **Session Pool**: Python LTS session pool for dynamic code execution with auto-assigned RBAC roles

#### Usage Example

```hcl
# Container App Environment (UAT-Lab configuration)
module "container_app_environment" {
  count = var.deploy_resource && var.container_app_name != null ? 1 : 0
  
  source                         = "../../modules/container_app_environment"
  name                           = var.container_app_environment
  location                       = local.resource_group_app_location
  resource_group_name            = local.resource_group_app_name
  log_analytics_workspace_id     = local.law_shared_app_id
  infrastructure_subnet_id       = local.subnet_app_03_id
  internal_load_balancer_enabled = true
  zone_redundancy_enabled        = var.container_app_zone_redundancy_enabled
  tags                           = local.merged_tags.container_app_environment_tags
}

# Container App with Session Pool
module "container_app_session_pool" {
  count  = var.session_pool_enabled ? 1 : 0
  source = "../../modules/container_app_session_pool"
  
  session_pool_name              = "${var.container_app_name}-python-pool"
  location                       = local.resource_group_app_location
  resource_group_name            = local.resource_group_app_name
  container_app_environment_id   = module.container_app_environment[0].id
  
  container_type                 = var.session_pool_container_type
  max_concurrent_sessions        = var.session_pool_max_concurrent_sessions
  ready_session_instances        = var.session_pool_ready_session_instances
  
  enable_default_roles           = var.session_pool_enable_default_roles
  app_service_managed_identities = local.final_app_service_managed_identities_for_session_pool
  
  tags = local.merged_tags.container_app_session_pool_tags
}
```

### Storage Accounts

Azure Storage Accounts for blob, queue, table, and file storage with advanced security features.

#### What is it?

Azure Storage Account is a cloud storage solution that provides highly available, secure, durable, and massively scalable storage for data objects. It supports multiple storage services including Blob, Queue, Table, and File storage.

#### What is it used for?

- Storing application data, documents, and files
- Hosting static website content
- Providing queue-based messaging for background jobs
- Storing Azure Functions runtime and state
- Malware scanning of uploaded files using Azure Defender for Storage

#### Malware Scanning

The primary storage account includes Microsoft Defender for Storage with:
- Event Grid integration for malware scan results
- Monthly capacity limit of 5000 GB
- Sensitive data discovery enabled
- Exclusion of temporary/cache folders from scanning

#### Usage Example

```hcl
# Primary Storage Account with Malware Scanning (UAT-Lab configuration)
module "storage_account_app_01" {
  count                             = var.deploy_resource ? 1 : 0
  source                            = "../../modules/storage_account"
  name                              = lower(var.storage_account_app_01)
  location                          = local.resource_group_app_location
  resource_group_name               = local.resource_group_app_name
  account_tier                      = var.account_tier_storage_account_app_01
  account_replication_type          = var.account_replication_type_storage_account_app_01
  allow_nested_items_to_be_public   = var.allow_nested_items_to_be_public_storage_account_app_01
  
  log_analytics_workspace_id        = local.law_shared_app_id
  tags                              = local.merged_tags.storage_account_app_01_tags
  account_infra_encryption_enabled  = var.account_infra_encryption_enabled
  subnet_ids                        = local.storage_virtual_network_subnet_ids
  
  # Malware scanning with Event Grid integration
  function_app_name_app_01               = var.function_app_name_app_01
  enable_malware_scanning                = true
  malware_scan_cap_gb_per_month          = 5000
  enable_sensitive_data_discovery        = true
  malware_scan_exclude_blobs_with_prefix = local.malware_scan_exclude_prefixes_app_01
}
```

### Cognitive Services

Azure Cognitive Services for AI capabilities including Speech and Document Intelligence.

#### What is it?

Azure Cognitive Services are cloud-based AI services that provide pre-built APIs for adding AI capabilities to applications without requiring machine learning expertise. They enable natural language processing, computer vision, speech recognition, and more.

#### What is it used for?

- **Speech Services**: Converting speech to text and text to speech for accessibility features
- **Document Intelligence** (Form Recognizer): Extracting structured data from forms and documents
- Processing and analyzing unstructured content
- Providing AI-powered insights and automation

#### Usage Example

```hcl
# Document Intelligence Service (UAT-Lab configuration)
module "document_intelligence_account" {
  count = var.deploy_resource && var.document_intelligence_account_name != null ? 1 : 0
  
  source                        = "../../modules/cognitive_account"
  cognitive_account_name        = var.document_intelligence_account_name
  location                      = local.resource_group_app_location
  resource_group_name           = local.resource_group_app_name
  kind                          = "FormRecognizer"
  sku_name                      = var.document_intelligence_sku_name
  
  public_network_access_enabled = var.document_intelligence_public_network_access_enabled
  custom_subdomain_name         = var.document_intelligence_custom_subdomain_name
  
  log_analytics_workspace_id    = local.law_shared_app_id
  tags                          = local.merged_tags.document_intelligence_tags
}
```

### SignalR Service

Real-time communication service for websocket and server-sent events.

#### What is it?

Azure SignalR Service is a fully managed service that simplifies the process of adding real-time web functionality to applications. It handles the infrastructure complexity of WebSocket connections, allowing applications to push content updates to connected clients instantly.

#### What is it used for?

- Providing real-time notifications to web applications
- Broadcasting updates to multiple connected clients
- Enabling live chat and collaboration features
- Pushing data updates without client polling

#### Auto-scaling Configuration

SignalR auto-scaling is based on connection count and message rate:

**Auto-scaling Rules:**
- **Scale-Out**: Connection count > 70% OR Message rate > 70%
- **Scale-In**: Connection count < 20% AND Message rate < 20%
- **Capacity Range**: 1-10 units

#### Usage Example

```hcl
# SignalR Service with Auto-scaling (UAT-Lab configuration)
module "signalr_service" {
  source                     = "../../modules/signalr"
  signalr_name               = var.signalr_name
  location                   = local.resource_group_app_location
  resource_group_name        = local.resource_group_app_name
  sku                        = var.signalr_sku
  capacity                   = var.signalr_capacity
  service_mode               = var.signalr_service_mode
  
  enable_autoscale           = var.enable_autoscale_signalr
  
  log_analytics_workspace_id = local.law_shared_app_id
  tags                       = local.merged_tags.signalr_tags
}
```

### Container Registry

Azure Container Registry for storing and managing container images.

#### What is it?

Azure Container Registry (ACR) is a managed Docker registry service for storing and managing private container images and related artifacts. It provides geo-replication, security scanning, and automated build capabilities.

#### What is it used for?

- Storing Docker container images for Container Apps
- Managing container image versions and tags
- Providing secure image pulls with private endpoints
- Enabling CI/CD pipelines with automated builds

#### Usage Example

```hcl
# Azure Container Registry (UAT-Lab configuration)
module "container_registry" {
  count = var.acr_name != null ? 1 : 0

  source                        = "../../modules/container_registry"
  acr_name                      = var.acr_name
  resource_group_name           = local.resource_group_app_name
  location                      = local.resource_group_app_location
  sku                           = var.acr_sku
  admin_enabled                 = var.acr_admin_enabled
  tags                          = local.merged_tags.container_registry_tags
  log_analytics_workspace_id    = local.law_shared_app_id
  zone_redundancy_enabled       = var.acr_zone_redundancy_enabled
  public_network_access_enabled = var.container_registry_public_network_access_enabled
}
```

### Private Endpoints

Network isolation for Azure PaaS services using Azure Private Link.

#### What is it?

Azure Private Endpoint is a network interface that connects you privately and securely to Azure PaaS services using Azure Private Link. It uses a private IP address from your VNet, effectively bringing the service into your VNet.

#### What is it used for?

- Securing access to Azure services over private network connections
- Eliminating data exposure to the public internet
- Providing seamless connectivity from on-premises networks
- Meeting compliance requirements for network isolation

#### Supported Services

- **Storage Account**: blob, queue, table, file
- **App Service/Functions**: sites
- **Container Registry**: registry
- **Cognitive Services**: account
- **SignalR**: signalr

#### Usage Example

```hcl
# Private Endpoints for all services (UAT-Lab configuration)
module "app_private_endpoints" {
  source   = "../../modules/private_endpoint"
  for_each = local.private_endpoint_config
  
  name                = each.value.name
  location            = local.resource_group_app_location
  resource_group_name = local.resource_group_app_name
  subnet_id           = each.value.subnet_id
  
  private_service_connection = {
    name                           = "${each.value.name}-connection"
    private_connection_resource_id = each.value.resource_id
    subresource_names              = [each.value.subresource]
    is_manual_connection           = false
  }
  
  private_dns_zone_group = {
    name                 = "default"
    private_dns_zone_ids = [each.value.dns_zone_id]
  }
  
  tags = local.merged_tags.private_endpoint_tags
}
```

## Configuration

### Required Variables

| Variable | Type | Description |
|----------|------|-------------|
| `env` | string | Environment type (DEV, QA, UAT, PROD) |
| `resource_group_name_app` | string | Application resource group name |
| `deploy_resource` | bool | Master switch to deploy resources |

### App Service Plan Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `app_service_plan_name_app_01` | string | - | UI App Service Plan name |
| `app_service_plan_name_app_02` | string | - | API App Service Plan name |
| `app_service_plan_name_app_03` | string | - | Functions App Service Plan name |
| `sku_name_service_plan_app_02` | string | - | SKU name for API plan (e.g., P1v3, P2v3) |
| `enable_autoscale_app_02` | bool | false | Enable autoscaling for API plan |

### Storage Account Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `storage_account_app_01` | string | - | Primary storage account name |
| `storage_account_app_02` | string | - | Secondary storage account name |
| `account_tier_storage_account_app_01` | string | "Standard" | Storage tier |
| `account_replication_type_storage_account_app_01` | string | - | Replication type (LRS, ZRS, GRS) |

### Container App Variables

| Variable | Type | Default | Description |
|----------|------|---------|-------------|
| `container_app_name` | string | null | Container app name |
| `container_app_environment` | string | null | Container app environment name |
| `session_pool_enabled` | bool | false | Enable session pool |
| `session_pool_enable_default_roles` | bool | true | Auto-assign RBAC roles |
| `session_pool_max_concurrent_sessions` | number | 600 | Maximum concurrent sessions |
| `session_pool_ready_session_instances` | number | 5 | Target ready instances |

For a complete list of variables, refer to `variables.tf`.

## Outputs

The App Layer provides the following outputs for consumption by other layers or external systems:

### Session Pool Outputs

- `session_pool_id`: Resource ID of the Container App session pool
- `session_pool_name`: Name of the session pool
- `session_pool_management_endpoint`: Pool management endpoint (sensitive)
- `session_pool_location`: Deployment location
- `session_pool_max_concurrent_sessions`: Maximum concurrent sessions
- `session_pool_ready_instances`: Target ready instances
- `session_pool_container_type`: Container type (PythonLTS)
- `session_pool_network_status`: Network configuration status

### RBAC Outputs

- `session_pool_sessions_executor_roles`: Sessions Executor role assignments
- `session_pool_contributor_roles`: SessionPools Contributor role assignments
- `session_pool_custom_roles`: Custom role assignments (sensitive)
- `session_pool_role_summary`: Summary of all role assignments (sensitive)

### Debug Outputs

- `debug_app_service_managed_identity_principal_ids`: Principal IDs of app services (sensitive)
- `debug_app_service_managed_identities_for_session_pool`: Formatted identities for session pool (sensitive)
- `debug_session_pool_variables`: Complete session pool configuration (sensitive)

## Contributing

When contributing to this layer:

1. Follow the established module structure
2. Add appropriate variable validation
3. Update this README with examples
4. Test changes in DEV environment first

## Support

For issues or questions, contact the infrastructure team.

---

**Last Updated**: December 2024  
**Maintained by**: EYX Infrastructure Team  
**Terraform Version**: >= 1.0  
**Provider Versions**: azurerm >= 3.0, azapi >= 2.0
