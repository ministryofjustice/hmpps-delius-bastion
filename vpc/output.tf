output "bastion_vpc_id" {
  value = "${module.vpc.vpc_id}"
}

output "bastion_vpc_cidr" {
  value = "${module.vpc.vpc_cidr}"
}

output "bastion_vpc_sg_id" {
  value = "${aws_security_group.vpc-sg.id}"
}

output "bastion_vpc_sg_outbound_id" {
  value = "${aws_security_group.vpc-sg-outbound.id}"
}

output "vpcflowlog_id" {
  value = "${module.vpcflowlog.vpc_flow_log_id}"
}

output "bastion-public-subnet-az1" {
  value = "${module.bastion-public-az1.subnetid}"
}

output "bastion-public-subnet-az2" {
  value = "${module.bastion-public-az2.subnetid}"
}

output "bastion-public-subnet-az3" {
  value = "${module.bastion-public-az3.subnetid}"
}

output "public-routetable-az1" {
  value = "${module.bastion-public-az1.routetableid}"
}

output "public-routetable-az2" {
  value = "${module.bastion-public-az2.routetableid}"
}

output "public-routetable-az3" {
  value = "${module.bastion-public-az3.routetableid}"
}

# S3 Buckets
output "s3-config-bucket" {
  value = "${module.s3config_bucket.s3_bucket_name}"
}

# KMS Key
output "kms_arn" {
  value = "${module.kms_key.kms_arn}"
}

# SSH KEY
output "ssh_public_key" {
  value = "${module.ssh_key.public_key_openssh}"
}

output "ssh_private_key_pem" {
  sensitive = true
  value     = "${module.ssh_key.private_key_pem}"
}

output "ssh_deployer_key" {
  value = "${module.ssh_key.deployer_key}"
}
