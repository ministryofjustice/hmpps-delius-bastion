resource "aws_security_group" "bastion_efs_sg" {
  name        = "${local.name_prefix}-bastion-efs-sg"
  description = "Engineering Bastion EFS SG"
  vpc_id      = data.terraform_remote_state.bastion_vpc.outputs.vpc["id"]
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-bastion-efs-sg"
    },
  )
}

#-------------------------------------------------------------
### efs sg
#-------------------------------------------------------------

resource "aws_security_group_rule" "bastion_nfs_out_rule" {
  security_group_id        = aws_security_group.bastion_efs_sg.id
  source_security_group_id = aws_security_group.efs_sg.id
  type                     = "egress"
  from_port                = 2049
  to_port                  = 2049
  protocol                 = "tcp"
}

resource "aws_launch_configuration" "bastion_host_lc" {
  name_prefix                 = "${local.name_prefix}-bastion-pri-lc"
  associate_public_ip_address = false
  iam_instance_profile        = aws_iam_instance_profile.bastion_profile.name
  image_id                    = local.ami_id
  instance_type               = var.bastion_conf["instance_type"]


  security_groups = [
    data.terraform_remote_state.bastion_vpc.outputs.bastion_vpc_sg_id,
    data.terraform_remote_state.bastion_vpc.outputs.bastion_vpc_sg_outbound_id,
    aws_security_group.bastion_efs_sg.id,
  ]

  user_data_base64 = base64encode(data.template_file.bastion_user_data_template.rendered)
  key_name         = aws_key_pair.ssh_deployer_key.key_name

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "bastion_asg" {
  name                 = "${local.name_prefix}-bastion-pri-asg"
  launch_configuration = aws_launch_configuration.bastion_host_lc.id
  target_group_arns    = [aws_lb_target_group.bastion_lb_target_group.arn]

  # Bastion Server used - single instance only
  max_size = "1"
  min_size = "1"

  vpc_zone_identifier = local.private_subnet_ids

  tags = [
    for key, value in merge(var.tags, {
      "Name" = "${local.name_prefix}-bastion-pri-asg"
      }) : {
      key                 = key
      value               = value
      propagate_at_launch = true
    }
  ]
}
