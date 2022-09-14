terraform {
  source = "${path_relative_from_include()}/../terraform/modules/storage-container//."
}

include {
  path = find_in_parent_folders()
}

inputs = {
  project                       = "azure-samples"
  resource_group_name           = "kalil_resource_group"
}