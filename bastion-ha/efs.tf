resource "aws_security_group" "efs_sg" {
  name        = "${local.name_prefix}-bastion-efs-pri-sg"
  description = "Engineering Bastion EFS SG"
  vpc_id      = data.terraform_remote_state.bastion_vpc.outputs.vpc["id"]
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-efs-pri-sg"
    },
  )
}

resource "aws_security_group_rule" "bastion_ec2_ingress_rule" {
  security_group_id        = aws_security_group.efs_sg.id
  source_security_group_id = aws_security_group.bastion_efs_sg.id
  type                     = "ingress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
}

resource "aws_efs_file_system" "bastion_efs" {
  creation_token                  = "${local.name_prefix}-bastion-efs-pri-efs}"
  kms_key_id                      = aws_kms_key.bastion_key.arn
  encrypted                       = var.efs_conf["encrypted"]
  performance_mode                = var.efs_conf["performance_mode"]
  provisioned_throughput_in_mibps = var.efs_conf["provisioned_throughput_in_mibps"]
  throughput_mode                 = var.efs_conf["throughput_mode"]

  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-bastion-efs-pri-efs"
    },
  )
}

resource "aws_efs_mount_target" "bastion_efs_mount" {
  count           = length(local.private_subnet_ids)
  file_system_id  = aws_efs_file_system.bastion_efs.id
  subnet_id       = element(compact(local.private_subnet_ids), count.index)
  security_groups = [aws_security_group.efs_sg.id]
}
