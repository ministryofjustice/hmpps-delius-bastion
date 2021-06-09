resource "aws_acmpca_certificate_authority" "sub-ca" {
  certificate_authority_configuration {
    key_algorithm     = "RSA_2048"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name         = lower("${local.ca_name_prefix}-SUB-CA")
      country             = "GB"
      organization        = "MOJ"
      organizational_unit = "HMPPS"
    }
  }

  revocation_configuration {
    crl_configuration {
      custom_cname       = lower("${local.ca_name_prefix}-SUB-CA")
      enabled            = true
      expiration_in_days = 7
      s3_bucket_name     = aws_s3_bucket.ca.id
    }
  }

  type                            = "SUBORDINATE"
  permanent_deletion_time_in_days = 7
  tags = merge(
    local.tags,
    {
      "Name" = lower("${local.ca_name_prefix}-SUB-CA")
    },
  )

  depends_on = [aws_s3_bucket_policy.ca]
}

resource "aws_acmpca_certificate" "sub-ca" {
  certificate_authority_arn   = local.ca_root_arn
  certificate_signing_request = aws_acmpca_certificate_authority.sub-ca.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/SubordinateCACertificate_PathLen0/V1"

  validity {
    type  = "YEARS"
    value = 2
  }
}

resource "aws_acmpca_certificate_authority_certificate" "sub-ca" {
  certificate_authority_arn = aws_acmpca_certificate_authority.sub-ca.arn

  certificate       = aws_acmpca_certificate.sub-ca.certificate
  certificate_chain = aws_acmpca_certificate.sub-ca.certificate_chain
}
