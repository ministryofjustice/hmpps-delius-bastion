output "vpc" {
  value = {
    account_id = data.aws_caller_identity.current.account_id
    id         = module.vpn_vpc.vpc_id
    cidr       = module.vpn_vpc.vpc_cidr
  }
}

output "subnets" {
  value = {
    vpn-public-az1  = module.vpn-public-az1.subnetid
    vpn-public-az2  = module.vpn-public-az2.subnetid
    vpn-public-az3  = module.vpn-public-az3.subnetid
    vpn-private-az1 = module.vpn-private-az1.subnetid
    vpn-private-az2 = module.vpn-private-az2.subnetid
    vpn-private-az3 = module.vpn-private-az3.subnetid
  }
}

output "subnet_cidrs" {
  value = {
    vpn-public-az1  = module.vpn-public-az1.subnet_cidr
    vpn-public-az2  = module.vpn-public-az2.subnet_cidr
    vpn-public-az3  = module.vpn-public-az3.subnet_cidr
    vpn-private-az1 = module.vpn-private-az1.subnet_cidr
    vpn-private-az2 = module.vpn-private-az2.subnet_cidr
    vpn-private-az3 = module.vpn-private-az3.subnet_cidr
    vpn-db-az1      = module.vpn-db-az1.subnet_cidr
    vpn-db-az2      = module.vpn-db-az2.subnet_cidr
    vpn-db-az3      = module.vpn-db-az3.subnet_cidr
  }
}

output "natgateway" {
  value = {
    az1 = module.common-nat-az1.natid
    az2 = module.common-nat-az2.natid
    az3 = module.common-nat-az3.natid
  }
}

output "routetable" {
  value = {
    vpn-public-az1  = module.vpn-public-az1.routetableid
    vpn-public-az2  = module.vpn-public-az2.routetableid
    vpn-public-az3  = module.vpn-public-az3.routetableid
    vpn-private-az1 = module.vpn-private-az1.routetableid
    vpn-private-az2 = module.vpn-private-az2.routetableid
    vpn-private-az3 = module.vpn-private-az3.routetableid
    vpn-db-az1      = module.vpn-db-az1.routetableid
    vpn-db-az2      = module.vpn-db-az2.routetableid
    vpn-db-az3      = module.vpn-db-az3.routetableid
  }
}

output "vpn_vpc_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "vpn_vpc_id" {
  value = module.vpn_vpc.vpc_id
}

output "vpn_vpc_cidr" {
  value = module.vpn_vpc.vpc_cidr
}


output "vpn_vpc_sg_id" {
  value = aws_security_group.vpn-vpc-sg.id
}

output "vpn_vpc_sg_outbound_id" {
  value = aws_security_group.vpn-vpc-sg-outbound.id
}

output "vpcflowlog_id" {
  value = module.vpn_vpcflowlog.vpc_flow_log_id
}

output "vpn-public-subnet-az1" {
  value = module.vpn-public-az1.subnetid
}

output "vpn-public-subnet-az2" {
  value = module.vpn-public-az2.subnetid
}

output "vpn-public-subnet-az3" {
  value = module.vpn-public-az3.subnetid
}

output "public-routetable-az1" {
  value = module.vpn-public-az1.routetableid
}

output "public-routetable-az2" {
  value = module.vpn-public-az2.routetableid
}

output "public-routetable-az3" {
  value = module.vpn-public-az3.routetableid
}

##
output "vpn-private-subnet-az1" {
  value = module.vpn-private-az1.subnetid
}

output "vpn-private-subnet-az2" {
  value = module.vpn-private-az2.subnetid
}

output "vpn-private-subnet-az3" {
  value = module.vpn-private-az3.subnetid
}

##
output "vpn-db-subnet-az1" {
  value = module.vpn-db-az1.subnetid
}

output "vpn-db-subnet-az2" {
  value = module.vpn-db-az2.subnetid
}

output "vpn-db-subnet-az3" {
  value = module.vpn-db-az3.subnetid
}

output "private-routetable-az1" {
  value = module.vpn-private-az1.routetableid
}

output "private-routetable-az2" {
  value = module.vpn-private-az2.routetableid
}

output "private-routetable-az3" {
  value = module.vpn-private-az3.routetableid
}

output "db-routetable-az1" {
  value = module.vpn-db-az1.routetableid
}

output "db-routetable-az2" {
  value = module.vpn-db-az2.routetableid
}

output "db-routetable-az3" {
  value = module.vpn-db-az3.routetableid
}

