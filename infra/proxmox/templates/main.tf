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
  insecure  = true
}

resource "proxmox_virtual_environment_download_file" "cloud_image" {
  content_type = "import"
  datastore_id = "local"
  node_name    = var.proxmox_node
  url          = var.cloud_image_url
  file_name    = "${var.template_name}-cloudimg.qcow2"
  
  verify = false
  upload_timeout     = 3600
}

resource "proxmox_virtual_environment_vm" "template" {
  name        = var.template_name
  description = "VM Template - ${var.template_name}"
  node_name   = var.proxmox_node
  vm_id       = var.vm_id
  template    = true

  cpu {
    cores = 2
    type  = "x86-64-v2-AES"
  }

  memory {
    dedicated = 2048
  }

  disk {
    datastore_id = "local-lvm"
    import_from  = proxmox_virtual_environment_download_file.cloud_image.id
    interface    = "scsi0"
    size         = 20
    iothread     = true
    ssd          = true
    discard      = "on"
  }

  network_device {
    bridge = "vmbr0"
    model  = "virtio"
  }

  operating_system {
    type = "l26"
  }

  serial_device {}

  initialization {
    datastore_id = "local-lvm"
    
    ip_config {
      ipv4 {
        address = "dhcp"
      }
    }

    user_account {
      username = "ubuntu"
      keys     = []
    }
  }

  agent {
    enabled = true
  }

  tags = ["template", "ubuntu", "cloud-init"]
}