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

locals {
  controlplane_vms = {
    for i in range(var.controlplane_count) : 
    "controlplane-${format("%02d", i + 1)}" => {
      name           = "${var.vm_basename}-cp-${format("%02d", i + 1)}"
      vm_id          = var.controlplane_vm_id_start + i
      cpu_cores      = var.controlplane_cpu_cores
      memory         = var.controlplane_memory
      disk_size      = var.controlplane_disk_size
      node_number    = var.controlplane_node_number
      tags           = ["github-actions", "prod", "controlplane"]
      tailscale_key  = "controlplane"
      description    = "Production VM - Control Plane Configuration"
    }
  }
  workers_vms = {
    for i in range(var.workers_count) : 
    "workers-${format("%02d", i + 1)}" => {
      name           = "${var.vm_basename}-wkr-${format("%02d", i + 1)}"
      vm_id          = var.workers_vm_id_start + i
      cpu_cores      = var.workers_cpu_cores
      memory         = var.workers_memory
      disk_size      = var.workers_disk_size
      node_number    = var.workers_node_number
      tags           = ["github-actions", "prod", "workers"]
      tailscale_key  = "workers"
      description    = "Production VM - Worker Node Configuration"
    }
  }
  
  all_vms = merge(local.controlplane_vms, local.workers_vms)
}

module "vms" {
  source   = "../modules/vm"
  for_each = local.all_vms
  
  name      = each.value.name
  vm_id     = each.value.vm_id
  node_name = var.proxmox_nodes[each.value.node_number]

  clone_vm_id        = var.proxmox_templates[each.value.node_number]
  clone_node_name    = var.proxmox_nodes[each.value.node_number]
  clone_datastore_id = var.datastore_disk
  full_clone         = var.default_full_clone

  description = each.value.description

  cpu_cores       = each.value.cpu_cores
  cpu_type        = var.default_cpu_type
  hotplug_cpu     = var.default_hotplug_cpu
  hotplugged_vcpu = var.default_hotplugged_vcpu
  max_cpu         = var.default_max_cpu
  numa            = var.default_numa

  memory          = each.value.memory
  floating_memory = null

  machine_type = var.default_machine_type
  viommu       = var.default_viommu

  disk_size      = each.value.disk_size
  datastore_disk = var.datastore_disk
  iothread       = var.default_iothread
  ssd_emulation  = var.default_ssd_emulation
  discard        = var.default_discard

  network_bridge = var.network_bridge
  vlan_id        = var.vlan_prod

  agent_enabled = var.agent_enabled
  vm_reboot     = var.vm_reboot

  tags = concat(["opentofu", "ubuntu", "prod"], each.value.tags)

  hostpci = []
  
  ssh_public_key    = var.ssh_public_key
  tailscale_authkey = var.tailscale_authkeys[each.value.tailscale_key]
  hostname          = each.value.name
  domain            = var.domain_name
  install_tailscale = true
  install_docker    = true
}

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

output "vm_info" {
  description = "Complete VM information including node, name, VM ID, and IP address"
  value = {
    for k, v in module.vms : k => {
      node    = v.node_name
      name    = v.vm_name
      vm_id   = v.vm_id
      ip      = v.primary_ip
    }
  }
}

output "vm_ips" {
  description = "Map of VM keys to their IP addresses (requires guest agent)"
  value = {
    for k, v in module.vms : k => v.vm_ips
  }
}