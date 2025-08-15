# Firewall configuration
# This file organizes firewall rules for better maintainability

locals {
  # Standard web traffic rules
  web_rules = {
    http = {
      firewall_group_name = "prod"
      protocol            = "tcp"
      ip_type             = "v4"
      subnet              = "0.0.0.0"
      subnet_size         = 0
      port                = "80"
      notes               = "HTTP"
    }
    
    https = {
      firewall_group_name = "prod"
      protocol            = "tcp"
      ip_type             = "v4"
      subnet              = "0.0.0.0"
      subnet_size         = 0
      port                = "443"
      notes               = "HTTPS"
    }
  }
  
  # VPN rules
  vpn_rules = {
    tailscale = {
      firewall_group_name = "prod"
      protocol            = "udp"
      ip_type             = "v4"
      subnet              = "0.0.0.0"
      subnet_size         = 0
      port                = "41641"
      notes               = "Tailscale"
    }
    
    wireguard = {
      firewall_group_name = "prod"
      protocol            = "udp"
      ip_type             = "v4"
      subnet              = "0.0.0.0"
      subnet_size         = 0
      port                = "51820"
      notes               = "WireGuard"
    }
  }
  
  # Combine all rules
  all_firewall_rules = merge(
    local.web_rules,
    local.vpn_rules
  )
}