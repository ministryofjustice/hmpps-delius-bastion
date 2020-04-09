resource "aws_security_group" "vpn-sg" {
  name        = "${var.environment_identifier}-vpn-sg"
  description = "Inbound security group for ${var.environment_identifier}-vpn"
  vpc_id      = "${data.terraform_remote_state.bastion_vpc.bastion_vpc_id}"
  tags        = "${merge(var.tags, map("Name", "${var.environment_identifier}-vpn"))}"
}


resource "aws_security_group_rule" "https_out" {
  from_port         = 443
  protocol          = "tcp"
  security_group_id = "${aws_security_group.vpn-sg.id}"
  to_port           = 443
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

resource "aws_security_group_rule" "http_out" {
  from_port         = 80
  protocol          = "tcp"
  security_group_id = "${aws_security_group.vpn-sg.id}"
  to_port           = 80
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

resource "aws_security_group_rule" "solr_out" {
  from_port         = 8983
  protocol          = "tcp"
  security_group_id = "${aws_security_group.vpn-sg.id}"
  to_port           = 8983
  cidr_blocks       = ["0.0.0.0/0"]
  type              = "egress"
}

# Access
resource "aws_security_group_rule" "ssh_in" {
  from_port         = 22
  protocol          = "tcp"
  security_group_id = "${aws_security_group.vpn-sg.id}"
  to_port           = 22
  cidr_blocks       = ["${var.vpn_access_list}"]
  type              = "ingress"
}

resource "aws_security_group_rule" "ipsec2_in" {
  from_port         = 4500
  protocol          = "udp"
  security_group_id = "${aws_security_group.vpn-sg.id}"
  to_port           = 4500
  cidr_blocks       = ["${var.vpn_access_list}"]
  type              = "ingress"
}

resource "aws_security_group_rule" "ipsec_in" {
  from_port         = 500
  protocol          = "udp"
  security_group_id = "${aws_security_group.vpn-sg.id}"
  to_port           = 500
  cidr_blocks       = ["${var.vpn_access_list}"]
  type              = "ingress"
}
