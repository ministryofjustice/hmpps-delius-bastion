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

#Provisioning SSH key

module "vpn_ssh_key" {
  source   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//ssh_key"
  keyname  = "${var.environment_identifier}-vpn"
  rsa_bits = "4096"
}


#
# Get the latest Amazon Linux ami
#
data "aws_ami" "hmpps" {
  most_recent = true

  filter {
    name   = "name"
    values = ["HMPPS Base CentOS master*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["895523100917"]
}

# userdata
data "template_file" "userdata_vpn" {
  template = "${file("${path.module}/userdata/bootstrap.sh")}"

  vars = {
    network_cidr_block = "${var.bastion_cidr_block}"
    region             = "${var.region}"
    vpn_cidr_block     = "${var.vpn_cidr_block}"
  }
}

resource "aws_instance" "vpn_instance" {
  ami           = "${data.aws_ami.hmpps.id}"
  instance_type = "t2.micro"
  key_name      = "${module.vpn_ssh_key.deployer_key}"
  subnet_id     = "${data.terraform_remote_state.bastion_vpc.bastion-public-subnet-az1}"
  user_data     = "${data.template_file.userdata_vpn.rendered}"

  vpc_security_group_ids = ["${aws_security_group.vpn-sg.id}"]

  tags = "${merge(var.tags, map("Name", "${var.environment_name}-vpn"))}"

  lifecycle {
    ignore_changes = ["ami"]
  }

}

resource "aws_eip" "vpn_eip" {
  instance = "${aws_instance.vpn_instance.id}"
  vpc      = true
  tags     = "${merge(var.tags, map("Name", "${var.environment_name}-vpn"))}"
}
