name: terraform deploy

on:
  workflow_call:
    inputs:
      environment:
        type: string
        required: true
      layer:
        type: string
        required: true
      env_tfvars_folder:
        type: string
        required: false
      runs_on:
        type: string
        required: false

jobs:
  build:
    runs-on: ${{ inputs.runs_on && fromJson(inputs.runs_on) || 'ubuntu-latest' }}
    environment: ${{ inputs.environment }}

    steps:
      # Step 1: Checkout the repository
      - name: Checkout Repository
        uses: actions/checkout@v4

      # Step 2: Login to Azure
      # - name: 'Login to Azure'
      #   uses: azure/login@v2
      #   with:
      #     tenant-id: ${{ secrets.AZURE_TENANT_ID }}
      #     client-id: ${{ secrets.AZURE_CLIENT_ID }}
      #     subscription-id: ${{ secrets.AZURE_SUBSCRIPTION_ID }}
      - name: 'Login to Azure'
        uses: azure/login@v2
        with:
          creds: ${{ secrets.AZURE_CREDENTIALS }}
      
      # Step 3: Set up terrform
      - name: Setup terraform
        uses: hashicorp/setup-terraform@v3
        with:
          terraform_wrapper: false

      # Step 4: replace vars
      - name: Replace placeholders in provider.tf
        run: |
          cd ./terraform/layers/${{ inputs.layer }}
          sed -i 's|${SUBSCRIPTION_ID}|${{ secrets.AZURE_SUBSCRIPTION_ID }}|g' provider.tf
          sed -i 's|${RESOURCE_GROUP_NAME}|${{ vars.RESOURCE_GROUP_NAME }}|g' provider.tf
          sed -i 's|${STORAGE_ACCOUNT_NAME}|${{ vars.STORAGE_ACCOUNT_NAME }}|g' provider.tf
          sed -i 's|${TF_STATE_PATH}|${{ vars.TF_STATE_PATH }}|g' provider.tf
          sed -i 's|${TENANT_ID}|${{ secrets.AZURE_TENANT_ID }}|g' provider.tf
          
          if [[ "${{ inputs.environment }}" == "dev1" || "${{ inputs.environment }}" == "dev2" || "${{ inputs.environment }}" == "dev3" ]]; then
            sed -i 's|\${BACKEND_SUBSCRIPTION_ID}|${{ secrets.BACKEND_SUBSCRIPTION_ID }}|g' provider.tf
          else
            sed -i 's|\${BACKEND_SUBSCRIPTION_ID}|${{ secrets.AZURE_SUBSCRIPTION_ID }}|g' provider.tf
          fi

      # Step 5: Terraform plan
      - name: Terraform plan
        run: |
          cd ./terraform/layers/${{ inputs.layer }}
          terraform init
          terraform plan -var-file="environments/${{ inputs.env_tfvars_folder }}/${{ vars.env_tfvars }}.tfvars"

      - id: approval
        uses: ekeel/approval-action@v1.0.3
        if: (github.event.ref == 'refs/heads/develop' || startsWith(github.event.ref, 'refs/heads/release_QA') || startsWith(github.event.ref, 'refs/heads/release_UAT') || github.event.ref == 'refs/heads/main' || github.event_name == 'workflow_dispatch') && github.event_name != 'pull_request'
        with:
          # A GitHub token with repo scope.
          # The default secrets.GITHUB_TOKEN does not work with octokit to open/update/close issues.
          token: ${{ secrets.PAT_TOKEN_GH }}
          # A comma separated list of GitHub usernames that are allowed to approve.
          # Example: 'ekeel,octocat'
          approvers: 'XE064259743_EYGS,US016020768_EYGS,US015802021_EYGS,20230108971_EYGS'
          # The number of approvals/rejections required to continue the workflow.
          minimumApprovals: '1'
          # The title of the issue to create.
          issueTitle: 'Deploy Infra ${{ inputs.layer }} in ${{ inputs.environment }}'
          # The body of the issue to create.
          issueBody: 'Execute terraform apply ${{ inputs.layer }} in ${{ inputs.environment }}'
          # A comma separated list of labels to add to the issue.
          issueLabels: 'ManualApproval,ApprovalAction'
          # Exclude the workflow initiator from the list of approvers.
          excludeInitiator: 'false'
          # A comma separated list of words that will be used to approve.
          approveWords: 'approve, approved'
          # A comma separated list of words that will be used to reject.
          rejectWords: 'deny, denied, reject, rejected'
          # The number of minutes to wait between checks for approvals.
          waitInterval: '1'
          # The number of minutes to wait before timing out.
          waitTimeout: '60'

      # Step 6: Terraform apply
      - name: Terraform apply
        if: (github.event.ref == 'refs/heads/develop' || startsWith(github.event.ref, 'refs/heads/release_QA') || startsWith(github.event.ref, 'refs/heads/release_UAT') || github.event.ref == 'refs/heads/main' || github.event_name == 'workflow_dispatch') && github.event_name != 'pull_request' && steps.approval.outputs.approved == 'true'
        run: |
          cd ./terraform/layers/${{ inputs.layer }}
          terraform apply -var-file="environments/${{ inputs.env_tfvars_folder }}/${{ vars.env_tfvars }}.tfvars" -auto-approve

