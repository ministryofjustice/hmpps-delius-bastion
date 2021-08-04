locals {
  account_id     = data.aws_caller_identity.current.account_id
  region         = var.region
  common_name    = "${var.short_environment_identifier}-ca"
  tags           = var.tags
  ca_name_prefix = "MOJ-HMPPS"
}
