variable "region" {
  description = "The AWS region."
}

variable "project" {
  description = "The name of our org, i.e. terraform-environment_identifier"
}

variable "environment" {
  description = "The name of our environment, i.e. development."
}

variable "business_unit" {
  description = "The name of our business unit, i.e. development."
}

variable "role_arn" {
  description = "arn to use for terraform"
}

variable "environment_identifier" {
  description = "resource label or name"
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "tags" {
  description = "Standard tags map"
  type        = map(string)
}

