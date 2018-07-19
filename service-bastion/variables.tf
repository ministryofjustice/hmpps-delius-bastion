variable "region" {
  description = "The AWS region."
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_identifier" {
  description = "resource label or name"
}

variable "short_environment_identifier" {
  description = "short resource label or name"
}

variable "tags" {
  type = "map"
}

variable "availability_zone" {
  type = "map"
}

variable "app_name" {}

variable "bastion_domain_zone" {}

variable "environment" {}
