resource "aws_iam_role" "directory" {
  name               = "${local.common_name}-directory-role"
  assume_role_policy = file("./policies/ec2.json")
  description        = local.common_name
  tags               = local.tags
}

resource "aws_iam_role_policy_attachment" "ssm_agent1" {
  role       = aws_iam_role.directory.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2RoleforSSM"
}

resource "aws_iam_role_policy_attachment" "ssm_agent" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
  role       = aws_iam_role.directory.name
}

resource "aws_iam_role_policy_attachment" "ssm_ad_agent" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMDirectoryServiceAccess"
  role       = aws_iam_role.directory.name
}

resource "aws_iam_instance_profile" "ec2" {
  name = "${local.common_name}-mgmt-profile"
  role = aws_iam_role.directory.name
}

#Lambda
data "aws_iam_policy_document" "lamda-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["lambda.amazonaws.com"]
    }
  }
}

data "aws_iam_policy_document" "ses-assume-policy" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "AWS"
      identifiers = [aws_iam_role.lambda.arn]
    }
  }
}

data "aws_iam_policy_document" "lambda-policy" {
  statement {
    actions   = ["sts:AssumeRole"]
    resources = [aws_iam_role.ses.arn]
    effect = "Allow"
  }
  statement {
    actions   = ["ds:Describe*", "ds:ResetUserPassword"]
    resources = ["arn:aws:ds:*:${local.account_id}:directory/${aws_directory_service_directory.directory.id}"]
    effect = "Allow"
  }
  statement {
    actions   = ["ses:SendEmail","ses:SendRawEmail", "ses:GetSendQuota"]
    resources = ["*"]
    effect = "Allow"
  }
}

data "aws_iam_policy_document" "ses-policy" {
  statement {
    actions   = ["ses:SendEmail","ses:SendRawEmail", "ses:GetSendQuota"]
    resources = ["*"]
    effect = "Allow"
  }
}

resource "aws_iam_role" "lambda" {
  name               = "${local.common_name}-directory-lambda"
  assume_role_policy = data.aws_iam_policy_document.lamda-assume-policy.json
  description        = local.common_name
  tags               = local.tags
}

resource "aws_iam_policy" "lambda" {
  name        = "${local.common_name}-directory-lambda-policy"
  description = local.common_name
  policy = data.aws_iam_policy_document.lambda-policy.json
}

resource "aws_iam_role_policy_attachment" "lambda" {
  role       = aws_iam_role.lambda.name
  policy_arn = aws_iam_policy.lambda.arn
}

resource "aws_iam_role" "ses" {
  name               = "${local.common_name}-directory-lambda-ses"
  assume_role_policy = data.aws_iam_policy_document.ses-assume-policy.json
  description        = local.common_name
  tags               = local.tags
}

resource "aws_iam_policy" "ses" {
  name        = "${local.common_name}-directory-lambda-ses-policy"
  description = local.common_name
  policy = data.aws_iam_policy_document.ses-policy.json
}

resource "aws_iam_role_policy_attachment" "ses" {
  role       = aws_iam_role.ses.name
  policy_arn = aws_iam_policy.ses.arn
}
