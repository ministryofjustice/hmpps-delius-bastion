resource "aws_cloudwatch_log_group" "vpn" {
  name              = local.common_name
  retention_in_days = var.log_retention_days
  kms_key_id        = aws_kms_key.kms.arn
  tags              = local.tags
}

resource "aws_cloudwatch_log_stream" "vpn" {
  name           = local.common_name
  log_group_name = aws_cloudwatch_log_group.vpn.name
}
