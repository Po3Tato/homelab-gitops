# === SHARED CONFIGURATION ===
# Import shared provider and outputs configuration
# This eliminates duplication across prod, prod-pigsty, and prod-proxy environments

# Shared provider configuration
terraform {
  required_providers {
    proxmox = {
      source  = "bpg/proxmox"
      version = "0.81.0"
    }
  }
}

provider "proxmox" {
  endpoint  = var.virtual_environment_endpoint
  api_token = var.virtual_environment_api_token
  insecure  = false
}

# === LOCAL VALUES ===
locals {
  node_names = toset([for k, v in var.vms : v.node_name])
}

# === VM MODULES ===
# Virtual Machines
module "vms" {
  source   = "../modules/vm"
  for_each = var.vms
  
  # === BASIC VM CONFIGURATION ===
  name      = each.value.name
  vm_id     = each.value.vm_id
  node_name = each.value.node_name

  # === CLONE CONFIGURATION ===
  clone_vm_id        = each.value.clone_vm_id
  clone_node_name    = lookup(each.value, "clone_node_name", each.value.node_name)
  clone_datastore_id = lookup(each.value, "clone_datastore_id", var.datastore_disk)
  full_clone         = lookup(each.value, "full_clone", var.default_full_clone)

  # === VM DESCRIPTION WITH STANDARD TEMPLATE ===
  description = lookup(each.value, "description", <<-EOF
06/24/2025 ver 1.0
Services Install

    Tailscale [link to docs]
    Docker [link to docs]
    Pangolin [link to docs]

EOF
  )

  # === CPU CONFIGURATION ===
  cpu_cores       = each.value.cpu_cores
  cpu_type        = lookup(each.value, "cpu_type", var.default_cpu_type)
  hotplug_cpu     = lookup(each.value, "hotplug_cpu", var.default_hotplug_cpu)
  hotplugged_vcpu = lookup(each.value, "hotplugged_vcpu", var.default_hotplugged_vcpu)
  max_cpu         = lookup(each.value, "max_cpu", var.default_max_cpu)
  numa            = lookup(each.value, "numa", var.default_numa)

  # === MEMORY CONFIGURATION ===
  memory          = each.value.memory
  floating_memory = lookup(each.value, "floating_memory", null)

  # === MACHINE TYPE AND VIRTUALIZATION ===
  machine_type = lookup(each.value, "machine_type", var.default_machine_type)
  viommu       = lookup(each.value, "viommu", var.default_viommu)

  # === STORAGE CONFIGURATION ===
  disk_size     = lookup(each.value, "disk_size", null)
  datastore_disk = var.datastore_disk
  iothread      = lookup(each.value, "iothread", var.default_iothread)
  ssd_emulation = lookup(each.value, "ssd_emulation", var.default_ssd_emulation)
  discard       = lookup(each.value, "discard", var.default_discard)

  # === NETWORK CONFIGURATION ===
  network_bridge = var.network_bridge
  vlan_id        = each.value.vlan_id

  # === VM LIFECYCLE AND MANAGEMENT ===
  agent_enabled = var.agent_enabled
  vm_reboot     = lookup(each.value, "vm_reboot", var.vm_reboot)

  # === TAGS (ENVIRONMENT SPECIFIC) ===
  tags = concat(["opentofu", "ubuntu", "prod-proxy"], lookup(each.value, "tags", []))

  # === HARDWARE PASSTHROUGH ===
  hostpci = lookup(each.value, "hostpci", [])
}

# === SHARED OUTPUTS ===
# VM IDENTIFICATION OUTPUTS
output "vm_ids" {
  description = "Map of VM keys to their Proxmox VM IDs"
  value = {
    for k, v in module.vms : k => v.vm_id
  }
}

output "vm_names" {
  description = "Map of VM keys to their display names"
  value = {
    for k, v in module.vms : k => v.vm_name
  }
}

# VM NETWORK OUTPUTS
output "vm_ips" {
  description = "Map of VM keys to their IP addresses (requires guest agent)"
  value = {
    for k, v in module.vms : k => v.vm_ips
  }
}

output "all_node_names" {
  description = "All Proxmox nodes used by VMs"
  value = tolist(local.node_names)
}