# Azure Infrastructure samples

## Prerequisites
- Azure account
- A Resource Group to create azure resources. For the samples, we are using:
  - kalil_resource_group
- Storage account and storage Container to store tfstate file (Terraform metadata). For the samples, we are using:
  - tfstate2022000000001dev (Storage Account)
  - tfstate (Storage Container)
- A Azure Subscription ID. Get yours and update the file [subscription.hcl](./terragrunt/subscription-sample/subscription.hcl)
- [Install Terraform](https://learn.hashicorp.com/tutorials/terraform/install-cli)
- [Install Terragrunt](https://terragrunt.gruntwork.io/docs/getting-started/quick-start/)

## Terraform Modules

### [storage-container](./terraform/modules/storage-container/README.md)

## How to authenticate
```
az login
az account set --subscription "<subscription_id>"
az ad sp create-for-rbac --role="Contributor" --scopes="/subscriptions/<subscription_id>"
```
Get the output from the last command above and set variables:

```
export ARM_CLIENT_ID="<appId>"
export ARM_CLIENT_SECRET="<password>"
export ARM_SUBSCRIPTION_ID="<subscriptionID>"
export ARM_TENANT_ID="<tenant>"
```
## Update Infrastructure - Terragrunt commands
```
cd iac/azure/terragrunt/subscription-sample/<environment>/<region>/
terragrunt plan --terragrunt-working-dir storage-container
terragrunt apply -auto-approve --terragrunt-working-dir storage-container
```
