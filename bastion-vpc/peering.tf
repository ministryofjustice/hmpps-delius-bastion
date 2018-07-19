resource "aws_vpc_peering_connection_accepter" "peer" {
  count = "${length(var.bastion_peering_ids)}"
  vpc_peering_connection_id = "${element(split(",", var.bastion_peering_ids[count.index] ), 0)}"
  auto_accept = true
  tags = "${var.tags}"
}

resource "aws_route" "peer_route_az1" {
  count = "${length(var.bastion_peering_ids)}"
  route_table_id = "${module.bastion-public-az1.routetableid}"
  vpc_peering_connection_id = "${element(split(",", var.bastion_peering_ids[count.index] ), 0)}"
  destination_cidr_block = "${element(split(",", var.bastion_peering_ids[count.index] ), 1)}"
}

resource "aws_route" "peer_route_az2" {
  count = "${length(var.bastion_peering_ids)}"
  route_table_id = "${module.bastion-public-az2.routetableid}"
  vpc_peering_connection_id = "${element(split(",", var.bastion_peering_ids[count.index] ), 0)}"
  destination_cidr_block = "${element(split(",", var.bastion_peering_ids[count.index] ), 1)}"
}

resource "aws_route" "peer_route_az3" {
  count = "${length(var.bastion_peering_ids)}"
  route_table_id = "${module.bastion-public-az3.routetableid}"
  vpc_peering_connection_id = "${element(split(",", var.bastion_peering_ids[count.index] ), 0)}"
  destination_cidr_block = "${element(split(",", var.bastion_peering_ids[count.index] ), 1)}"
}