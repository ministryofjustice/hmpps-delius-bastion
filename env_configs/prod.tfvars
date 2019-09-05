bastion_domain_zone = "bastion-prod.probation.hmpps.dsd.io."

bastion_cidr_block = "10.160.98.0/25"

bastion_public_cidr = {
  az1 = "10.160.98.0/28"

  az2 = "10.160.98.16/28"

  az3 = "10.160.98.32/28"
}

bastion_private_cidr = {
  az1 = "10.160.98.64/27"

  az2 = "10.160.98.96/27"

  az3 = "10.160.98.48/28"
}

# In the format of peering_id,subnet

## NOTE: Add new items to end of list.
## Items added or removed from middle of list will cause peering connections
## to be destroyed and recreated.

bastion_peering_ids = [
  "pcx-00201b8d5b70f847b,10.160.65.0/24,vcms-preprod",
  "pcx-062639fa322e975bf,10.160.64.0/24,vcms-prod",
  "pcx-0a3ec95ee58916ddc,10.160.96.0/24,engineering-prod",
  "pcx-09157c7b0c3198eb5,10.160.0.0/20,delius-pre-prod",
  "pcx-03373232955f8d862,10.160.16.0/20,delius-prod",
  "pcx-0913df32be8acaa55,10.161.96.0/24,engineering-dev",
]
