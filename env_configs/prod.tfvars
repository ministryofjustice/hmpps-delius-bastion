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

bastion_cidr_block = "10.160.98.0/25"

bastion_public_cidr = {
  az1 = "10.160.98.0/28"

  az2 = "10.160.98.16/28"

  az3 = "10.160.98.32/28"
}

# In the format of peering_id,subnet

## NOTE: Add new items to end of list.
## Items added or removed from middle of list will cause peering connections
## to be destroyed and recreated.

bastion_peering_ids = [
]
