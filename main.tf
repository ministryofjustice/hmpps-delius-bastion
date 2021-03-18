resource "aws_kms_key" "remote_state" {
  description             = "This key is used to encrypt ${var.remote_state_bucket_name} bucket"
  deletion_window_in_days = 10
  tags = merge(
    var.tags,
    {
      "Name" = "${var.remote_state_bucket_name}-kms-key"
    },
  )
}

resource "aws_kms_alias" "remote_state" {
  name          = "alias/${var.remote_state_bucket_name}-kms-key"
  target_key_id = aws_kms_key.remote_state.key_id
}

module "remote_state" {
  source                   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//remote_state?ref=terraform-0.12"
  remote_state_bucket_name = var.remote_state_bucket_name
  kms_key_arn              = aws_kms_key.remote_state.arn
  tags                     = var.tags
}

module "dynamodb-table" {
  source     = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//dynamodb-tables?ref=terraform-0.12"
  table_name = "${var.environment_identifier}-lock-table"
  tags       = var.tags
  hash_key   = "LockID"
}

