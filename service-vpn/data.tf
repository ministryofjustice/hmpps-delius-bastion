#-------------------------------------------------------------
### Getting aws_caller_identity
#-------------------------------------------------------------
data "aws_caller_identity" "current" {
}

data "aws_partition" "current" {}

#-------------------------------------------------------------
## Getting the ssm parameters
#-------------------------------------------------------------

data "aws_ssm_parameter" "tls_ca_key" {
  name = "${local.ssm_prefix}/ca/key"
}

data "aws_ssm_parameter" "tls_ca_cert" {
  name = "${local.ssm_prefix}/ca/cert"
}

data "aws_ssm_parameter" "server_tls_cert" {
  name = "${local.ssm_prefix}/server/cert"
}

data "aws_ssm_parameter" "server_tls_key" {
  name = "${local.ssm_prefix}/server/key"
}

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
### Getting the sub ca
#-------------------------------------------------------------
data "terraform_remote_state" "subca" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "service-sub-ca/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting the sub ca
#-------------------------------------------------------------
data "terraform_remote_state" "directory" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "service-active-directory/terraform.tfstate"
    region = var.region
  }
}
