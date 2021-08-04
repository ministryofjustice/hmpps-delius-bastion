variable "tags" {
  type    = map(string)
  default = {}
}

variable "region" {
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_name" {
}

variable "active_directory_configs" {
  type = map(string)
  default = {
    ssm_admin_password = "/hmpps/vpn/activeDirectory/admin/password"
    type               = "MicrosoftAD"
    edition            = "Standard"
    deployer_key       = "tf-eu-west-2-hmpps-eng-dev-ssh-key"
    instance_type      = "m4.xlarge"
    lambda_bucket      = "hmpps-eng-builds-artefact"
    s3Key              = "lambda/eng-lambda-functions-builder/latest"
    source_email       = "no-reply@engineering-dev.probation.hmpps.dsd.io"
    ses_region         = "eu-west-2"
  }
}
