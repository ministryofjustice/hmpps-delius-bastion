resource "aws_cloudwatch_log_group" "lambda" {
  name              = local.log_group
  retention_in_days = 14
  tags              = local.tags
}

data "aws_s3_bucket_object" "lambda" {
  bucket = var.active_directory_configs["lambda_bucket"]
  key    = "${var.active_directory_configs["s3Key"]}/${local.function_name}/function.zip"
}

resource "aws_lambda_function" "lambda" {
  s3_bucket         = var.active_directory_configs["lambda_bucket"]
  s3_key            = data.aws_s3_bucket_object.lambda.key
  s3_object_version = data.aws_s3_bucket_object.lambda.version_id
  function_name     = local.function_name
  role              = aws_iam_role.lambda.arn
  handler           = "main.lambda_handler"
  runtime           = "python3.8"
  publish           = true
  memory_size       = 256
  timeout           = 30

  environment {
    variables = {
      DIRECTORY_ID          = aws_directory_service_directory.directory.id
      SOURCE_EMAIL_ADDRESS  = var.active_directory_configs["source_email"]
      SES_REGION            = var.active_directory_configs["ses_region"]
      SES_IAM_ROLE_ARN      = aws_iam_role.ses.arn
    }
  }
  tags = merge(
    local.tags,
    {
      "Name" = local.function_name
    },
  )
}
