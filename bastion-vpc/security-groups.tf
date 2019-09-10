#######################################
# SECURITY GROUPS
#######################################
resource "aws_security_group" "bastion-vpc-sg" {
  name        = "${var.environment_identifier}-bastion-vpc-sg"
  description = "Inbound security group for ${var.environment_identifier}-vpc"
  vpc_id      = "${module.bastion_vpc.vpc_id}"

  tags = "${merge(var.tags, map("Name", "${var.environment_identifier}-bastion-vpc-sg"))}"
}

resource "aws_security_group_rule" "ssh_in" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion-vpc-sg.id}"
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
}

resource "aws_security_group_rule" "https_in" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion-vpc-sg.id}"
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "ingress"
}

resource "aws_security_group_rule" "internal_in_ping" {
  security_group_id = "${aws_security_group.bastion-vpc-sg.id}"
  type              = "ingress"
  protocol          = "icmp"
  from_port         = "8"
  to_port           = "0"
  cidr_blocks       = ["10.0.0.0/8"]
  description       = "Internal Ping in all"
}

resource "aws_security_group" "bastion-vpc-sg-outbound" {
  name        = "${var.environment_identifier}-bastion-vpc-sg-outbound"
  description = "Outbound security group for ${var.environment_identifier}-vpc"
  vpc_id      = "${module.bastion_vpc.vpc_id}"

  tags = "${merge(var.tags, map("Name", "${var.environment_identifier}-bastion-vpc-outbound"))}"
}

resource "aws_security_group_rule" "https_out" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion-vpc-sg-outbound.id}"
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

resource "aws_security_group_rule" "http_out" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion-vpc-sg-outbound.id}"
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

resource "aws_security_group_rule" "ssh_out" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion-vpc-sg-outbound.id}"
  to_port           = 22
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

# RDP
resource "aws_security_group_rule" "rdp_out" {
  from_port         = 3389
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion-vpc-sg-outbound.id}"
  to_port           = 3389
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

resource "aws_security_group_rule" "internal_out" {
  from_port         = 0
  protocol          = "tcp"
  security_group_id = "${aws_security_group.bastion-vpc-sg-outbound.id}"
  to_port           = 65535
  cidr_blocks       = ["10.0.0.0/8"]
  type              = "egress"
}

resource "aws_security_group_rule" "internal_out_ping" {
  security_group_id = "${aws_security_group.bastion-vpc-sg-outbound.id}"
  type              = "egress"
  protocol          = "icmp"
  from_port         = "8"
  to_port           = "0"
  cidr_blocks       = ["10.0.0.0/8"]
  description       = "Internal Ping out all"
}
