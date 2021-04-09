data "aws_route53_zone" "zone" {
  name         = var.bastion_domain_zone
  private_zone = false
}

resource "aws_route53_record" "bastion" {
  zone_id = data.aws_route53_zone.zone.zone_id
  name    = "ssh"
  type    = "A"
  ttl     = "300"
  records = [aws_eip.bastion_eip.public_ip]
}

output "zone_id" {
  value = data.aws_route53_zone.zone.zone_id
}

output "zone_name" {
  value = data.aws_route53_zone.zone.name
}
