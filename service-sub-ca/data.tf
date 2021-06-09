#-------------------------------------------------------------
### Getting aws_caller_identity
#-------------------------------------------------------------
data "aws_caller_identity" "current" {
}

data "aws_partition" "current" {}

#-------------------------------------------------------------
### Getting the bastion vpc
#-------------------------------------------------------------
data "terraform_remote_state" "vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "bastion-vpc/terraform.tfstate"
    region = var.region
  }
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
### Getting the root ca
#-------------------------------------------------------------
data "terraform_remote_state" "rootca" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "service-ca/terraform.tfstate"
    region = var.region
  }
}
