resource "aws_security_group" "vpn" {
  name_prefix = local.common_name
  description = "Client VPN network associations"
  vpc_id      = local.vpc_id

  ingress {
    description = "Allow self access only by default"
    from_port   = 0
    protocol    = -1
    self        = true
    to_port     = 0
  }

  tags = merge(
    local.tags,
    {
      "Name" = local.common_name
    },
  )
}

resource "aws_security_group_rule" "internal_out" {
  from_port         = 0
  protocol          = "tcp"
  security_group_id = aws_security_group.vpn.id
  to_port           = 65535
  cidr_blocks       = ["10.0.0.0/8"]
  type              = "egress"
}

resource "aws_security_group_rule" "internal_out_ping" {
  security_group_id = aws_security_group.vpn.id
  type              = "egress"
  protocol          = "icmp"
  from_port         = "8"
  to_port           = "0"
  cidr_blocks       = ["10.0.0.0/8"]
  description       = "Internal Ping out all"
}

resource "aws_security_group_rule" "mgmt_rdp_out" {
  security_group_id        = aws_security_group.vpn.id
  type                     = "egress"
  protocol                 = "tcp"
  from_port                = 3389
  to_port                  = 3389
  source_security_group_id = local.management_security_group_id
  description              = "rdp out"
}

resource "aws_security_group_rule" "mgmt_rdp_in" {
  security_group_id        = local.management_security_group_id
  type                     = "ingress"
  protocol                 = "tcp"
  from_port                = 3389
  to_port                  = 3389
  source_security_group_id = aws_security_group.vpn.id
  description              = "rdp in"
}
