variable "project" {
  type        = string
  default     = ""
  description = "AWS project name"
}

variable "env" {
  type        = string
  default     = ""
  description = "Environment - dev | prod"
}

variable "tags" {
  type = map
  default = {
    Creation = "Terraform"
  }
  description = "Map of tags"
}