resource "aws_acmpca_certificate_authority" "root" {
  certificate_authority_configuration {
    key_algorithm     = "RSA_2048"
    signing_algorithm = "SHA512WITHRSA"

    subject {
      common_name         = lower("${local.ca_name_prefix}-CA")
      country             = "GB"
      organization        = "MOJ"
      organizational_unit = "HMPPS"
    }
  }

  revocation_configuration {
    crl_configuration {
      custom_cname       = lower("${local.ca_name_prefix}-CA")
      enabled            = true
      expiration_in_days = 7
      s3_bucket_name     = aws_s3_bucket.ca.id
    }
  }

  type                            = "ROOT"
  permanent_deletion_time_in_days = 7
  tags = merge(
    local.tags,
    {
      "Name" = lower("${local.ca_name_prefix}-CA")
    },
  )

  depends_on = [aws_s3_bucket_policy.ca]
}

resource "aws_acmpca_certificate" "root" {
  certificate_authority_arn   = aws_acmpca_certificate_authority.root.arn
  certificate_signing_request = aws_acmpca_certificate_authority.root.certificate_signing_request
  signing_algorithm           = "SHA512WITHRSA"

  template_arn = "arn:${data.aws_partition.current.partition}:acm-pca:::template/RootCACertificate/V1"

  validity {
    type  = "YEARS"
    value = 5
  }
}

resource "aws_acmpca_certificate_authority_certificate" "root" {
  certificate_authority_arn = aws_acmpca_certificate_authority.root.arn

  certificate       = aws_acmpca_certificate.root.certificate
  certificate_chain = aws_acmpca_certificate.root.certificate_chain
}
