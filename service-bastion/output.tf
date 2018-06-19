
output "bastion_instance" {
  value = "${aws_instance.bastion_instance.id}"
}

output "bastion_ip" {
  value = "${aws_eip.bastion_eip.public_ip}"
}

output "bastion_private_key" {
  value = "${module.bastion_ssh_key.private_key_pem}"
}