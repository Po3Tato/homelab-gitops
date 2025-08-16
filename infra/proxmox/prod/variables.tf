# === BASE NAMING CONFIGURATION ===
variable "vm_basename" {
  description = "Base name for VMs"
  type        = string
  default     = "vm"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

# === VM CONFIGURATION TEMPLATES ===
variable "vm_config_templates" {
  description = "VM configuration templates"
  type = map(object({
    cpu_cores         = number
    memory            = number
    disk_size         = number
    tags              = list(string)
    tailscale_authkey = string
    description       = string
    node_number       = string
  }))
  default = {
    "1" = {
      cpu_cores         = 2
      memory            = 4096
      disk_size         = 32
      tags              = ["github-actions", "prod"]
      tailscale_authkey = "controlplane"
      description       = "Production VM - Control Plane Configuration"
      node_number       = "1"
    }
    "2" = {
      cpu_cores         = 4
      memory            = 8192
      disk_size         = 64
      tags              = ["github-actions", "prod"]
      tailscale_authkey = "workers"
      description       = "Production VM - Worker Node Configuration"
      node_number       = "2"
    }
  }
}

# === VM DEPLOYMENT CONFIGURATION ===
variable "vm_deployments" {
  description = "Number of VMs to deploy for each configuration template"
  type = map(object({
    count           = number
    config_template = string
    vm_id_start     = number
    name_prefix     = string
    node_number     = string 
  }))
  default = {
    vm = {
      count           = 1
      config_template = "1"
      vm_id_start     = 201
      name_prefix     = "node01"
      node_number     = "1"
    }
    
    vm = {
      count           = 3
      config_template = "2"
      vm_id_start     = 210
      name_prefix     = "node02"
      node_number     = "1"
    }
  }
}

# === INFRASTRUCTURE SETTINGS ===
variable "datastore_disk" {
  description = "Datastore for VM disks"
  type        = string
}

variable "network_bridge" {
  description = "Network bridge to use"
  type        = string
  default     = "vmbr0"
}

# === PROXMOX API CONFIGURATION ===
variable "virtual_environment_endpoint" {
  description = "Proxmox API endpoint"
  type        = string
}

variable "virtual_environment_api_token" {
  description = "Proxmox API token"
  type        = string
  sensitive   = true
}

# === VM LIFECYCLE DEFAULTS ===
variable "vm_reboot" {
  description = "Reboot VM after creation"
  type        = bool
  default     = false
}

variable "agent_enabled" {
  description = "Enable QEMU guest agent"
  type        = bool
  default     = true
}

# === CPU HOTPLUG DEFAULTS ===
variable "default_hotplug_cpu" {
  description = "Default setting for CPU hotplug"
  type        = bool
  default     = true
}

variable "default_max_cpu" {
  description = "Default maximum CPU cores for hotplug"
  type        = number
  default     = 4
}

variable "default_hotplugged_vcpu" {
  description = "Default number of hotplugged vCPUs if not specified per-VM"
  type        = number
  default     = 1
}

# === MACHINE TYPE DEFAULTS ===
variable "default_machine_type" {
  description = "Default machine type for VMs"
  type        = string
  default     = "pc"
  validation {
    condition     = var.default_machine_type == null || contains(["pc", "q35"], var.default_machine_type)
    error_message = "Machine type must be 'pc' or 'q35'."
  }
}

variable "default_viommu" {
  description = "Default vIOMMU setting (empty string for disabled)"
  type        = string
  default     = ""
  validation {
    condition     = var.default_viommu == null || contains(["", "virtio", "intel"], var.default_viommu)
    error_message = "VIOMMU must be empty, 'virtio', or 'intel'."
  }
}

# === CLONE DEFAULTS ===
variable "default_full_clone" {
  description = "Default setting for full clone or linked clone"
  type        = bool
  default     = true
}

# === CPU DEFAULTS ===
variable "default_cpu_type" {
  description = "CPU model type for emulation"
  type        = string
  default     = "x86-64-v2-AES"
}

variable "default_numa" {
  description = "Default NUMA setting if not specified per-VM"
  type        = bool
  default     = true
}

# === STORAGE DEFAULTS ===
variable "default_iothread" {
  description = "Default iothread setting for disks if not specified per-VM"
  type        = bool
  default     = true
}

variable "default_ssd_emulation" {
  description = "Default SSD emulation setting for disks if not specified per-VM"
  type        = bool
  default     = true
}

variable "default_discard" {
  description = "Disk discard/TRIM setting"
  type        = string
  default     = "on"
}

# === TEMPLATE MAPPINGS ===
variable "proxmox_templates" {
  description = "Map of template numbers to VM IDs"
  type        = map(number)
  default = {}
}

variable "proxmox_nodes" {
  description = "Map of node numbers to node names"
  type        = map(string)
  default = {}
}

variable "vlan_prod" {
  description = "Production VLAN ID"
  type        = number
}

# === CLOUD-INIT CONFIGURATION ===
variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
  default     = ""
}

variable "tailscale_authkeys" {
  description = "Map of Tailscale auth keys by type"
  type        = map(string)
  default     = {}
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name for FQDN"
  type        = string
  default     = "homelab.local"
}