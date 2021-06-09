resource "aws_s3_bucket" "ca" {
  bucket = local.common_name
  acl    = "private"

  versioning {
    enabled = false
  }

  lifecycle {
    prevent_destroy = false
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        sse_algorithm = "AES256"
      }
    }
  }

  tags = merge(
    var.tags,
    {
      "Name" = local.common_name
    },
  )
}

data "aws_iam_policy_document" "acmpca_bucket_access" {
  statement {
    actions = [
      "s3:GetBucketAcl",
      "s3:GetBucketLocation",
      "s3:PutObject",
      "s3:PutObjectAcl",
    ]

    resources = [
      aws_s3_bucket.ca.arn,
      "${aws_s3_bucket.ca.arn}/*",
    ]

    principals {
      identifiers = ["acm-pca.amazonaws.com"]
      type        = "Service"
    }
  }
}

resource "aws_s3_bucket_policy" "ca" {
  bucket = aws_s3_bucket.ca.id
  policy = data.aws_iam_policy_document.acmpca_bucket_access.json
}

