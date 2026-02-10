# il-eyx-iac

## apply
`terraform init`
`terraform plan -var-file="environments/qa.tfvars"`
`terraform apply -var-file="environments/qa.tfvars"`

## destroy
`terraform destroy -var-file="environments/qa.tfvars" -target=module.vnet_app_01 -target=module.vnet_app_02`


# Terraform Deploy Workflow

This GitHub Actions workflow automates the deployment process using Terraform for this repository’s infrastructure-as-code. It is designed to be called by other workflows and supports multiple environments and layers.

## Workflow File Location

```
.github/workflows/terraform-deploy.yml
```

## Workflow Name

**terraform deploy**

## Usage

This workflow is triggered by the `workflow_call` event, meaning it is intended to be invoked by other workflows via `workflow_call`.

### Example of Calling This Workflow

```yaml
jobs:
  call-terraform-deploy:
    uses: ey-org/il-eyx-iac/.github/workflows/terraform-deploy.yml@develop
    with:
      environment: "dev"
      layer: "network"
      runs_on: "ubuntu-latest"
```

## Inputs

| Name         | Type    | Required | Default        | Description                                        |
|--------------|---------|----------|----------------|----------------------------------------------------|
| environment  | string  | Yes      | N/A            | The target environment for deployment (e.g., dev, qa, prod). |
| layer        | string  | Yes      | N/A            | The Terraform layer to deploy (e.g., network, app). |
| plan         | boolean | No       | false          | Whether to run only `terraform plan` or also `apply`. |
| runs_on      | string  | No       | ubuntu-latest  | The runner type for executing the job.              |

## Secrets & Variables Required

- `AZURE_CREDENTIALS` (secret): Azure credentials in JSON format for authentication.
- `AZURE_SUBSCRIPTION_ID` (secret): Azure subscription ID.
- `RESOURCE_GROUP_NAME` (variable): Resource group name.
- `STORAGE_ACCOUNT_NAME` (variable): Storage account name.
- `TF_STATE_PATH` (variable): Path to Terraform state file.
- `env_tfvars` (variable): Environment-specific Terraform variables filename.

## Workflow Steps

1. **Checkout Repository**
   - Uses `actions/checkout@v4` to fetch the code.

2. **Login to Azure**
   - Authenticates with Azure using the provided credentials (`azure/login@v2`).

3. **Setup Terraform**
   - Configures Terraform CLI using `hashicorp/setup-terraform@v3`.

4. **Replace Placeholders in provider.tf**
   - Replaces placeholders in `provider.tf` for subscription ID, resource group, storage account, and state path using environment variables and secrets.

5. **Terraform Plan**
   - Initializes Terraform and runs `terraform plan` with the specified variable file.

6. **Terraform Apply**
   - If the branch is `develop`, `main`, `qa`, or a `release/*` branch, runs `terraform apply` with the specified variable file.

## Branch Conditions for Apply

Terraform `apply` will only run on the following branches:
- `develop`
- `main`
- `qa`
- any branch starting with `release/`

## Notes

- Make sure all required secrets and variables are configured in the repository or calling workflow.
- This workflow should be called from other workflows, not triggered directly.

---
