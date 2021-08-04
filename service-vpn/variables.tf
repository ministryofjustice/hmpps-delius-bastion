variable "tags" {
  type    = map(string)
  default = {}
}

variable "region" {
}

variable "lb_account_id" {
}

variable "bastion_domain_zone" {
}

variable "remote_state_bucket_name" {
  description = "Terraform remote state bucket name"
}

variable "short_environment_identifier" {
}

variable "log_retention_days" {
  default = 14
}

variable "vpn_configs" {
  type = map
  default = {
    client_cidr_block     = "10.165.16.0/20"
    identity_provider_ssm = "moj-github-identity-provider"
    ssm_prefix            = "/hmpps/pki/vpn"
    deployer_key_ssm      = "tf-eu-west-2-hmpps-eng-dev-ssh-key"
    instance_type         = "m4.xlarge"
  }
}

variable "split_tunnel_enabled" {
  default     = true
  description = "Whether to enable split tunnelling"
  type        = bool
}

variable "additional_routes" {
  default     = []
  description = "A list of additional routes that should be attached to the Client VPN endpoint"

  type = list(object({
    destination_cidr_block = string
    description            = string
  }))
}

variable "additional_security_groups" {
  default     = []
  description = "List of security groups to attach to the client vpn network associations"
  type        = list(string)
}

variable "availability_zone" {
  type = map(string)
}

variable "authorization_rules" {
  type = list(object({
    name                 = string
    authorize_all_groups = bool
    description          = string
    target_network_cidr  = string
    access_group_id      = string
  }))
  description = "List of objects describing the authorization rules for the client vpn"
}
