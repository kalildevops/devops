locals {
  # Automatically load subscription variables
  subscription_vars = read_terragrunt_config(find_in_parent_folders("subscription.hcl"))
  subscription_id   = local.subscription_vars.locals.subscription_id

  dirs       = split("/", path_relative_to_include())
  env        = lower(local.dirs[1]) # dir structure <repo>/<subscription>/<env>/<location>/<module_name>/
  location   = lower(local.dirs[2]) # dir structure <repo>/<subscription>/<env>/<location>/<module_name>/
}

# Generate Azure providers
generate "versions" {
  path      = "versions_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_version = "~> 1.2.7"
      required_providers {
        azurerm = {
          source = "hashicorp/azurerm"
          version = "3.21.1"
        }
      }
    }

    provider "azurerm" {
        features {}
        subscription_id = "${local.subscription_id}"
    }
EOF
}

remote_state {
    backend = "azurerm"
    config = {
        subscription_id = "${local.subscription_id}"
        key = "${path_relative_to_include()}/${local.env}-terraform.tfstate"
        resource_group_name = "kalil_resource_group"
        storage_account_name = "tfstate2022000000001${local.env}"
        container_name = "tfstate"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}

inputs = {
  subscription_id = local.subscription_vars.locals,
  env             = local.env,
  location        = local.location

  tags = {
    env = local.env
  }
}
