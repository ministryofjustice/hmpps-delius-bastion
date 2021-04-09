data "aws_route53_zone" "zone" {
  name         = var.bastion_domain_zone
  private_zone = false
}

resource "aws_route53_record" "bastion_efs_record" {
  name    = local.bastion_efs_fqdn
  type    = "CNAME"
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl     = 300
  records = [aws_efs_file_system.bastion_efs.dns_name]
}

resource "aws_route53_record" "bastion_lb_record" {
  name    = local.bastion_lb_fqdn
  type    = "CNAME"
  zone_id = data.aws_route53_zone.zone.zone_id
  ttl     = 300
  records = [aws_lb.bastion_lb.dns_name]
}
