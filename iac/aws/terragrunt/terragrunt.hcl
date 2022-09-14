locals {
  dirs       = split("/", path_relative_to_include())
  env        = lower(local.dirs[1]) # dir structure <repo>/<aws_account>/<env>/<region>/<module_name>/
  region     = lower(local.dirs[2]) # dir structure <repo>/<aws_account>/<env>/<region>/<module_name>/
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
        key = "aws/${path_relative_to_include()}/${local.env}-terraform.tfstate"
    }
    generate = {
        path      = "backend.tf"
        if_exists = "overwrite_terragrunt"
    }
}

inputs = {
  env    = local.env,
  region = local.region

  tags = {
    env = local.env
  }
}