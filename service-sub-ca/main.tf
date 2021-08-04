locals {
  account_id     = data.aws_caller_identity.current.account_id
  region         = var.region
  common_name    = "${var.short_environment_identifier}-sub-ca"
  tags           = var.tags
  ca_name_prefix = "${data.terraform_remote_state.rootca.outputs.info["prefix"]}-${var.environment}"
  ca_root_arn    = data.terraform_remote_state.rootca.outputs.info["arn"]
}
