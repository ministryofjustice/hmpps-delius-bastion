#-------------------------------------------------------------
### Getting the current running account id
#-------------------------------------------------------------
data "aws_caller_identity" "current" {
}

############################################
# CREATE VPC AND ITS FLOW LOGS
############################################
#-------------------------------------------
### Creating the VPC
#--------------------------------------------

module "bastion_vpc" {
  source                 = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//vpc?ref=terraform-0.12"
  vpc_name               = var.environment_identifier
  vpc_dns_hosts          = "AmazonProvidedDNS"
  cidr_block             = var.bastion_cidr_block
  route53_domain_private = var.bastion_domain_zone
  tags                   = var.tags
}

############################################
# PUBLIC SUBNET
############################################

module "bastion-public-az1" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = var.bastion_public_cidr["az1"]
  availability_zone       = var.availability_zone["az1"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-publicaz1"
  vpc_id                  = module.bastion_vpc.vpc_id
  tags                    = var.tags
}

module "bastion-public-az2" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = var.bastion_public_cidr["az2"]
  availability_zone       = var.availability_zone["az2"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-publicaz2"
  vpc_id                  = module.bastion_vpc.vpc_id
  tags                    = var.tags
}

module "bastion-public-az3" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = var.bastion_public_cidr["az3"]
  availability_zone       = var.availability_zone["az3"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-publicaz3"
  vpc_id                  = module.bastion_vpc.vpc_id
  tags                    = var.tags
}

############################################
# PRIVATE SUBNET
############################################

module "bastion-private-az1" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = var.bastion_private_cidr["az1"]
  availability_zone       = var.availability_zone["az1"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-private-az1"
  vpc_id                  = module.bastion_vpc.vpc_id
  tags                    = var.tags
}

module "bastion-private-az2" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = var.bastion_private_cidr["az2"]
  availability_zone       = var.availability_zone["az2"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-private-az2"
  vpc_id                  = module.bastion_vpc.vpc_id
  tags                    = var.tags
}

module "bastion-private-az3" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = var.bastion_private_cidr["az3"]
  availability_zone       = var.availability_zone["az3"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-private-az3"
  vpc_id                  = module.bastion_vpc.vpc_id
  tags                    = var.tags
}

##########################
#  VPC FLOW LOGS
##########################

module "bastion_vpcflowlog_iam_role" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//iam//role?ref=terraform-0.12"
  rolename   = "${var.environment_identifier}-vpcflowlog"
  policyfile = "vpcflowlog_assume_role.json"
}

module "bastion_vpcflowlog_iam_role_policy" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//iam//rolepolicy?ref=terraform-0.12"
  policyfile = file("policies/vpcflowlog_role_policy.json")
  rolename   = module.bastion_vpcflowlog_iam_role.iamrole_id
}

module "bastion_vpcflowlog" {
  source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//flowlog?ref=terraform-0.12"
  vpc_id                   = module.bastion_vpc.vpc_id
  role_arn                 = module.bastion_vpcflowlog_iam_role.iamrole_arn
  cloudwatch_loggroup_name = module.bastion_vpcflowlog_cloudwatch_loggroup.loggroup_arn
}

#########################
# CLOUDWATCH GROUP
#########################

module "bastion_vpcflowlog_cloudwatch_loggroup" {
  source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//cloudwatch//loggroup?ref=terraform-0.12"
  log_group_path           = var.environment_identifier
  loggroupname             = "vpc_flow_logs"
  cloudwatch_log_retention = var.cloudwatch_log_retention
  tags                     = var.tags
}

############################################
# S3 Buckets
############################################

#-------------------------------------------
### S3 bucket for config generator
#--------------------------------------------
module "bastion_s3config_bucket" {
  source         = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//s3bucket//s3bucket_without_policy?ref=terraform-0.12"
  s3_bucket_name = "${var.environment_identifier}-config"
  tags           = var.tags
}

############################################
# KMS KEY GENERATION - FOR ENCRYPTION
############################################

module "bastion_kms_key" {
  source       = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//kms?ref=terraform-0.12"
  kms_key_name = var.environment_identifier
  tags         = var.tags
}

#Internet gateway

module "bastion_igw" {
  source       = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/internetgateway?ref=terraform-0.12"
  gateway_name = var.environment_identifier
  vpc_id       = module.bastion_vpc.vpc_id
  tags         = var.tags
}

#Routes

module "route-to-internet" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//routes//internetgateway?ref=terraform-0.12"

  route_table_id = [
    module.bastion-public-az1.routetableid,
    module.bastion-public-az2.routetableid,
    module.bastion-public-az3.routetableid,
  ]

  destination_cidr_block = [
    "0.0.0.0/0",
    "0.0.0.0/0",
    "0.0.0.0/0",
  ]

  gateway_id = module.bastion_igw.igw_id
}

## NATGATEWAY
module "common-nat-az1" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//natgateway?ref=terraform-0.12"
  az     = "${var.environment_identifier}-az1"
  subnet = module.bastion-public-az1.subnetid
  tags   = var.tags
}

module "common-nat-az2" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/natgateway?ref=terraform-0.12"
  az     = "${var.environment_identifier}-az2"
  subnet = module.bastion-public-az2.subnetid
  tags   = var.tags
}

module "common-nat-az3" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/natgateway?ref=terraform-0.12"
  az     = "${var.environment_identifier}-az3"
  subnet = module.bastion-public-az3.subnetid
  tags   = var.tags
}

## PTTP TGW attachment and routing
locals {
  pttp_tgw_id = "tgw-026162f1ba39ce704"
}

resource "aws_ec2_transit_gateway_vpc_attachment" "pttp" {
  transit_gateway_id = local.pttp_tgw_id
  vpc_id             = module.bastion_vpc.vpc_id
  subnet_ids         = [
    module.bastion-private-az1.subnetid,
    module.bastion-private-az2.subnetid,
    module.bastion-private-az3.subnetid
  ]

  dns_support  = "enable"
  ipv6_support = "disable"

  transit_gateway_default_route_table_association = "true"
  transit_gateway_default_route_table_propagation = "true"

  tags = var.tags
}
