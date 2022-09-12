terraform {
  source = "${path_relative_from_include()}/../terraform/modules/s3//."
}

include {
  path = find_in_parent_folders()
}

locals {
  env_vars = read_terragrunt_config(find_in_parent_folders("env.hcl"))
  environment = local.env_vars.locals.environment

  region_vars = read_terragrunt_config(find_in_parent_folders("region.hcl"))
  location = local.region_vars.locals.location
}

inputs = {
  project = "aws-samples"
  env     = local.environment

  tags = {
    environment = local.environment
  }
}