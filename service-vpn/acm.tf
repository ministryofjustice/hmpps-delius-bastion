resource "aws_acm_certificate" "ca" {
  private_key      = data.aws_ssm_parameter.tls_ca_key.value
  certificate_body = data.aws_ssm_parameter.tls_ca_cert.value
  tags = merge(
    local.tags,
    {
      "Name" = "${local.common_name}-ca"
    },
  )
}

resource "aws_acm_certificate" "server" {
  private_key       = data.aws_ssm_parameter.server_tls_key.value
  certificate_body  = aws_acmpca_certificate.server_pca.certificate
  certificate_chain = aws_acmpca_certificate.server_pca.certificate_chain
  tags = merge(
    local.tags,
    {
      "Name" = "${local.common_name}"
    },
  )
}

resource "tls_cert_request" "server" {
  key_algorithm   = "RSA"
  private_key_pem = data.aws_ssm_parameter.server_tls_key.value

  subject {
    common_name         = "${local.common_name}-server"
    organization        = "MOJ"
    organizational_unit = "HMPPS"
  }
}

resource "aws_acmpca_certificate" "server_pca" {
  certificate_authority_arn   = local.ca_arn
  certificate_signing_request = tls_cert_request.server.cert_request_pem
  signing_algorithm           = "SHA256WITHRSA"
  validity {
    type  = "YEARS"
    value = 1
  }
}
