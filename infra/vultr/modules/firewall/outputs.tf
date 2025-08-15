output "firewall_groups" {
  description = "Map of created firewall groups"
  value = {
    for name, group in vultr_firewall_group.groups : name => {
      id              = group.id
      description     = group.description
      date_created    = group.date_created
      date_modified   = group.date_modified
      instance_count  = group.instance_count
      max_rule_count  = group.max_rule_count
      rule_count      = group.rule_count
    }
  }
}

output "firewall_group_ids" {
  description = "Map of firewall group names to their IDs"
  value       = { for name, group in vultr_firewall_group.groups : name => group.id }
}

output "firewall_rules" {
  description = "Map of created firewall rules"
  value = {
    for name, rule in vultr_firewall_rule.rules : name => {
      id                = rule.id
      firewall_group_id = rule.firewall_group_id
      protocol          = rule.protocol
      ip_type           = rule.ip_type
      subnet            = rule.subnet
      subnet_size       = rule.subnet_size
      port              = rule.port
      notes             = rule.notes
    }
  }
}