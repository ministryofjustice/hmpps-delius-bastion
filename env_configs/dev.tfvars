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

## NOTE: Add new items to end of list.
## Items added or removed from middle of list will cause peering connections
## to be destroyed and recreated.

bastion_peering_ids = [
  "pcx-0f0ed16544aacecb3,10.161.4.0/23,delius-core-sandpit",
  "pcx-07dac042ba70d7994,10.161.128.0/25,hmpps-vcms-dev",
  "pcx-0ab3ee81af30c8dcb,10.161.128.128/25,hmpps-vcms-test",
  "pcx-0161b3c5419c6ddc1,10.161.64.0/24,hmpps-vcms-perf",
  "pcx-00efa04a17abcff11,10.161.65.0/24,hmpps-vcms-stage",
  "pcx-0a529881efe69540b,10.161.20.0/22,delius-core-dev",
  "pcx-088f1f4fb40cea44a,10.161.73.0/24,delius-new-tech-dev",
]
