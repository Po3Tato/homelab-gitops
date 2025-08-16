variable "template_name" {
  description = "Name of the template to create"
  type        = string
}

variable "cloud_image_url" {
  description = "URL of the cloud image to download"
  type        = string
}

variable "proxmox_node" {
  description = "Target Proxmox node for template creation"
  type        = string
}

variable "vm_id" {
  description = "VM ID for the template"
  type        = number
}

variable "virtual_environment_endpoint" {
  description = "Proxmox VE API endpoint"
  type        = string
}

variable "virtual_environment_api_token" {
  description = "Proxmox VE API token"
  type        = string
  sensitive   = true
}

variable "template_username" {
  description = "Username for the template user account"
  type        = string
}