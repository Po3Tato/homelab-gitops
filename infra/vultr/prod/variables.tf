variable "vultr_api_key" {
  description = "Vultr API key"
  type = string
  sensitive = true
}

# === BASE NAMING CONFIGURATION ===
variable "instance_basename" {
  description = "Base name for instances (generic for security)"
  type        = string
  default     = "instance"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}
variable "region" {
  description = "Default region for the instances"
  type = string
  default = "sea"
  validation {
    condition = contains([
      "ewr", "ord", "dfw", "sea", "lax", "atl", "mia", "yto", 
      "cdg", "ams", "lhr", "fra", "mad", "waw", "sto", "icn", 
      "nrt", "sgp", "syd", "mel", "blr", "del", "bom", "maa"
    ], var.region)
    error_message = "Region must be a valid Vultr region code. Common values: ord (Chicago), sea (Seattle), ewr (New Jersey), lax (Los Angeles)."
  }
}
variable "os_id" {
  description = "OS ID for the instances"
  type = number
  validation {
    condition = contains([
      2465, # Ubuntu 24.10 x64
      2284, # Ubuntu 24.04 x64
      1743, # Ubuntu 22.04 x64
      387,  # Ubuntu 20.04 x64
      215,  # Ubuntu 18.04 x64
      2136, # CentOS 9 Stream x64
      401,  # CentOS 8 Stream x64
      362,  # CentOS 7 x64
      2031, # Debian 12 x64
      1922, # Debian 11 x64
      427   # Debian 10 x64
    ], var.os_id)
    error_message = "OS ID must be a valid Vultr OS. Common values: 2465 (Ubuntu 24.10), 2284 (Ubuntu 24.04), 1743 (Ubuntu 22.04), 387 (Ubuntu 20.04)."
  }
}
variable "ssh_key_name" {
  description = "SSH key name"
  type = string
}
variable "ssh_pub_key" {
  description = "SSH public key for user access"
  type = string
}
variable "username" {
  description = "Username to be created on the instances"
  type = string
}
variable "tailscale_auth_key" {
  description = "Tailscale authentication key"
  type = string
  sensitive = true
}
variable "backups_enabled" {
  description = "Enable or disable backups"
  type = string
  default = "disabled"
  validation {
    condition = contains(["enabled", "disabled"], var.backups_enabled)
    error_message = "Backup must be either 'enabled' or 'disabled'."
  }
}
variable "backup_schedule" {
  description = "Backup schedule configuration"
  type = object({
    type = string
  })
  default = null
}
variable "script_name" {
  description = "Name of the startup script"
  type = string
  default = "startup_script"
}
variable "hostname" {
  description = "Hostname for the instance"
  type = string
}
variable "domain" {
  description = "Domain suffix for FQDN"
  type = string
  default = "mn-vps"
}
variable "instances" {
  description = "Map of instances to create with their specific configs"
  type = map(object({
    number = number
    plan = string
    region = string
    hostname = optional(string)
    tags = list(string)
  }))
}
