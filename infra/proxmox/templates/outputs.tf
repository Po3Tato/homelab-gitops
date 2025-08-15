output "template_name" {
  description = "Name of the created template"
  value       = proxmox_virtual_environment_vm.template.name
}

output "template_vm_id" {
  description = "VM ID of the created template"
  value       = proxmox_virtual_environment_vm.template.vm_id
}

output "template_node" {
  description = "Proxmox node where the template was created"
  value       = proxmox_virtual_environment_vm.template.node_name
}

output "template_details" {
  description = "Complete template information"
  value = {
    name    = proxmox_virtual_environment_vm.template.name
    vm_id   = proxmox_virtual_environment_vm.template.vm_id
    node    = proxmox_virtual_environment_vm.template.node_name
    tags    = proxmox_virtual_environment_vm.template.tags
  }
}