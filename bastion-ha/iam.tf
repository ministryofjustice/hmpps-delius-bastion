# JIRA EC2 Host ROle
resource "aws_iam_role" "bastion_role" {
  name               = "${local.name_prefix}-bastion-pri-iam"
  assume_role_policy = data.template_file.ec2_assume_role_template.rendered
}

# JIRA EC2 Host Policy
resource "aws_iam_role_policy" "bastion_role_policy" {
  name = "${local.name_prefix}-bastion-pri-iam"
  role = aws_iam_role.bastion_role.name

  policy = data.template_file.bastion_role_policy_template.rendered
}

# JIRA EC2 Host Profile
resource "aws_iam_instance_profile" "bastion_profile" {
  name = "${local.name_prefix}-bastion-pri-iam"
  role = aws_iam_role.bastion_role.name
}

# Attach SSM Management role for remote access including port forwarding for testing via ssm session mgr
resource "aws_iam_role_policy_attachment" "bastion_ssm_agent" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.bastion_role.name
}

# AWS Backups IAM role for EFS Data Volume
resource "aws_iam_role" "bastion_efs_backup_role" {
  name               = "${local.name_prefix}-bastionbkup-pri-iam"
  assume_role_policy = data.template_file.backup_assume_role_template.rendered
}

resource "aws_iam_role_policy_attachment" "bastion_efs_backup_policy" {
  policy_arn = "arn:aws:iam::aws:policy/service-role/AWSBackupServiceRolePolicyForBackup"
  role       = aws_iam_role.bastion_efs_backup_role.name
}

# AWS Restore Backups IAM role for EFS Data Volume
resource "aws_iam_role" "bastion_restore_role" {
  name               = "${local.name_prefix}-bastion-restore-iam"
  assume_role_policy = data.template_file.backup_assume_role_template.rendered
}

## The "AWSBackupServiceRolePolicyForBackup" AWS managed policy is missing a few KMS actions - after testing we learned that
## we need to copy that policy and modify it.
## Looks like the AWS managed policy has an issue as it is missing a simple "*" on
## "kms:GenerateDataKey"
## works with
## "kms:GenerateDataKey*"
resource "aws_iam_role_policy" "bastion_restore_policy" {
  name = "${local.name_prefix}-bastion-restore-iam"
  role = aws_iam_role.bastion_restore_role.name

  policy = data.template_file.bastion_restore_policy.rendered
}
