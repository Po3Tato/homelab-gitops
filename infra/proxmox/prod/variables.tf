# === BASE NAMING CONFIGURATION ===
variable "vm_basename" {
  description = "Base name for VMs (generic for security)"
  type        = string
  default     = "vm"
}

variable "environment" {
  description = "Environment name"
  type        = string
  default     = "prod"
}

# === VM CONFIGURATION ===
variable "vms" {
  description = "Map of VMs with their configurations"
  type = map(object({
    node_name          = string
    name               = string
    vm_id              = number
    cpu_cores          = number
    memory             = number
    floating_memory    = optional(number)
    disk_size          = optional(number)
    vlan_id            = number
    vm_reboot          = optional(bool)
    cpu_type           = optional(string)
    hotplug_cpu        = optional(bool)
    hotplugged_vcpu    = optional(number)
    max_cpu            = optional(number)
    machine_type       = optional(string)
    viommu             = optional(string)
    tags               = optional(list(string), [])
    clone_vm_id        = number
    clone_node_name    = optional(string)
    clone_datastore_id = optional(string)
    full_clone         = optional(bool)
    discard            = optional(string)
    hostpci = optional(list(object({
      device  = string
      mapping = string
      pcie    = optional(bool)
      rombar  = optional(bool)
      xvga    = optional(bool)
    })), [])
  }))
  default = {}
}

# === INFRASTRUCTURE SETTINGS ===
variable "node_name" {
  description = "Default Proxmox node name"
  type        = string
}

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

variable "override_template_id" {
  description = "Override template VM ID for all VMs (optional, from workflow input)"
  type        = number
  default     = null
}

variable "override_node_name" {
  description = "Override target node for all VMs (optional, from workflow input)"
  type        = string
  default     = null
}