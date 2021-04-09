locals {
  name_prefix = var.environment

  public_subnet_ids = [
    data.terraform_remote_state.bastion_vpc.outputs.subnets["bastion-public-az1"],
    data.terraform_remote_state.bastion_vpc.outputs.subnets["bastion-public-az2"],
    data.terraform_remote_state.bastion_vpc.outputs.subnets["bastion-public-az3"],
  ]

  private_subnet_ids = [
    data.terraform_remote_state.bastion_vpc.outputs.subnets["bastion-private-az1"],
    data.terraform_remote_state.bastion_vpc.outputs.subnets["bastion-private-az2"],
    data.terraform_remote_state.bastion_vpc.outputs.subnets["bastion-private-az3"],
  ]

  ## move R53 FQDN var interpolation here so that ASG isn"t rebuilt when DB restored
  bastion_efs_fqdn = "${local.name_prefix}-bastion-efs.${data.aws_route53_zone.zone.name}"
  bastion_lb_fqdn  = "ssh2.${data.aws_route53_zone.zone.name}"

  ami_id = data.aws_ami.amazon_linux.id
  #ami_id = data.aws_ami.centos.id
}
