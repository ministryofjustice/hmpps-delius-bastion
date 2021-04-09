resource "aws_lb" "bastion_lb" {
  name                       = "${local.name_prefix}-bastion--pri-alb"
  internal                   = false
  load_balancer_type         = "network"
  subnets                    = local.public_subnet_ids
  #enable_deletion_protection = true
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-bastion-lb-pri-alb"
    },
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_lb_target_group" "bastion_lb_target_group" {
  name     = "${local.name_prefix}-bastion-lb-pri-tg"
  vpc_id   = data.terraform_remote_state.bastion_vpc.outputs.vpc["id"]
  protocol = "TCP"
  port     = "22"
  tags = merge(
    var.tags,
    {
      "Name" = "${local.name_prefix}-bastion-lb-pri-tg"
    },
  )

  health_check {
    protocol = "TCP"
    port     = 22
  }
}

resource "aws_lb_listener" "internal_lb_https_listener" {
  load_balancer_arn = aws_lb.bastion_lb.arn
  port              = "22"
  protocol          = "TCP"

  default_action {
    target_group_arn = aws_lb_target_group.bastion_lb_target_group.arn
    type             = "forward"
  }
}
