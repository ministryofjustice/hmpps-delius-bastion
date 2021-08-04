output "vpc" {
  value = {
    account_id           = data.aws_caller_identity.current.account_id
    id                   = module.bastion_vpc.vpc_id
    cidr                 = module.bastion_vpc.vpc_cidr
    public_cidr          = var.bastion_public_cidr
    private_cidr         = var.bastion_private_cidr
    peer_accepter_prefix = local.peer_accepter_prefix
  }
}

output "subnets" {
  value = {
    bastion-public-az1  = module.bastion-public-az1.subnetid
    bastion-public-az2  = module.bastion-public-az2.subnetid
    bastion-public-az3  = module.bastion-public-az3.subnetid
    bastion-private-az1 = module.bastion-private-az1.subnetid
    bastion-private-az2 = module.bastion-private-az2.subnetid
    bastion-private-az3 = module.bastion-private-az3.subnetid
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
    bastion-public-az1  = module.bastion-public-az1.routetableid
    bastion-public-az2  = module.bastion-public-az2.routetableid
    bastion-public-az3  = module.bastion-public-az3.routetableid
    bastion-private-az1 = module.bastion-private-az1.routetableid
    bastion-private-az2 = module.bastion-private-az2.routetableid
    bastion-private-az3 = module.bastion-private-az3.routetableid
  }
}

output "bastion_vpc_account_id" {
  value = data.aws_caller_identity.current.account_id
}

output "bastion_vpc_id" {
  value = module.bastion_vpc.vpc_id
}

output "bastion_vpc_cidr" {
  value = module.bastion_vpc.vpc_cidr
}

output "bastion_public_cidr" {
  value = var.bastion_public_cidr
}

output "bastion_remote_state_bucket_name" {
  value = var.remote_state_bucket_name
}

output "bastion_vpc_sg_id" {
  value = aws_security_group.bastion-vpc-sg.id
}

output "bastion_vpc_sg_outbound_id" {
  value = aws_security_group.bastion-vpc-sg-outbound.id
}

output "vpcflowlog_id" {
  value = module.bastion_vpcflowlog.vpc_flow_log_id
}

output "bastion-public-subnet-az1" {
  value = module.bastion-public-az1.subnetid
}

output "bastion-public-subnet-az2" {
  value = module.bastion-public-az2.subnetid
}

output "bastion-public-subnet-az3" {
  value = module.bastion-public-az3.subnetid
}

output "public-routetable-az1" {
  value = module.bastion-public-az1.routetableid
}

output "public-routetable-az2" {
  value = module.bastion-public-az2.routetableid
}

output "public-routetable-az3" {
  value = module.bastion-public-az3.routetableid
}

##
output "bastion-private-subnet-az1" {
  value = module.bastion-private-az1.subnetid
}

output "bastion-private-subnet-az2" {
  value = module.bastion-private-az2.subnetid
}

output "bastion-private-subnet-az3" {
  value = module.bastion-private-az3.subnetid
}

output "private-routetable-az1" {
  value = module.bastion-private-az1.routetableid
}

output "private-routetable-az2" {
  value = module.bastion-private-az2.routetableid
}

output "private-routetable-az3" {
  value = module.bastion-private-az3.routetableid
}

# S3 Buckets
output "s3-config-bucket" {
  value = module.bastion_s3config_bucket.s3_bucket_name
}

# KMS Key
output "kms_arn" {
  value = module.bastion_kms_key.kms_arn
}

# SSH KEY
#output "ssh_public_key" {
#  value = "${module.ssh_key.public_key_openssh}"
#}
#output "ssh_private_key_pem" {
#  sensitive = true
#  value     = "${module.ssh_key.private_key_pem}"
#}
#output "ssh_deployer_key" {
#  value = "${module.ssh_key.deployer_key}"
#}

output "public_acm_info" {
  value = {
    arn         = aws_acm_certificate.public_zone.arn
    id          = aws_acm_certificate.public_zone.id
    domain_name = aws_acm_certificate.public_zone.domain_name
  }
}
