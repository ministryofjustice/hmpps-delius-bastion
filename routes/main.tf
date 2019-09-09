terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
}

####################################################
# DATA SOURCE MODULES FROM OTHER TERRAFORM BACKENDS
####################################################
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "bastion-vpc/terraform.tfstate"
    region = "${var.region}"
  }
}

# ## ROUTES to NATGATEWAY

module "route-private-to-nat" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//routes//natgateway"

  route_table_id = [
    "${data.terraform_remote_state.vpc.private-routetable-az1}",
    "${data.terraform_remote_state.vpc.private-routetable-az2}",
    "${data.terraform_remote_state.vpc.private-routetable-az3}"
  ]

  destination_cidr_block = [
    "0.0.0.0/0",
    "0.0.0.0/0",
    "0.0.0.0/0",
  ]

  nat_gateway_id = [
    "${data.terraform_remote_state.vpc.natgateway.az1}",
    "${data.terraform_remote_state.vpc.natgateway.az2}",
    "${data.terraform_remote_state.vpc.natgateway.az3}"
  ]
}
