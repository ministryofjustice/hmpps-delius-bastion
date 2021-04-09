resource "aws_cloudwatch_log_group" "bastion_log_group" {
  name              = "${local.name_prefix}-bastion-pri-cwl"
  retention_in_days = var.bastion_conf["log_retention"]
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-bastion-pri-cwl"
    },
  )
}
