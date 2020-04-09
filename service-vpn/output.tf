
output "vpn_instance" {
  value = "${aws_instance.vpn_instance.id}"
}

output "vpn_ip" {
  value = "${aws_eip.vpn_eip.public_ip}"
}

output "vpn_private_key" {
  value     = "${module.vpn_ssh_key.private_key_pem}"
  sensitive = true
}
