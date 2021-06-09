locals {
  account_id     = data.aws_caller_identity.current.account_id
  vpc_id         = data.terraform_remote_state.vpn_vpc.outputs.vpc["id"]
  cidr_block     = data.terraform_remote_state.vpn_vpc.outputs.vpc["cidr"]
  region         = var.region
  common_name    = "${var.environment_name}"
  domain_name    = "${local.common_name}.local"
  tags           = var.tags
  admin_password = data.aws_ssm_parameter.admin_password.value
  function_name   = "directoryPasswordReset"
  log_group       = "/aws/lambda/${local.function_name}"
  subnet_ids = [
    data.terraform_remote_state.vpn_vpc.outputs.vpn-db-subnet-az1,
    data.terraform_remote_state.vpn_vpc.outputs.vpn-db-subnet-az2
  ]
}
