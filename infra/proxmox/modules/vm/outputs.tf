# === BASIC VM IDENTIFICATION ===
output "vm_id" {
  description = "Unique VM identifier assigned by Proxmox"
  value       = proxmox_virtual_environment_vm.vm.vm_id
}

output "vm_name" {
  description = "VM name as displayed in Proxmox GUI"
  value       = proxmox_virtual_environment_vm.vm.name
}

# === NETWORK INFORMATION ===
output "vm_ips" {
  description = "All non-loopback IPv4 addresses detected by QEMU guest agent"
  value = flatten([
    for iface_ips in proxmox_virtual_environment_vm.vm.ipv4_addresses : [
      for ip in iface_ips : ip
      if ip != "127.0.0.1"
    ]
  ])
}

output "mac_addresses" {
  description = "MAC addresses of all VM network interfaces"
  value       = proxmox_virtual_environment_vm.vm.mac_addresses
}

output "primary_ip" {
  description = "Primary IPv4 address (first non-loopback IP found)"
  value = length(flatten([
    for iface_ips in proxmox_virtual_environment_vm.vm.ipv4_addresses : [
      for ip in iface_ips : ip
      if ip != "127.0.0.1"
    ]
  ])) > 0 ? flatten([
    for iface_ips in proxmox_virtual_environment_vm.vm.ipv4_addresses : [
      for ip in iface_ips : ip
      if ip != "127.0.0.1"
    ]
  ])[0] : null
}

output "vm_summary" {
  description = "Summary of VM configuration and current state"
  value = {
    vm_id     = proxmox_virtual_environment_vm.vm.vm_id
    name      = proxmox_virtual_environment_vm.vm.name
    node      = proxmox_virtual_environment_vm.vm.node_name
    cpu_cores = var.cpu_cores
    memory_mb = var.memory
    disk_size = var.disk_size
    vlan_id   = var.vlan_id
    tags      = proxmox_virtual_environment_vm.vm.tags
  }
}

output "vm_status" {
  description = "VM operational status"
  value = {
    agent_enabled    = var.agent_enabled
    has_ip_addresses = length(flatten([
      for iface_ips in proxmox_virtual_environment_vm.vm.ipv4_addresses : [
        for ip in iface_ips : ip
        if ip != "127.0.0.1"
      ]
    ])) > 0
    interface_count = length(proxmox_virtual_environment_vm.vm.mac_addresses)
  }
}