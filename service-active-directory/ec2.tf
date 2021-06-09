data "template_file" "userdata" {
  template = file("./user_data/mgmt_instance.tpl")

  vars = {
    ssm_adjoin_document_name = aws_ssm_document.awsconfig_domain_document.name
  }
}

resource "aws_launch_configuration" "instance" {
  name_prefix          = "${local.common_name}-mgmt-instance"
  image_id             = "ami-0986a35f8fb8def13" #data.aws_ami.ami.id
  instance_type        = var.active_directory_configs["instance_type"]
  iam_instance_profile = aws_iam_instance_profile.ec2.name
  key_name             = var.active_directory_configs["deployer_key"]
  security_groups = [
    aws_security_group.instance.id,
    aws_directory_service_directory.directory.security_group_id
  ]
  associate_public_ip_address = false
  user_data                   = data.template_file.userdata.rendered
  enable_monitoring           = true
  ebs_optimized               = true

  root_block_device {
    volume_size = 100
  }

  lifecycle {
    create_before_destroy = true
  }
}

data "null_data_source" "tags" {
  count = length(keys(local.tags))

  inputs = {
    key                 = element(keys(local.tags), count.index)
    value               = element(values(local.tags), count.index)
    propagate_at_launch = true
  }
}

resource "aws_placement_group" "instance" {
  name     = "${local.common_name}-mgmt-instance"
  strategy = "spread"
}

resource "aws_autoscaling_group" "instance" {
  name                      = aws_launch_configuration.instance.name
  vpc_zone_identifier       = flatten(local.subnet_ids)
  placement_group           = aws_placement_group.instance.id
  min_size                  = 1
  max_size                  = 1
  desired_capacity          = 1
  launch_configuration      = aws_launch_configuration.instance.name
  health_check_grace_period = 600
  termination_policies      = ["OldestInstance", "OldestLaunchTemplate", "OldestLaunchConfiguration"]
  health_check_type         = "EC2"

  lifecycle {
    create_before_destroy = true
  }
  tags = concat(
    [
      {
        key                 = "Name"
        value               = aws_launch_configuration.instance.name
        propagate_at_launch = true
      },
    ],
    data.null_data_source.tags.*.outputs
  )
}

resource "aws_instance" "instance" {
  count                       = 0
  ami                         = data.aws_ami.ami.id
  instance_type               = var.active_directory_configs["instance_type"]
  associate_public_ip_address = true
  iam_instance_profile        = aws_iam_instance_profile.ec2.name
  key_name                    = var.active_directory_configs["deployer_key"]
  vpc_security_group_ids      = [aws_security_group.instance.id, aws_security_group.jumphost.id]
  subnet_id                   = data.terraform_remote_state.vpn_vpc.outputs.vpn-public-subnet-az1
  tags = merge(
    local.tags,
    {
      "Name" = "${local.common_name}-jumphost"
    },
  )
}
