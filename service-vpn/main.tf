locals {
  account_id                   = data.aws_caller_identity.current.account_id
  lb_account_id                = var.lb_account_id
  region                       = var.region
  common_name                  = "${var.short_environment_identifier}-vpn"
  tags                         = var.tags
  identity_provider_ssm        = var.vpn_configs["identity_provider_ssm"]
  ssm_prefix                   = var.vpn_configs["ssm_prefix"]
  vpc_id                       = data.terraform_remote_state.vpn_vpc.outputs.vpc["id"]
  vpn_cidr                     = data.terraform_remote_state.vpn_vpc.outputs.vpc["cidr"]
  vpc_sg_outbound_id           = data.terraform_remote_state.vpn_vpc.outputs.vpn_vpc_sg_outbound_id
  public_ssl_arn               = data.terraform_remote_state.vpc.outputs.public_acm_info["arn"]
  public_ssl_domain            = data.terraform_remote_state.vpc.outputs.public_acm_info["domain_name"]
  ca_arn                       = data.terraform_remote_state.subca.outputs.info["arn"]
  directory_id                 = data.terraform_remote_state.directory.outputs.info["id"]
  directory_security_group_id  = data.terraform_remote_state.directory.outputs.info["security_group_id"]
  management_security_group_id = data.terraform_remote_state.directory.outputs.info["management_security_group_id"]
  subnet_ids = [
    data.terraform_remote_state.vpn_vpc.outputs.vpn-private-subnet-az1,
    data.terraform_remote_state.vpn_vpc.outputs.vpn-private-subnet-az2,
    data.terraform_remote_state.vpn_vpc.outputs.vpn-private-subnet-az3
  ]
  associated_subnets = {
    az1 = data.terraform_remote_state.vpn_vpc.outputs.vpn-private-subnet-az1,
    az2 = data.terraform_remote_state.vpn_vpc.outputs.vpn-private-subnet-az2,
    az3 = data.terraform_remote_state.vpn_vpc.outputs.vpn-private-subnet-az3
  }

  additional_routes = flatten([
    for subnet in local.subnet_ids : [
      for route in var.additional_routes : {
        "destination_cidr_block" = route.destination_cidr_block,
        "description"            = route.description,
        "target_vpc_subnet_id"   = subnet
      }
    ]
  ])
}
