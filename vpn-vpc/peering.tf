locals {
  peer_accepter_prefix = var.environment_name
}

resource "aws_vpc_peering_connection_accepter" "peer" {
  count                     = length(var.vpn_peering_ids)
  vpc_peering_connection_id = element(split(",", var.vpn_peering_ids[count.index]), 0)
  auto_accept               = true
  tags = merge(
    var.tags,
    {
      "Name" = "${local.peer_accepter_prefix}-vpn-from-${element(split(",", var.vpn_peering_ids[count.index]), 2)}-vpc"
    },
    {
      "project" = element(split(",", var.vpn_peering_ids[count.index]), 2)
    },
    {
      "bastion_inventory" = "not applicable"
    },
    {
      "environment-name" = "${local.peer_accepter_prefix}-from-${element(split(",", var.vpn_peering_ids[count.index]), 2)}-vpc"
    },
    {
      "source-code" = "accepter=hmpps-delius-bastion"
    },
  )
}

# public
resource "aws_route" "peer_route_az1" {
  count                     = length(var.vpn_peering_ids)
  route_table_id            = module.vpn-public-az1.routetableid
  vpc_peering_connection_id = element(split(",", var.vpn_peering_ids[count.index]), 0)
  destination_cidr_block    = element(split(",", var.vpn_peering_ids[count.index]), 1)
}

resource "aws_route" "peer_route_az2" {
  count                     = length(var.vpn_peering_ids)
  route_table_id            = module.vpn-public-az2.routetableid
  vpc_peering_connection_id = element(split(",", var.vpn_peering_ids[count.index]), 0)
  destination_cidr_block    = element(split(",", var.vpn_peering_ids[count.index]), 1)
}

resource "aws_route" "peer_route_az3" {
  count                     = length(var.vpn_peering_ids)
  route_table_id            = module.vpn-public-az3.routetableid
  vpc_peering_connection_id = element(split(",", var.vpn_peering_ids[count.index]), 0)
  destination_cidr_block    = element(split(",", var.vpn_peering_ids[count.index]), 1)
}

# private
resource "aws_route" "peer_route_private_az1" {
  count                     = length(var.vpn_peering_ids)
  route_table_id            = module.vpn-private-az1.routetableid
  vpc_peering_connection_id = element(split(",", var.vpn_peering_ids[count.index]), 0)
  destination_cidr_block    = element(split(",", var.vpn_peering_ids[count.index]), 1)
}

resource "aws_route" "peer_route_private_az2" {
  count                     = length(var.vpn_peering_ids)
  route_table_id            = module.vpn-private-az2.routetableid
  vpc_peering_connection_id = element(split(",", var.vpn_peering_ids[count.index]), 0)
  destination_cidr_block    = element(split(",", var.vpn_peering_ids[count.index]), 1)
}

resource "aws_route" "peer_route_private_az3" {
  count                     = length(var.vpn_peering_ids)
  route_table_id            = module.vpn-private-az3.routetableid
  vpc_peering_connection_id = element(split(",", var.vpn_peering_ids[count.index]), 0)
  destination_cidr_block    = element(split(",", var.vpn_peering_ids[count.index]), 1)
}

