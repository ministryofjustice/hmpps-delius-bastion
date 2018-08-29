# hmpps-delius-bastion

Repo for the delius bastion


## Peering with application VPC

Create a branch then add an entry to the list **bastion_peering_ids** in the file `env_configs/dev.tfvars` or appropriate env.

Format is `"{bastion peering id}, {vpc cidr block}, {environment name}"`
e.g.
```
"pcx-0ff5d735b31edffa7,10.161.4.0/23,delius-core-sandpit"
```

It's worth adding an output to the VPC Terraform to make it easier to get these values
e.g.
```
output "bastion_peering_id_string" {
  value = "${aws_vpc_peering_connection.bastion_peering.id},${aws_vpc.vpc.cidr_block},${local.environment_name}"
}
```
