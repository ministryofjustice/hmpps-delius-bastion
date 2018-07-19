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

#-------------------------------------------------------------
### Getting the current running account id
#-------------------------------------------------------------
data "aws_caller_identity" "current" {}

############################################
# CREATE VPC AND ITS FLOW LOGS
############################################
#-------------------------------------------
### Creating the VPC
#--------------------------------------------

module "bastion_vpc" {
  source                 = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//vpc"
  vpc_name               = "${var.environment_identifier}"
  vpc_dns_hosts          = "AmazonProvidedDNS"
  cidr_block             = "${var.bastion_cidr_block}"
  route53_domain_private = "${var.bastion_domain_zone}"
  tags                   = "${var.tags}"
}

#######################################
# SECURITY GROUPS
#######################################
resource "aws_security_group" "bastion-vpc-sg" {
  name        = "${var.environment_identifier}-bastion-vpc-sg"
  description = "security group for ${var.environment_identifier}-vpc"
  vpc_id      = "${module.bastion_vpc.vpc_id}"

  ingress {
    from_port = "22"
    to_port   = "22"
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

    description = "${var.environment_identifier}-bastion-vpc"
  }

  ingress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["${module.bastion_vpc.vpc_cidr}"]
    description = "${var.environment_identifier}-bastion-vpc"
  }

  tags = "${merge(var.tags, map("Name", "${var.environment_identifier}-bastion-vpc-sg"))}"
}

resource "aws_security_group" "bastion-vpc-sg-outbound" {
  name        = "${var.environment_identifier}-bastion-vpc-sg-outbound"
  description = "security group for ${var.environment_identifier}-vpc"
  vpc_id      = "${module.bastion_vpc.vpc_id}"

  egress {
    from_port   = "443"
    to_port     = "443"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "${var.environment_identifier}-bastion-vpc"
  }

  egress {
    from_port   = "80"
    to_port     = "80"
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    description = "${var.environment_identifier}-bastion-vpc"
  }

  tags = "${merge(var.tags, map("Name", "${var.environment_identifier}-bastion-vpc-outbound"))}"
}

############################################
# PUBLIC SUBNET
############################################

module "bastion-public-az1" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//subnets"
  subnet_cidr_block       = "${var.bastion_public_cidr["az1"]}"
  availability_zone       = "${var.availability_zone["az1"]}"
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-publicaz1"
  vpc_id                  = "${module.bastion_vpc.vpc_id}"
  tags                    = "${var.tags}"
}

module "bastion-public-az2" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//subnets"
  subnet_cidr_block       = "${var.bastion_public_cidr["az2"]}"
  availability_zone       = "${var.availability_zone["az2"]}"
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-publicaz2"
  vpc_id                  = "${module.bastion_vpc.vpc_id}"
  tags                    = "${var.tags}"
}

module "bastion-public-az3" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//subnets"
  subnet_cidr_block       = "${var.bastion_public_cidr["az3"]}"
  availability_zone       = "${var.availability_zone["az3"]}"
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-publicaz3"
  vpc_id                  = "${module.bastion_vpc.vpc_id}"
  tags                    = "${var.tags}"
}


##########################
#  VPC FLOW LOGS
##########################

module "bastion_vpcflowlog_iam_role" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//role"
  rolename   = "${var.environment_identifier}-vpcflowlog"
  policyfile = "vpcflowlog_assume_role.json"
}

module "bastion_vpcflowlog_iam_role_policy" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//iam//rolepolicy"
  policyfile = "${file("policies/vpcflowlog_role_policy.json")}"
  rolename   = "${module.bastion_vpcflowlog_iam_role.iamrole_id}"
}

module "bastion_vpcflowlog" {
  source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//flowlog"
  vpc_id                   = "${module.bastion_vpc.vpc_id}"
  role_arn                 = "${module.bastion_vpcflowlog_iam_role.iamrole_arn}"
  cloudwatch_loggroup_name = "${module.bastion_vpcflowlog_cloudwatch_loggroup.loggroup_name}"
}

#########################
# CLOUDWATCH GROUP
#########################

module "bastion_vpcflowlog_cloudwatch_loggroup" {
  source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//cloudwatch//loggroup"
  log_group_path           = "${var.environment_identifier}"
  loggroupname             = "vpc_flow_logs"
  cloudwatch_log_retention = "${var.cloudwatch_log_retention}"
  tags                     = "${var.tags}"
}

############################################
# S3 Buckets
############################################

#-------------------------------------------
### S3 bucket for config generator
#--------------------------------------------
module "bastion_s3config_bucket" {
  source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//s3bucket//s3bucket_without_policy"
  s3_bucket_name = "${var.environment_identifier}-config"
  tags           = "${var.tags}"
}

############################################
# KMS KEY GENERATION - FOR ENCRYPTION
############################################

module "bastion_kms_key" {
  source       = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//kms"
  kms_key_name = "${var.environment_identifier}"
  tags         = "${var.tags}"
}

#Internet gateway

module "bastion_igw" {
  source       = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules/internetgateway"
  gateway_name = "${var.environment_identifier}"
  vpc_id       = "${module.bastion_vpc.vpc_id}"
  tags         = "${var.tags}"
}

#Routes

module "route-to-internet" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git?ref=master//modules//routes//internetgateway"

  route_table_id = [
    "${module.bastion-public-az1.routetableid}",
    "${module.bastion-public-az2.routetableid}",
    "${module.bastion-public-az3.routetableid}",
  ]

  destination_cidr_block = [
    "0.0.0.0/0",
    "0.0.0.0/0",
    "0.0.0.0/0",
  ]

  gateway_id = "${module.bastion_igw.igw_id}"
}

