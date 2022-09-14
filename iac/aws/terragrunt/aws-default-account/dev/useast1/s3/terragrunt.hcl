terraform {
  source = "${path_relative_from_include()}/../terraform/modules/s3//."
}

include {
  path = find_in_parent_folders()
}

inputs = {
  project = "aws-samples"
}