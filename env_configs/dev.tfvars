bastion_domain_zone = "bastion-dev.probation.hmpps.dsd.io."

bastion_cidr_block = "10.161.98.0/25"

bastion_public_cidr = {
  az1 = "10.161.98.0/28"

  az2 = "10.161.98.16/28"

  az3 = "10.161.98.32/28"
}

# In the format of peering_id,subnet

## NOTE: Add new items to end of list.
## Items added or removed from middle of list will cause peering connections
## to be destroyed and recreated.

bastion_peering_ids = [
  "pcx-07dac042ba70d7994,10.161.128.0/25,hmpps-vcms-dev",
  "pcx-0ab3ee81af30c8dcb,10.161.128.128/25,hmpps-vcms-test",
  "pcx-0161b3c5419c6ddc1,10.161.64.0/24,hmpps-vcms-perf",
  "pcx-00efa04a17abcff11,10.161.65.0/24,hmpps-vcms-stage",
  "pcx-0a529881efe69540b,10.161.20.0/22,delius-core-dev",
  "pcx-088f1f4fb40cea44a,10.161.73.0/24,delius-new-tech-dev",
  "pcx-0cc5e82fe8f726785,10.162.0.0/20,delius-test",
  "pcx-020091becf6f4fc01,10.162.16.0/20,delius-perf",
  "pcx-0acaa20bf595e37a0,10.162.32.0/20,delius-stage",
]
