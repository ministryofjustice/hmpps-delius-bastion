bastion_domain_zone = "bastion-dev.probation.hmpps.dsd.io."
bastion_domain_name = "bastion-dev.probation.hmpps.dsd.io"

bastion_cidr_block = "10.161.98.0/25"

bastion_public_cidr = {
  az1 = "10.161.98.0/28"

  az2 = "10.161.98.16/28"

  az3 = "10.161.98.32/28"
}

bastion_private_cidr = {
  az1 = "10.161.98.64/27"

  az2 = "10.161.98.96/27"

  az3 = "10.161.98.48/28"
}

# In the format of peering_id,subnet

## NOTE: Add new items to end of list.
## Items added or removed from middle of list will cause peering connections
## to be destroyed and recreated.

bastion_peering_ids = [
  "pcx-07dac042ba70d7994,10.161.128.0/25,hmpps-vcms-dev",
  "pcx-0ab3ee81af30c8dcb,10.161.128.128/25,hmpps-vcms-test",
  "pcx-089ec396b50a4662b,10.161.20.0/22,delius-core-dev",
  "pcx-0cc5e82fe8f726785,10.162.0.0/20,delius-test",
  "pcx-0d129c7968ddb1a26,10.161.4.0/22,delius-core-sandpit",
  "pcx-097229defd468ba0e,10.161.80.0/22,alfresco-dev",
  "pcx-08e9c692686409f51,10.161.96.0/24,engineering-dev",
  "pcx-0ffe096b1766c58f8,10.162.96.0/20,delius-training",
  "pcx-0a25f976d7b9b4c4a,10.162.32.0/20,delius-mis-dev",
  "pcx-03cd4edb021407db0,10.163.16.0/20,cr-jira-dev",
  "pcx-0608510cfe71433df,10.163.48.0/20,cr-jitbit-dev",
  "pcx-09d78b17b7f2cf70c,10.163.80.0/20,cr-unpaid-work-dev",
  "pcx-02148189febfa5fd4,10.164.48.0/20,cr-jitbit-preprod",
  "pcx-05838fcaf998f7a50,10.165.48.0/20,cr-jitbit-training"
]

vpn_cidr_block = "10.165.32.0/20"

vpn_peering_ids = [
  "pcx-04a11bf40fd7eeb42,10.161.80.0/22,alfresco-dev",
  "pcx-017dd12e43992e944,10.163.48.0/20,cr-jitbit-dev",
  "pcx-07289fb9d244ca04f,10.164.48.0/20,cr-jitbit-preprod"
]

authorization_rules = [
  {
    name                 = "alfresco-dev"
    authorize_all_groups = true
    description          = "Alfresco dev"
    target_network_cidr  = "10.161.80.0/22"
    access_group_id      = "S-1-5-21-3344382240-1056723541-2538802388-1144"
  },
  {
    name                 = "vpn-dev"
    authorize_all_groups = true
    description          = "Bastion dev"
    target_network_cidr  = "10.165.32.0/20"
    access_group_id      = "S-1-5-21-3344382240-1056723541-2538802388-1613" #vpn_admins
  },
  {
    name                 = "cr-jitbit-dev"
    authorize_all_groups = true
    description          = "CR Jitbit dev"
    target_network_cidr  = "10.163.48.0/20"
    access_group_id      = "S-1-5-21-3344382240-1056723541-2538802388-1147"
  }
]

additional_routes = [
  {
    destination_cidr_block = "10.161.80.0/22"
    description            = "Alfresco dev"
  },
  {
    destination_cidr_block = "10.163.48.0/20"
    description            = "CR Jitbit dev"
  }
]
