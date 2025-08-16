# === BASIC VM CONFIGURATION ===
variable "name" {
  description = "VM name as displayed in Proxmox"
  type        = string
}

variable "vm_id" {
  description = "Unique VM identifier (100-111111)"
  type        = number
  validation {
    condition     = var.vm_id >= 100 && var.vm_id <= 111111
    error_message = "VM ID must be between 100 and 111111."
  }
}

variable "node_name" {
  description = "Proxmox node where VM will be created"
  type        = string
}

variable "description" {
  description = "VM description visible in Proxmox GUI"
  type        = string
  default     = "Managed by OpenTofu & GitHub Actions"
}

variable "tags" {
  description = "List of tags for VM organization"
  type        = list(string)
  default     = []
}

# === CLONE CONFIGURATION ===
variable "clone_vm_id" {
  description = "Source VM/template ID to clone from"
  type        = number
}

variable "clone_node_name" {
  description = "Node containing the source VM/template"
  type        = string
}

variable "clone_datastore_id" {
  description = "Datastore containing the source VM/template"
  type        = string
}

variable "full_clone" {
  description = "Create full clone (true) or linked clone (false)"
  type        = bool
  default     = true
}

# === CPU CONFIGURATION ===
variable "cpu_cores" {
  description = "Number of CPU cores to assign to VM"
  type        = number
  validation {
    condition     = var.cpu_cores >= 1 && var.cpu_cores <= 128
    error_message = "CPU cores must be between 1 and 128."
  }
}

variable "cpu_type" {
  description = "CPU model type for emulation"
  type        = string
  default     = "x86-64-v2-AES"
}

variable "hotplug_cpu" {
  description = "Enable CPU hotplug capability"
  type        = bool
  default     = false
}

variable "hotplugged_vcpu" {
  description = "Number of hotpluggable vCPUs (calculated if null)"
  type        = number
  default     = null
}

variable "max_cpu" {
  description = "Maximum CPU cores for hotplug (defaults to cpu_cores)"
  type        = number
  default     = null
}

variable "numa" {
  description = "Enable NUMA support"
  type        = bool
  default     = true
}

# === MEMORY CONFIGURATION ===
variable "memory" {
  description = "Base memory allocation in MB (dedicated memory)"
  type        = number
  validation {
    condition     = var.memory >= 64 && var.memory <= 4194304
    error_message = "Memory must be between 64 MB and 4 TB."
  }
}

variable "floating_memory" {
  description = "Maximum memory for ballooning in MB (null = same as memory, disabling ballooning)"
  type        = number
  default     = null
}

# === MACHINE TYPE ===
variable "machine_type" {
  description = "VM machine type (pc or q35)"
  type        = string
  default     = "pc"
}

variable "viommu" {
  description = "Virtual IOMMU type (empty for disabled)"
  type        = string
  default     = ""
}

# === STORAGE CONFIGURATION ===
variable "disk_size" {
  description = "Primary disk size in GB (null for diskless VM)"
  type        = number
  default     = null
  validation {
    condition     = var.disk_size == null || (var.disk_size >= 1 && var.disk_size <= 131072)
    error_message = "Disk size must be between 1 GB and 128 TB or null."
  }
}

variable "datastore_disk" {
  description = "Proxmox datastore for VM disks"
  type        = string
}

variable "iothread" {
  description = "Enable dedicated I/O thread for better disk performance"
  type        = bool
  default     = true
}

variable "ssd_emulation" {
  description = "Enable SSD emulation (guest OS sees disk as SSD)"
  type        = bool
  default     = true
}

variable "discard" {
  description = "Disk discard/TRIM setting"
  type        = string
  default     = "on"
}

# === NETWORK CONFIGURATION ===
variable "network_bridge" {
  description = "Proxmox network bridge"
  type        = string
  default     = "vmbr0"
}

variable "vlan_id" {
  description = "VLAN ID for network segmentation (required)"
  type        = number
  validation {
    condition     = var.vlan_id >= 1 && var.vlan_id <= 4094
    error_message = "VLAN ID must be between 1 and 4094."
  }
}

variable "enable_vlans" {
  description = "Enable VLAN support (disable if having SDN conflicts)"
  type        = bool
  default     = false
}

# === VM LIFECYCLE ===
variable "agent_enabled" {
  description = "Enable QEMU guest agent"
  type        = bool
  default     = true
}

variable "vm_reboot" {
  description = "Reboot VM after creation"
  type        = bool
  default     = false
}

# === PCI PASSTHROUGH ===
variable "hostpci" {
  description = "PCI device passthrough configuration"
  type = list(object({
    device  = string
    mapping = string
    pcie    = optional(bool)
    rombar  = optional(bool)
    xvga    = optional(bool)
  }))
  default = []
  validation {
    condition = alltrue([
      for pci in var.hostpci : 
      can(regex("^hostpci[0-9]+$", pci.device))
    ])
    error_message = "PCI device names must follow pattern 'hostpciN' where N is a number."
  }
}

# === CLOUD-INIT CONFIGURATION ===
variable "cloud_init_enabled" {
  description = "Enable cloud-init configuration"
  type        = bool
  default     = true
}

variable "cloud_init_datastore" {
  description = "Datastore for cloud-init drive (defaults to same as disk)"
  type        = string
  default     = null
}

variable "ssh_public_key" {
  description = "SSH public key for cloud-init user setup"
  type        = string
  default     = ""
}

variable "hostname" {
  description = "Hostname for cloud-init (defaults to VM name)"
  type        = string
  default     = ""
}

variable "domain" {
  description = "Domain name for FQDN"
  type        = string
  default     = "local"
}

variable "tailscale_authkey" {
  description = "Tailscale auth key for automatic connection"
  type        = string
  default     = ""
  sensitive   = true
}

variable "install_tailscale" {
  description = "Install and configure Tailscale"
  type        = bool
  default     = true
}

variable "install_docker" {
  description = "Install and configure Docker"
  type        = bool
  default     = true
}

variable "user_data_file_id" {
  description = "Cloud-init user data file ID (e.g., from proxmox_virtual_environment_file resource)"
  type        = string
  default     = null
}