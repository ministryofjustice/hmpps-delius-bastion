#-------------------------------------------------------------
### Getting aws_caller_identity
#-------------------------------------------------------------
data "aws_caller_identity" "current" {
}

data "aws_partition" "current" {}

#-------------------------------------------------------------
### SSM Admin password
#-------------------------------------------------------------
data "aws_ssm_parameter" "admin_password" {
  name = var.active_directory_configs["ssm_admin_password"]
}

#-------------------------------------------------------------
### Getting the vpn vpc
#-------------------------------------------------------------
data "terraform_remote_state" "vpn_vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "vpn-vpc/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the latest amazon ami
#-------------------------------------------------------------

data "aws_ami" "ami" {
  most_recent = true

  filter {
    name   = "name"
    values = ["HMPPS Windows Server Base 2019 Ansible master*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = [local.account_id, "895523100917"] # MOJ
}
