locals {
  bastion_domain_name = var.bastion_domain_name
}

data "aws_route53_zone" "public_zone" {
  name         = local.bastion_domain_name
  private_zone = false
}

resource "aws_route53_record" "public_zone" {
  for_each = {
    for dvo in aws_acm_certificate.public_zone.domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.public_zone.zone_id
}

resource "aws_acm_certificate" "public_zone" {
  domain_name               = local.bastion_domain_name
  validation_method         = "DNS"
  subject_alternative_names = ["*.${local.bastion_domain_name}"]
  tags = merge(
    var.tags,
    {
      "Name" = local.bastion_domain_name
    },
  )
}
