#######################################
# SECURITY GROUPS
#######################################
resource "aws_security_group" "vpn-vpc-sg" {
  name        = "${var.environment_identifier}-vpn-vpc-sg"
  description = "Inbound security group for ${var.environment_identifier}-vpc"
  vpc_id      = module.vpn_vpc.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.environment_identifier}-vpn-vpc-sg"
    },
  )
}

resource "aws_security_group" "vpn-vpc-sg-outbound" {
  name        = "${var.environment_identifier}-vpn-vpc-sg-outbound"
  description = "Outbound security group for ${var.environment_identifier}-vpc"
  vpc_id      = module.vpn_vpc.vpc_id

  tags = merge(
    var.tags,
    {
      "Name" = "${var.environment_identifier}-vpn-vpc-outbound"
    },
  )
}

resource "aws_security_group_rule" "https_out" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.vpn-vpc-sg-outbound.id
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

resource "aws_security_group_rule" "http_out" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.vpn-vpc-sg-outbound.id
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

resource "aws_security_group_rule" "ssh_out" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = aws_security_group.vpn-vpc-sg-outbound.id
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

