locals {
  instance_role_name = "SSMBastionAccess"
}

# Derive assume permissions
data "aws_iam_policy_document" "instance_iam_role_assume_permissions" {
  statement {
    effect = "Allow"
    actions = [
      "sts.AssumeRole"
    ]
    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }
  }
}

# Define IAM role
resource "aws_iam_role" "instance_iam_role" {
  name               = local.instance_role_name
  assume_role_policy = data.aws_iam_policy_document.instance_iam_role_assume_permissions.json
  tags = merge(
    var.tags,
    {
      "Name" = var.environment_name
    }
  )
}

# Attach managed policy to the role
resource "aws_iam_role_policy_attachment" "instance_iam_policy_attach_amazonssmmanagedinstancecore" {
  role       = aws_iam_role.instance_iam_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Create the instance profile (referenced by the aws_instance)
resource "aws_iam_instance_profile" "instance_profile" {
  name = local.instance_role_name
  role = aws_iam_role.instance_iam_role.name
}