terraform {
  # The configuration for this backend will be filled in by Terragrunt
  backend "s3" {}
}

provider "aws" {
  region  = "${var.region}"
  version = "~> 1.16"
}

#-------------------------------------------------------------
### Getting the current vpc
#-------------------------------------------------------------
data "terraform_remote_state" "bastion_vpc" {
  backend = "s3"

  config {
    bucket = "${var.remote_state_bucket_name}"
    key    = "bastion-vpc/terraform.tfstate"
    region = "${var.region}"
  }
}

resource "aws_launch_configuration" "launch_cfg" {
  name          = "bastion"
  image_id      = "${var.ami_id}"
  instance_type = "t2.micro"
}

############################################
# CREATE AUTO SCALING GROUP
############################################

module "auto_scale" {
  source   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//autoscaling//group//default"
  asg_name = "${var.environment_identifier}-${var.app_name}"

  subnet_ids = ["${element(data.terraform_remote_state.bastion_vpc.bastion-public-subnet-az1,0)}",
    "${element(data.terraform_remote_state.bastion_vpc.bastion-public-subnet-az2,0)}",
    "${element(data.terraform_remote_state.bastion_vpc.bastion-public-subnet-az3,0)}",
  ]

  asg_min              = "1"
  asg_max              = "1"
  asg_desired          = "1"
  launch_configuration = "${aws_launch_configuration.launch_cfg.name}"
  tags                 = "${var.tags}"
}

