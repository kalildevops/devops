locals {
  # Automatically load region-level variables
  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))

  # Automatically load environment-level variables
  environment_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))

  region            = local.region_vars.locals.region
  environment       = local.environment_vars.locals.environment
}

# Generate Azure providers
generate "versions" {
  path      = "versions_override.tf"
  if_exists = "overwrite_terragrunt"
  contents  = <<EOF
    terraform {
      required_version = "~> 1.2.7"
      required_providers {
        aws = {
          source = "hashicorp/aws"
          version = "4.25"
        }
      }
    }

    provider "aws" {
        region = "${local.region}"
    }
EOF
}

remote_state {
    backend = "s3"
    config = {
        bucket = "tfstate-devops"
        key = "aws/${path_relative_to_include()}/${local.environment}-terraform.tfstate"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}

# Configure root level variables that all resources can inherit. This is especially helpful with multi-subscription configs
# where terraform_remote_state data sources are placed directly into the modules.
inputs = merge(
  local.region_vars.locals,
  local.environment_vars.locals
)
