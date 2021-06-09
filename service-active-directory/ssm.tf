data "template_file" "awsconfig_domain_document" {
  template = file("templates/awsconfig_Domain_template.json.tpl")

  vars = {
    directory_id               = aws_directory_service_directory.directory.id
    directory_name             = local.domain_name
    directory_ou               = "OU=Computers,OU=${local.common_name},DC=${split(".", local.domain_name)[0]},DC=${split(".", local.domain_name)[1]}"
    directory_primary_dns_ip   = element(tolist(aws_directory_service_directory.directory.dns_ip_addresses), 0)
    directory_secondary_dns_ip = element(tolist(aws_directory_service_directory.directory.dns_ip_addresses), 1)
  }
}

resource "null_resource" "awsconfig_domain_document_rendered" {
  triggers = {
    json = data.template_file.awsconfig_domain_document.rendered
  }
}

resource "aws_ssm_document" "awsconfig_domain_document" {
  name            = "awsconfig_Domain_${aws_directory_service_directory.directory.id}_${local.domain_name}"
  content         = data.template_file.awsconfig_domain_document.rendered
  document_format = "JSON"
  document_type   = "Command"

  tags = local.tags
}
