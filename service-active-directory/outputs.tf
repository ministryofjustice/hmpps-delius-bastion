output "info" {
  value = {
    id                           = aws_directory_service_directory.directory.id
    domain_name                  = local.domain_name
    security_group_id            = aws_directory_service_directory.directory.security_group_id
    access_url                   = aws_directory_service_directory.directory.access_url
    dns_ip_addresses             = aws_directory_service_directory.directory.dns_ip_addresses
    ssm_adjoin_document_name     = aws_ssm_document.awsconfig_domain_document.name
    management_security_group_id = aws_security_group.instance.id
  }
}
