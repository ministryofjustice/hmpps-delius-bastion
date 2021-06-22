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
  "pcx-09157c7b0c3198eb5,10.160.0.0/20,delius-pre-prod",
  "pcx-03373232955f8d862,10.160.16.0/20,delius-prod",
  "pcx-0913df32be8acaa55,10.161.96.0/24,engineering-dev",
  "pcx-0a5d2629588eaeea7,10.160.32.0/20,delius-stage",
  "pcx-074d66c2c52980e1b,10.160.48.0/20,delius-perf",
  "pcx-094457b5beefa8e9e,10.163.32.0/20,cr-jira-prod",
  "pcx-0c3e9233f22ecd688,10.163.64.0/20,cr-jitbit-prod",
  "pcx-026c23b1b35a09e0910.163.96.0/20,cr-unpaid-work-prod"
]
