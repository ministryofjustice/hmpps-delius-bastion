data "aws_caller_identity" "current" {
}

data "aws_region" "current" {
}

#-------------------------------------------------------------
### Getting the current vpc
#-------------------------------------------------------------
data "terraform_remote_state" "bastion_vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "bastion-vpc/terraform.tfstate"
    region = var.region
  }
}

#-------------------------------------------------------------
### Getting zone data set in service-bastion
#-------------------------------------------------------------
data "terraform_remote_state" "service_bastion" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "service-bastion/terraform.tfstate"
    region = var.region
  }
}

data "template_file" "efs_kms_policy" {
  template = file("${path.module}/templates/kms/kms_key_mgmt_policy.tpl")

  vars = {
    aws_account_id = data.aws_caller_identity.current.account_id
  }
}

data "template_file" "ec2_assume_role_template" {
  template = file("${path.module}/templates/iam/ec2_assume_role.tpl")
  vars     = {}
}

data "template_file" "backup_assume_role_template" {
  template = file("${path.module}/templates/iam/backup_assume_role.tpl")
  vars     = {}
}

data "template_file" "bastion_role_policy_template" {
  template = file("${path.module}/templates/iam/bastion_role.tpl")

  vars = {
    aws_account_id        = data.aws_caller_identity.current.account_id
    region                = data.aws_region.current.name
    bastion_key_alias_arn = aws_kms_alias.bastion_key_alias.arn
  }
}

data "template_file" "bastion_restore_policy" {
  template = file(
    "${path.module}/templates/iam/MOJ_AWSBackupServiceRolePolicyForBackup.tpl",
  )
  vars = {}
}

data "template_file" "bastion_user_data_template" {
  template = file("${path.module}/templates/ec2/bastion_user_data.tpl")

  vars = {
    aws_account_id               = data.aws_caller_identity.current.account_id
    region                       = data.aws_region.current.name
    environment_name             = var.environment_name //?
    bastion_inventory            = var.environment
    env_identifier               = var.environment_identifier
    short_env_identifier         = var.short_environment_identifier
    public_domain                = data.aws_route53_zone.zone.name
    account_id                   = data.aws_caller_identity.current.account_id
    efs_volume_id                = aws_efs_file_system.bastion_efs.id
    efs_mount_dir                = var.efs_conf["efs_mount_dir"]
    efs_mount_user               = var.efs_conf["efs_mount_user"]
    bastion_external_endpoint    = local.bastion_lb_fqdn
    bastion_cloudwatch_log_group = aws_cloudwatch_log_group.bastion_log_group.name
  }
}

# Hack to merge additional tag into existing map and convert to list for use with asg tags input
data "null_data_source" "tags" {
  count = length(keys(var.tags))

  inputs = {
    key                 = element(keys(var.tags), count.index)
    value               = element(values(var.tags), count.index)
    propagate_at_launch = true
  }
}

#
# Get the latest Amazon Linux ami
#
data "aws_ami" "centos" {
  most_recent = true

  filter {
    name   = "name"
    values = ["HMPPS Base CentOS master*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["895523100917"]
}

//=================================================================
// Commented out as we are pinning the ami using local.jira_ami_id
//=================================================================
 # Search for ami id
 data "aws_ami" "amazon_linux" {
   most_recent = true
   owners      = ["self"]

   # Amazon Linux 2 optimised AMI
   filter {
     name   = "name"
     values = ["HMPPS Base Amazon Linux 2 LTS master *"]
   }

   # correct arch
   filter {
     name   = "architecture"
     values = ["x86_64"]
   }

   # Owned by Amazon
   filter {
     name   = "owner-id"
     values = ["895523100917"]
   }

   filter {
     name   = "virtualization-type"
     values = ["hvm"]
   }
 }
