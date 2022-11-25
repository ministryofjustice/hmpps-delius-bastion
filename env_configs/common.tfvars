# VPC variables
cloudwatch_log_retention = 14

availability_zone = {
  az1 = "eu-west-2a"

  az2 = "eu-west-2b"

  az3 = "eu-west-2c"
}

lb_account_id = "652711504416"

# CIDR range of eng_dev VPC hosting jenkins, jira etc. This used to allow jenkins instances to reach dev and prod bastion 
eng_dev_vpc_cidr = "10.161.96.0/24"