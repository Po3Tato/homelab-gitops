variable "hostname" {
  description = "Name for the LXC container"
  type        = string
}

variable "vm_id" {
  description = "Container ID"
  type        = number
}

variable "node_name" {
  description = "Proxmox node name"
  type        = string
}

variable "description" {
  description = "Container description"
  type        = string
  default     = null
}

variable "tags" {
  description = "Tags to assign to the container"
  type        = list(string)
  default     = ["opentofu", "lxc"]
}

variable "pool_id" {
  description = "Pool ID to assign the container to"
  type        = string
  default     = null
}

variable "unprivileged" {
  description = "Whether the container runs as unprivileged"
  type        = bool
  default     = true
}

variable "started" {
  description = "Whether to start the container"
  type        = bool
  default     = true
}

variable "start_on_boot" {
  description = "Start container on host boot"
  type        = bool
  default     = true
}

variable "protection" {
  description = "Protect container from accidental deletion"
  type        = bool
  default     = false
}

variable "template" {
  description = "Whether to create a template"
  type        = bool
  default     = false
}

# Clone configuration
variable "clone" {
  description = "Clone configuration"
  type = object({
    vm_id        = number
    node_name    = optional(string)
    datastore_id = optional(string)
  })
  default = null
}

# Operating System
variable "template_file_id" {
  description = "Template file ID for the container OS"
  type        = string
}

variable "os_type" {
  description = "Operating system type"
  type        = string
  default     = "ubuntu"
  validation {
    condition = contains([
      "alpine", "archlinux", "centos", "debian", "devuan",
      "fedora", "gentoo", "nixos", "opensuse", "ubuntu", "unmanaged"
    ], var.os_type)
    error_message = "Invalid OS type specified. Valid values: alpine, archlinux, centos, debian, devuan, fedora, gentoo, nixos, opensuse, ubuntu, unmanaged."
  }
}

# CPU Configuration
variable "cpu_architecture" {
  description = "CPU architecture"
  type        = string
  default     = "amd64"
  validation {
    condition = var.cpu_architecture == null ? true : contains(["amd64", "arm64", "armhf", "i386"], var.cpu_architecture)
    error_message = "CPU architecture must be one of: amd64, arm64, armhf, i386."
  }
}

variable "cpu_cores" {
  description = "Number of CPU cores"
  type        = number
  default     = 1
}

variable "cpu_units" {
  description = "CPU units (relative weight)"
  type        = number
  default     = 1024
  validation {
    condition = var.cpu_units == null ? true : (var.cpu_units >= 8 && var.cpu_units <= 500000)
    error_message = "CPU units must be between 8 and 500000."
  }
}

# Memory Configuration
variable "memory" {
  description = "Dedicated memory in MB"
  type        = number
  default     = 512
}

variable "swap" {
  description = "Swap memory in MB"
  type        = number
  default     = 0
}

# Disk Configuration
variable "datastore_disk" {
  description = "Datastore for container root disk"
  type        = string
}

variable "disk_size" {
  description = "Root disk size in GB"
  type        = number
  default     = 4
}

# Network Configuration
variable "default_bridge" {
  description = "Default network bridge"
  type        = string
  default     = "vmbr0"
}

variable "network_interfaces" {
  description = "List of network interfaces"
  type = list(object({
    name        = string
    bridge      = optional(string)
    enabled     = optional(bool)
    firewall    = optional(bool)
    mac_address = optional(string)
    mtu         = optional(number)
    rate_limit  = optional(number)
    vlan_id     = optional(number)
  }))
  default = [{
    name = "eth0"
  }]
}

# Initialization Configuration
variable "initialization" {
  description = "Container initialization configuration"
  type = object({
    dns = optional(object({
      domain  = optional(string)
      servers = optional(list(string))
    }))
    ip_configs = optional(list(object({
      ipv4 = optional(object({
        address = string
        gateway = optional(string)
      }))
      ipv6 = optional(object({
        address = string
        gateway = optional(string)
      }))
    })))
    user_account = optional(object({
      keys     = optional(list(string))
      password = optional(string)
    }))
  })
  default = null
}

# Mount Points
variable "mount_points" {
  description = "List of mount points"
  type = list(object({
    path          = string
    volume        = string
    size          = optional(string)
    acl           = optional(bool)
    backup        = optional(bool)
    quota         = optional(bool)
    read_only     = optional(bool)
    replicate     = optional(bool)
    shared        = optional(bool)
    mount_options = optional(list(string))
  }))
  default = []
}

# Device Passthrough
variable "device_passthrough" {
  description = "List of devices to pass through"
  type = list(object({
    path       = string
    deny_write = optional(bool)
    gid        = optional(number)
    uid        = optional(number)
    mode       = optional(string)
  }))
  default = []
}

# Features
variable "nesting" {
  description = "Enable container nesting"
  type        = bool
  default     = false
}

variable "fuse" {
  description = "Enable FUSE mounts"
  type        = bool
  default     = false
}

variable "keyctl" {
  description = "Enable keyctl() system call"
  type        = bool
  default     = false
}

variable "mount_types" {
  description = "Allowed mount types"
  type        = list(string)
  default     = []
  validation {
    condition = var.mount_types == null ? true : alltrue([
      for mt in (var.mount_types != null ? var.mount_types : []) : contains(["cifs", "nfs"], mt)
    ])
    error_message = "Mount types must be 'cifs' or 'nfs'."
  }
}

# Console Configuration
variable "console_enabled" {
  description = "Enable console device"
  type        = bool
  default     = true
}

variable "console_type" {
  description = "Console type"
  type        = string
  default     = "tty"
  validation {
    condition = var.console_type == null ? true : contains(["console", "shell", "tty"], var.console_type)
    error_message = "Console type must be one of: console, shell, tty."
  }
}

variable "console_tty_count" {
  description = "Number of TTY devices"
  type        = number
  default     = 2
}

# Startup Configuration
variable "startup" {
  description = "Startup and shutdown behavior"
  type = object({
    order      = number
    up_delay   = optional(number)
    down_delay = optional(number)
  })
  default = null
}

# Hook Script
variable "hook_script_file_id" {
  description = "Hook script file ID"
  type        = string
  default     = null
}

# Timeouts
variable "timeout_create" {
  description = "Timeout for creating container (seconds)"
  type        = number
  default     = 1800
}

variable "timeout_clone" {
  description = "Timeout for cloning container (seconds)"
  type        = number
  default     = 1800
}

variable "timeout_delete" {
  description = "Timeout for deleting container (seconds)"
  type        = number
  default     = 60
}

variable "timeout_update" {
  description = "Timeout for updating container (seconds)"
  type        = number
  default     = 1800
}
