variable "firewall_groups" {
  description = "Map of firewall groups to create"
  type = map(object({
    description = string
  }))
  default = {}
}

variable "firewall_rules" {
  description = "Map of firewall rules to create"
  type = map(object({
    firewall_group_name = string
    protocol            = string
    ip_type             = string
    subnet              = string
    subnet_size         = number
    port                = optional(string)
    notes               = optional(string)
    source              = optional(string)
  }))
  default = {}
}