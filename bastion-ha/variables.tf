variable "region" {
  description = "The AWS region."
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "environment_identifier" {
  description = "resource label or name"
}

variable "short_environment_identifier" {
  description = "short resource label or name"
}

variable "environment_name" {
}

variable "tags" {
  type = map(string)
}

variable "availability_zone" {
  type = map(string)
}

variable "bastion_domain_zone" {
}

variable "environment" {
}



//variable "remote_state_bucket_name" {
//  description = "Terraform remote state bucket name"
//}
//
//variable "environment_name" {
//  description = "Environment name."
//}
//
//variable "region" {
//  description = "The AWS region."
//}
//
//variable "project_name" {
//  description = "Project name"
//}
//
//variable "project_name_abbreviated" {
//  description = "Abbreviated project name"
//}
//
//variable "route53_domain_private" {
//}
//
//variable "app_name" {
//  default = "jira"
//}
//
//variable "environment_identifier" {
//}
//
//variable "short_environment_identifier" {
//}
//
//variable "route53_sub_domain" {
//}
//
//variable "allowed_jira_cidr" {
//  type = list(string)
//}
//
//variable "public_ssl_arn" {
//}
//
//variable "tags" {
//  description = "Resource tags"
//  type        = map(string)
//}
//
variable "bastion_artefact_bucket" {
  description = "S3 Bucket for Bastion Artefacts"
  default     = "tf-eu-west-2-hmpps-eng-dev-artefacts-s3bucket"
}

variable "efs_conf" {
  description = "Bastion Data EFS Volume Config"
  type        = map(string)

  default = {
    encrypted                       = true
    performance_mode                = "generalPurpose"
    provisioned_throughput_in_mibps = 0
    throughput_mode                 = "bursting"
    backup_cron                     = "cron(0 02 * * ? *)"
    backup_coldstorage_after_days   = 30
    # delet must be >= 90days from cold storage move
    backup_delete_after_days = 120
    efs_mount_dir = "/efs-user"
    efs_mount_user = "root"
  }
}

variable "bastion_conf" {
  description = "JIRA Server Config"
  type        = map(string)

  default = {
    instance_type                 = "t2.micro"
    log_retention                 = 14
  }
}

variable "jira_db_cloudwatch_log_exports" {
  description = "List of enabled logs to export to Cloudwatch Logs"
  type        = list(string)

  default = [
    "error",
  ]
}
