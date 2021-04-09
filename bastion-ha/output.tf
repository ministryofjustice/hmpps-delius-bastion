output "bastion_endpoint" {
  value = aws_route53_record.bastion_lb_record.fqdn
}

output "bastion_key" {
  value = {
    id  = aws_kms_key.bastion_key.id
    arn = aws_kms_key.bastion_key.arn
  }
}

output "bastion_key_alias" {
  value = {
    id  = aws_kms_alias.bastion_key_alias.id
    arn = aws_kms_alias.bastion_key_alias.arn
  }
}

output "bastion_efs_backup_role" {
  value = {
    id  = aws_iam_role.bastion_efs_backup_role.id
    arn = aws_iam_role.bastion_efs_backup_role.arn
  }
}

output "bastion_restore_role" {
  value = {
    id  = aws_iam_role.bastion_restore_role.id
    arn = aws_iam_role.bastion_restore_role.arn
  }
}

output "bastion_efs" {
  value = {
    id         = aws_efs_file_system.bastion_efs.id
    arn        = aws_efs_file_system.bastion_efs.arn
    kms_key_id = aws_efs_file_system.bastion_efs.kms_key_id
  }
}

output "bastion_backup_vault" {
  value = {
    id              = aws_backup_vault.bastion_backup_vault.id
    arn             = aws_backup_vault.bastion_backup_vault.arn
    kms_key_arn     = aws_backup_vault.bastion_backup_vault.kms_key_arn
    name            = aws_backup_vault.bastion_backup_vault.name
    recovery_points = aws_backup_vault.bastion_backup_vault.recovery_points
  }
}

output "bastion_asg" {
  value = {
    id                   = aws_autoscaling_group.bastion_asg.id
    arn                  = aws_autoscaling_group.bastion_asg.arn
    launch_configuration = aws_autoscaling_group.bastion_asg.launch_configuration
    name                 = aws_autoscaling_group.bastion_asg.name
  }
}

output "dns" {
  value = {
    zone_id   = data.aws_route53_zone.zone.zone_id
    zone_name = data.aws_route53_zone.zone.name
  }
}
