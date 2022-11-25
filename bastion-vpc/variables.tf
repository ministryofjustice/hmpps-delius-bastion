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

variable "environment_name" {
}

variable "tags" {
  type = map(string)
}

variable "availability_zone" {
  type = map(string)
}

variable "bastion_cidr_block" {
  description = "The CIDR of the VPC."
}

variable "bastion_public_cidr" {
  type = map(string)
}

variable "bastion_private_cidr" {
  type = map(string)
}

variable "bastion_domain_zone" {
}

variable "bastion_domain_name" {
}

variable "cloudwatch_log_retention" {
}

variable "bastion_peering_ids" {
  type = list(string)
}

variable "eng_dev_vpc_cidr" {
  description = "CIDR range of eng_dev VPC hosting jenkins, jira etc. This used to allow jenkins instances to reach dev and prod bastion"
}