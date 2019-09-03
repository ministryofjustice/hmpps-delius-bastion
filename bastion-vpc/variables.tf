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

variable "bastion_cidr_block" {
  description = "The CIDR of the VPC."
}

variable "bastion_public_cidr" {
  type = "map"
}

variable "bastion_private_cidr" {
  type = "map"
}

variable "bastion_domain_zone" {}

variable "cloudwatch_log_retention" {}

variable "bastion_peering_ids" {
  type = "list"
}
