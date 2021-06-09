output "info" {
  value = {
    arn    = aws_acmpca_certificate_authority.sub-ca.arn
    bucket = aws_s3_bucket.ca.id
    prefix = local.ca_name_prefix
  }
}
