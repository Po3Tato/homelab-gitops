output "container_id" {
  description = "ID of the created container"
  value       = proxmox_virtual_environment_container.lxc.vm_id
}

output "container_hostname" {
  description = "Hostname of the created container"
  value       = var.hostname
}

output "node_name" {
  description = "Node where the container is running"
  value       = proxmox_virtual_environment_container.lxc.node_name
}

output "tags" {
  description = "Tags assigned to the container"
  value       = proxmox_virtual_environment_container.lxc.tags
}

output "unprivileged" {
  description = "Whether the container runs as unprivileged"
  value       = proxmox_virtual_environment_container.lxc.unprivileged
}

output "template_file_id" {
  description = "Template file ID used for the container"
  value       = var.template_file_id
}

output "os_type" {
  description = "Operating system type of the container"
  value       = var.os_type
}

output "started" {
  description = "Whether the container is configured to be started"
  value       = var.started
}

output "protection" {
  description = "Whether the container has protection enabled"
  value       = proxmox_virtual_environment_container.lxc.protection
}
