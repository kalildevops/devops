variable "project" {
  type        = string
  default     = ""
  description = "Azure project name"
}

variable "env" {
  type        = string
  default     = ""
  description = "Environment - dev or prod"
}

variable "resource_group_name" {
  type        = string
  default     = ""
  description = "Resource Group Name"
}

variable "location" {
  type        = string
  default     = ""
  description = "Azure location"
}