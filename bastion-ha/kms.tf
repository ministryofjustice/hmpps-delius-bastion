resource "aws_kms_key" "bastion_key" {
  description             = "Engineering JIRA Encryption Key"
  deletion_window_in_days = 30
  policy                  = data.template_file.efs_kms_policy.rendered
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-bastion-pri-kms"
    },
  )
}

resource "aws_kms_alias" "bastion_key_alias" {
  name          = "alias/bastion-kms-key"
  target_key_id = aws_kms_key.bastion_key.key_id
}
