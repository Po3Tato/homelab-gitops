terraform {
  required_providers {
    vultr = {
      source  = "vultr/vultr"
      version = "~> 2.26.0"
    }
  }
  required_version = ">= 1.0"
}

resource "vultr_firewall_group" "groups" {
  for_each = var.firewall_groups

  description = each.value.description
}

resource "vultr_firewall_rule" "rules" {
  for_each = var.firewall_rules

  firewall_group_id = vultr_firewall_group.groups[each.value.firewall_group_name].id
  protocol          = each.value.protocol
  ip_type           = each.value.ip_type
  subnet            = each.value.subnet
  subnet_size       = each.value.subnet_size
  port              = each.value.port
  notes             = each.value.notes
  source            = each.value.source
}