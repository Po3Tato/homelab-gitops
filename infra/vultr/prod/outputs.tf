output "instance_ips" {
  description = "The IPs of the created instances"
  value       = module.my_instance.instance_ips
}

output "instance_hostnames" {
  description = "The hostnames of the created instances"
  value       = module.my_instance.instance_hostnames
}

output "firewall_group_id" {
  description = "ID of the production firewall group"
  value       = module.firewall.firewall_group_ids["prod"]
}

output "firewall_rules" {
  description = "Details of all firewall rules"
  value       = module.firewall.firewall_rules
}
