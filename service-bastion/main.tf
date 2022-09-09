#-------------------------------------------------------------
### Getting the current vpc
#-------------------------------------------------------------
data "terraform_remote_state" "bastion_vpc" {
  backend = "s3"

  config = {
    bucket = var.remote_state_bucket_name
    key    = "bastion-vpc/terraform.tfstate"
    region = var.region
  }
}

#Provisioning SSH key

module "bastion_ssh_key" {
  source   = "git::https://github.com/ministryofjustice/hmpps-terraform-modules.git//modules//ssh_key?ref=terraform-0.12"
  keyname  = var.environment_identifier
  rsa_bits = "4096"
}

#
# Get the latest Amazon Linux ami
#
data "aws_ami" "hmpps" {
  most_recent = true

  filter {
    name   = "name"
    values = ["HMPPS Base CentOS master*"]
  }
  filter {
    name   = "root-device-type"
    values = ["ebs"]
  }

  owners = ["895523100917"]
}

resource "aws_instance" "bastion_instance" {
  ami                  = data.aws_ami.hmpps.id
  instance_type        = "t2.micro"
  key_name             = module.bastion_ssh_key.deployer_key
  subnet_id            = data.terraform_remote_state.bastion_vpc.outputs.bastion-public-subnet-az1
  iam_instance_profile = aws_iam_instance_profile.instance_profile.name

  vpc_security_group_ids = [
    data.terraform_remote_state.bastion_vpc.outputs.bastion_vpc_sg_id,
    data.terraform_remote_state.bastion_vpc.outputs.bastion_vpc_sg_outbound_id,
  ]

  tags = merge(
    var.tags,
    {
      "Name" = var.environment_name
    },
  )

  lifecycle {
    ignore_changes = [ami]
  }
}

resource "aws_eip" "bastion_eip" {
  instance = aws_instance.bastion_instance.id
  vpc      = true
  tags = merge(
    var.tags,
    {
      "Name" = var.environment_name
    },
  )
}

