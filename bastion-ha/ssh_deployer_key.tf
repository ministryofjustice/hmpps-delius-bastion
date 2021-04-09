resource "tls_private_key" "ssh_deployer_key" {
  algorithm = "RSA"
  rsa_bits  = "4096"
}

resource "aws_key_pair" "ssh_deployer_key" {
  key_name   = "${var.environment}-bastion-ha-ssh-key"
  public_key = tls_private_key.ssh_deployer_key.public_key_openssh
}
