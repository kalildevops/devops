terraform {
  source = "${path_relative_from_include()}/../terraform/modules/static-website//."
}

include {
  path = find_in_parent_folders()
}

inputs = {
  project                       = "azure-samples-kalil"
  resource_group_name           = "kalil_resource_group"
}