resource "aws_ec2_client_vpn_endpoint" "vpn" {
  description            = "Client VPN"
  client_cidr_block      = var.vpn_configs["client_cidr_block"]
  server_certificate_arn = aws_acm_certificate.server.arn
  split_tunnel           = var.split_tunnel_enabled
  tags = merge(
    local.tags,
    {
      "Name" = local.common_name
    },
  )

  authentication_options {
    type                = "directory-service-authentication"
    active_directory_id = local.directory_id
  }

  # authentication_options {
  #   type                       = "certificate-authentication"
  #   root_certificate_chain_arn = aws_acm_certificate.ca.arn
  # }

  # authentication_options {
  #   type              = "federated-authentication"
  #   saml_provider_arn = aws_iam_saml_provider.iam[0].arn
  # }

  connection_log_options {
    enabled               = true
    cloudwatch_log_group  = aws_cloudwatch_log_group.vpn.name
    cloudwatch_log_stream = aws_cloudwatch_log_stream.vpn.name
  }
}

resource "aws_ec2_client_vpn_network_association" "vpn" {
  for_each = local.associated_subnets

  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  subnet_id              = each.value

  security_groups = concat(
    [aws_security_group.vpn.id],
    var.additional_security_groups
  )
}

resource "aws_ec2_client_vpn_authorization_rule" "rules" {
  count = length(var.authorization_rules)

  # authorize_all_groups   = var.authorization_rules[count.index].authorize_all_groups
  access_group_id        = var.authorization_rules[count.index].access_group_id
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  description            = var.authorization_rules[count.index].description
  target_network_cidr    = var.authorization_rules[count.index].target_network_cidr
}

resource "aws_ec2_client_vpn_route" "additional" {
  count = length(local.additional_routes)

  description            = try(local.additional_routes[count.index].description, null)
  destination_cidr_block = local.additional_routes[count.index].destination_cidr_block
  client_vpn_endpoint_id = aws_ec2_client_vpn_endpoint.vpn.id
  target_vpc_subnet_id   = local.additional_routes[count.index].target_vpc_subnet_id
}
