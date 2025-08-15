terraform {
  required_providers {
    vultr = {
      source = "vultr/vultr"
      version = "2.27.1"
    }
  }
}

provider "vultr" {
  api_key = var.vultr_api_key
}

module "firewall" {
  source = "../modules/firewall"

  firewall_groups = {
    prod = {
      description = "Production VPS firewall - Pangolin"
    }
  }

  firewall_rules = local.all_firewall_rules
}

module "my_instance" {
  source = "../modules/instance"
  vultr_api_key       = var.vultr_api_key
  username            = var.username
  hostname            = var.hostname
  domain              = var.domain
  tailscale_auth_key  = var.tailscale_auth_key
  ssh_key_name        = var.ssh_key_name
  ssh_pub_key         = var.ssh_pub_key
  region              = var.region
  os_id               = var.os_id
  firewall_group_id   = module.firewall.firewall_group_ids["prod"]
  backups_enabled     = var.backups_enabled
  backup_schedule     = var.backup_schedule
  script_name         = var.script_name
  instances           = var.instances
}
