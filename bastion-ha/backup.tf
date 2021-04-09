resource "aws_backup_vault" "bastion_backup_vault" {
  name        = "${local.name_prefix}-bastion-bkup-pri-vlt"
  kms_key_arn = aws_kms_key.bastion_key.arn
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-bastion-bkup-pri-vlt"
    },
  )
}

resource "aws_backup_plan" "bastion_backup_plan" {
  name = "${local.name_prefix}-bastion-bkup-pri-pln"

  rule {
    rule_name         = "Bastion EFS Volume Backup"
    target_vault_name = aws_backup_vault.bastion_backup_vault.name
    schedule          = var.efs_conf["backup_cron"]

    lifecycle {
      cold_storage_after = var.efs_conf["backup_coldstorage_after_days"]
      delete_after       = var.efs_conf["backup_delete_after_days"]
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-bastion-bkup-pri-pln"
    },
  )
}

resource "aws_backup_selection" "bastion_backup_selection" {
  iam_role_arn = aws_iam_role.bastion_efs_backup_role.arn
  name         = "${local.name_prefix}-bastion-bkup-pri-sel"
  plan_id      = aws_backup_plan.bastion_backup_plan.id

  resources = [
    aws_efs_file_system.bastion_efs.arn,
  ]
}
