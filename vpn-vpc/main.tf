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

module "vpn_vpc" {
  source                 = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//vpc?ref=terraform-0.12"
  vpc_name               = var.environment_identifier
  vpc_dns_hosts          = "AmazonProvidedDNS"
  cidr_block             = var.vpn_cidr_block
  route53_domain_private = ""
  tags                   = var.tags
}



############################################
# PUBLIC SUBNET
############################################

module "vpn-public-az1" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = cidrsubnet(var.vpn_cidr_block, 7, 1)
  availability_zone       = var.availability_zone["az1"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-vpn-publicaz1"
  vpc_id                  = module.vpn_vpc.vpc_id
  tags                    = var.tags
}

module "vpn-public-az2" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = cidrsubnet(var.vpn_cidr_block, 7, 2)
  availability_zone       = var.availability_zone["az2"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-vpn-publicaz2"
  vpc_id                  = module.vpn_vpc.vpc_id
  tags                    = var.tags
}

module "vpn-public-az3" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = cidrsubnet(var.vpn_cidr_block, 7, 3)
  availability_zone       = var.availability_zone["az3"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-vpn-publicaz3"
  vpc_id                  = module.vpn_vpc.vpc_id
  tags                    = var.tags
}

############################################
# PRIVATE SUBNET
############################################

module "vpn-private-az1" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = cidrsubnet(var.vpn_cidr_block, 5, 6)
  availability_zone       = var.availability_zone["az1"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-vpn-private-az1"
  vpc_id                  = module.vpn_vpc.vpc_id
  tags                    = var.tags
}

module "vpn-private-az2" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = cidrsubnet(var.vpn_cidr_block, 5, 7)
  availability_zone       = var.availability_zone["az2"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-vpn-private-az2"
  vpc_id                  = module.vpn_vpc.vpc_id
  tags                    = var.tags
}

module "vpn-private-az3" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = cidrsubnet(var.vpn_cidr_block, 5, 8)
  availability_zone       = var.availability_zone["az3"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-vpn-private-az3"
  vpc_id                  = module.vpn_vpc.vpc_id
  tags                    = var.tags
}

############################################
# PUBLIC SUBNET
############################################

module "vpn-db-az1" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = cidrsubnet(var.vpn_cidr_block, 7, 4)
  availability_zone       = var.availability_zone["az1"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-vpn-dbaz1"
  vpc_id                  = module.vpn_vpc.vpc_id
  tags                    = var.tags
}

module "vpn-db-az2" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = cidrsubnet(var.vpn_cidr_block, 7, 5)
  availability_zone       = var.availability_zone["az2"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-vpn-dbaz2"
  vpc_id                  = module.vpn_vpc.vpc_id
  tags                    = var.tags
}

module "vpn-db-az3" {
  source                  = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//subnets?ref=terraform-0.12"
  subnet_cidr_block       = cidrsubnet(var.vpn_cidr_block, 7, 6)
  availability_zone       = var.availability_zone["az3"]
  map_public_ip_on_launch = "false"
  subnet_name             = "${var.environment_identifier}-vpn-dbaz3"
  vpc_id                  = module.vpn_vpc.vpc_id
  tags                    = var.tags
}

##########################
#  VPC FLOW LOGS
##########################

module "vpn_vpcflowlog_iam_role" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//iam//role?ref=terraform-0.12"
  rolename   = "${var.environment_identifier}-vpn-flowlog"
  policyfile = "vpcflowlog_assume_role.json"
}

module "vpn_vpcflowlog_iam_role_policy" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//iam//rolepolicy?ref=terraform-0.12"
  policyfile = file("policies/vpcflowlog_role_policy.json")
  rolename   = module.vpn_vpcflowlog_iam_role.iamrole_id
}

module "vpn_vpcflowlog" {
  source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//flowlog?ref=terraform-0.12"
  vpc_id                   = module.vpn_vpc.vpc_id
  role_arn                 = module.vpn_vpcflowlog_iam_role.iamrole_arn
  cloudwatch_loggroup_name = module.vpn_vpcflowlog_cloudwatch_loggroup.loggroup_arn
}

#########################
# CLOUDWATCH GROUP
#########################

module "vpn_vpcflowlog_cloudwatch_loggroup" {
  source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//cloudwatch//loggroup?ref=terraform-0.12"
  log_group_path           = "${var.environment_identifier}-vpn"
  loggroupname             = "vpc_flow_logs"
  cloudwatch_log_retention = var.cloudwatch_log_retention
  tags                     = var.tags
}

#Internet gateway

module "vpn_igw" {
  source       = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/internetgateway?ref=terraform-0.12"
  gateway_name = var.environment_identifier
  vpc_id       = module.vpn_vpc.vpc_id
  tags         = var.tags
}

#Routes

module "route-to-internet" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//routes//internetgateway?ref=terraform-0.12"

  route_table_id = [
    module.vpn-public-az1.routetableid,
    module.vpn-public-az2.routetableid,
    module.vpn-public-az3.routetableid,
  ]

  destination_cidr_block = [
    "0.0.0.0/0",
    "0.0.0.0/0",
    "0.0.0.0/0",
  ]

  gateway_id = module.vpn_igw.igw_id
}

## NATGATEWAY
module "common-nat-az1" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//natgateway?ref=terraform-0.12"
  az     = "${var.environment_identifier}-az1"
  subnet = module.vpn-public-az1.subnetid
  tags   = var.tags
}

module "common-nat-az2" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/natgateway?ref=terraform-0.12"
  az     = "${var.environment_identifier}-az2"
  subnet = module.vpn-public-az2.subnetid
  tags   = var.tags
}

module "common-nat-az3" {
  source = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules/natgateway?ref=terraform-0.12"
  az     = "${var.environment_identifier}-az3"
  subnet = module.vpn-public-az3.subnetid
  tags   = var.tags
}

