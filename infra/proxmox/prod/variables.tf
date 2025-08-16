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

# === INFRASTRUCTURE MAPPINGS ===
variable "node_name" {
  description = "Primary Proxmox node name"
  type        = string
  default     = ""
}

# === VM DEPLOYMENT CONFIGURATION ===
# Controlplane VMs
variable "controlplane_count" {
  description = "Number of controlplane VMs to deploy"
  type        = number
  default     = 1
}

variable "controlplane_vm_id_start" {
  description = "Starting VM ID for controlplane VMs"
  type        = number
  default     = 500
}

variable "controlplane_cpu_cores" {
  description = "CPU cores for controlplane VMs"
  type        = number
  default     = 2
}

variable "controlplane_memory" {
  description = "Memory (MB) for controlplane VMs"
  type        = number
  default     = 4096
}

variable "controlplane_disk_size" {
  description = "Disk size (GB) for controlplane VMs"
  type        = number
  default     = 32
}

variable "controlplane_node_number" {
  description = "Proxmox node number for controlplane VMs"
  type        = string
  default     = "1"
}

variable "controlplane_vlan_id" {
  description = "VLAN ID for controlplane VMs (required)"
  type        = number
}

# Worker VMs
variable "workers_count" {
  description = "Number of worker VMs to deploy"
  type        = number
  default     = 2
}

variable "workers_vm_id_start" {
  description = "Starting VM ID for worker VMs"
  type        = number
  default     = 550
}

variable "workers_cpu_cores" {
  description = "CPU cores for worker VMs"
  type        = number
  default     = 4
}

variable "workers_memory" {
  description = "Memory (MB) for worker VMs"
  type        = number
  default     = 8192
}

variable "workers_disk_size" {
  description = "Disk size (GB) for worker VMs"
  type        = number
  default     = 64
}

variable "workers_node_number" {
  description = "Proxmox node number for worker VMs"
  type        = string
  default     = "2"
}

variable "workers_vlan_id" {
  description = "VLAN ID for worker VMs"
  type        = number
}

# === INFRASTRUCTURE SETTINGS ===
variable "datastore_disk" {
  description = "Datastore for VM disks"
  type        = string
}


variable "network_bridge" {
  description = "Network bridge to use"
  type        = string
}

variable "enable_vlans" {
  description = "Enable VLAN support"
  type        = bool
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
}

variable "agent_enabled" {
  description = "Enable QEMU guest agent"
  type        = bool
}

# === CPU HOTPLUG DEFAULTS ===
variable "default_hotplug_cpu" {
  description = "Default setting for CPU hotplug"
  type        = bool
}

variable "default_max_cpu" {
  description = "Default maximum CPU cores for hotplug"
  type        = number
}

variable "default_hotplugged_vcpu" {
  description = "Default number of hotplugged vCPUs if not specified per-VM"
  type        = number
}

# === MACHINE TYPE DEFAULTS ===
variable "default_machine_type" {
  description = "Default machine type for VMs"
  type        = string
  validation {
    condition     = var.default_machine_type == null || contains(["pc", "q35"], var.default_machine_type)
    error_message = "Machine type must be 'pc' or 'q35'."
  }
}

variable "default_viommu" {
  description = "Default vIOMMU setting"
  type        = string
  validation {
    condition     = var.default_viommu == null || contains(["", "virtio", "intel"], var.default_viommu)
    error_message = "VIOMMU must be empty, 'virtio', or 'intel'."
  }
}

# === CLONE DEFAULTS ===
variable "default_full_clone" {
  description = "Default setting for full clone or linked clone"
  type        = bool
}

# === CPU DEFAULTS ===
variable "default_cpu_type" {
  description = "CPU model type for emulation"
  type        = string
}

variable "default_numa" {
  description = "Default NUMA setting if not specified per-VM"
  type        = bool
}

# === STORAGE DEFAULTS ===
variable "default_iothread" {
  description = "Default iothread setting for disks if not specified per-VM"
  type        = bool
}

variable "default_ssd_emulation" {
  description = "Default SSD emulation setting for disks if not specified per-VM"
  type        = bool
}

variable "default_discard" {
  description = "Disk discard/TRIM setting"
  type        = string
}

# === TEMPLATE MAPPINGS ===
variable "proxmox_templates" {
  description = "Map of template numbers to VM IDs"
  type        = map(number)
}

variable "proxmox_nodes" {
  description = "Map of node numbers to node names"
  type        = map(string)
}


# === CLOUD-INIT CONFIGURATION ===
variable "ssh_public_key" {
  description = "SSH public key for VM access"
  type        = string
}

variable "tailscale_authkeys" {
  description = "Map of Tailscale auth keys by type"
  type        = map(string)
  sensitive   = true
}

variable "domain_name" {
  description = "Domain name for FQDN"
  type        = string
}