# This is used for ALB logs to S3 bucket.
# This is fixed for each region. if region changes, this changes
lb_account_id = "652711504416"

# VPC variables
cloudwatch_log_retention = 14

availability_zone = {
  az1 = "eu-west-2a"

  az2 = "eu-west-2b"

  az3 = "eu-west-2c"
}

bastion_cidr_block = "10.161.98.0/25"

bastion_public_cidr = {
  az1 = "10.161.98.0/28"

  az2 = "10.161.98.16/28"

  az3 = "10.161.98.32/28"
}

# In the format of peering_id,subnet

bastion_peering_ids = ["pcx-0d6c272945384bc78,10.161.128.128/25"]
