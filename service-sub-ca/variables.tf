variable "tags" {
  type    = map(string)
  default = {}
}

variable "region" {
}

variable "environment" {
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "short_environment_identifier" {
}

