resource "aws_vpc_peering_connection_accepter" "peer" {
  count = "${length(var.bastion_peering_ids)}"
  vpc_peering_connection_id = "${var.bastion_peering_ids[count.index]}"
  auto_accept = true
  tags = "${var.tags}"
}