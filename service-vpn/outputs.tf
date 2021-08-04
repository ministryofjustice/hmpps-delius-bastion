output "vpn_info" {
  value = {
    dns_name         = aws_ec2_client_vpn_endpoint.vpn.dns_name
    id               = aws_ec2_client_vpn_endpoint.vpn.id
    self_service_url = "https://self-service.clientvpn.amazonaws.com/endpoints/${aws_ec2_client_vpn_endpoint.vpn.id}"
    s3bucket         = aws_s3_bucket.vpn.id
    source_cidrs = [
      data.terraform_remote_state.vpn_vpc.outputs.subnet_cidrs["vpn-private-az1"],
      data.terraform_remote_state.vpn_vpc.outputs.subnet_cidrs["vpn-private-az2"],
      data.terraform_remote_state.vpn_vpc.outputs.subnet_cidrs["vpn-private-az3"]
    ]
  }
}
