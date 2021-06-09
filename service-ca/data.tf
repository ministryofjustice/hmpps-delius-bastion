#-------------------------------------------------------------
### Getting aws_caller_identity
#-------------------------------------------------------------
data "aws_caller_identity" "current" {
}

data "aws_partition" "current" {}
