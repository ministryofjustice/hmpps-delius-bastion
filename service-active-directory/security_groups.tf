resource "aws_security_group" "instance" {
  name_prefix = "${local.common_name}-mgmt-instance"
  description = "vpn active directory management"
  vpc_id      = local.vpc_id

  tags = merge(
    local.tags,
    {
      "Name" = "${local.common_name}-mgmt-instance"
    },
  )
}

resource "aws_security_group_rule" "internal_inst_sg_ingress_self" {
  security_group_id = aws_security_group.instance.id
  type              = "ingress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
}

resource "aws_security_group_rule" "internal_inst_sg_egress_self" {
  security_group_id = aws_security_group.instance.id
  type              = "egress"
  from_port         = 0
  to_port           = 0
  protocol          = -1
  self              = true
}

resource "aws_security_group_rule" "outbound_traffic_http" {
  protocol          = "tcp"
  security_group_id = aws_security_group.instance.id
  from_port         = 80
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}
resource "aws_security_group_rule" "outbound_traffic_https" {
  protocol          = "tcp"
  security_group_id = aws_security_group.instance.id
  from_port         = 443
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

resource "aws_security_group" "jumphost" {
  name_prefix = "${local.common_name}-mgmt-jumphost"
  description = "vpn active directory management"
  vpc_id      = local.vpc_id


  tags = merge(
    local.tags,
    {
      "Name" = "${local.common_name}-mgmt-jumphost"
    },
  )
}
