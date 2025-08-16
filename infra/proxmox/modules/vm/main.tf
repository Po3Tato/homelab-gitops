terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

locals {
  safe_hotplug_cpu       = var.hotplug_cpu == null ? false : var.hotplug_cpu
  safe_max_cpu           = var.max_cpu == null ? var.cpu_cores : var.max_cpu
  safe_machine_type      = var.machine_type == null ? "pc" : var.machine_type
  safe_viommu            = var.viommu == null ? "" : var.viommu
  safe_iothread          = var.iothread == null ? true : var.iothread
  safe_ssd_emulation     = var.ssd_emulation == null ? true : var.ssd_emulation
  safe_discard           = var.discard == null ? "on" : var.discard
  safe_hotplugged_vcpu   = var.hotplugged_vcpu != null ? var.hotplugged_vcpu : (local.safe_hotplug_cpu ? (local.safe_max_cpu - var.cpu_cores) : 0)
  safe_hostname          = var.hostname != "" ? var.hostname : var.name
  safe_cloud_init_ds     = var.cloud_init_datastore != null ? var.cloud_init_datastore : var.datastore_disk
}

resource "proxmox_virtual_environment_vm" "vm" {
  # ===================================================================
  # EXPECTED DRIFT NOTICE
  # ===================================================================
  # This VM will show network drift in 'tofu plan' due to:
  # - Docker containers creating virtual networks (172.x.x.x)
  # - Tailscale VPN adding mesh network IPs (100.x.x.x)  
  # - DHCP renewals changing interface assignments
  # - Dynamic MAC addresses from Docker virtual interfaces
  # 
  # This drift is NORMAL and EXPECTED for operational VMs.
  # The core infrastructure (CPU, memory, disk, primary network) 
  # remains stable and managed by OpenTofu.
  # ===================================================================

  # === BASIC VM IDENTIFICATION ===
  name        = var.name
  description = var.description
  tags        = var.tags
  node_name   = var.node_name
  vm_id       = var.vm_id

  # === VM CLONING CONFIGURATION ===
  clone {
    vm_id        = var.clone_vm_id
    node_name    = var.clone_node_name
    datastore_id = var.clone_datastore_id
    full         = var.full_clone
    retries      = 3
  }

  # === QEMU GUEST AGENT CONFIGURATION ===
  agent {
    enabled = var.agent_enabled
    trim    = true
    type    = "virtio"
  }

  # === VM LIFECYCLE MANAGEMENT ===
  reboot          = var.vm_reboot
  stop_on_destroy = true
  on_boot         = true

  # === MACHINE TYPE AND VIRTUALIZATION ===
  # pc = Standard PC (i440FX + PIIX, 1996) - compatible but older
  # q35 = Standard PC (Q35 + ICH9, 2009) - modern, supports PCIe
  # viommu adds virtual IOMMU support for better device isolation
  machine = local.safe_viommu != "" ? "${local.safe_machine_type},viommu=${local.safe_viommu}" : local.safe_machine_type

  # === VM STARTUP SEQUENCE ===
  startup {
    order      = "1"
    up_delay   = "5"
    down_delay = "5"
  }

  # === CPU CONFIGURATION ===
  cpu {
    sockets     = 1
    cores       = var.cpu_cores
    type        = var.cpu_type
    numa        = var.numa
    hotplugged  = local.safe_hotplugged_vcpu
    limit       = local.safe_hotplug_cpu ? local.safe_max_cpu : 0
    flags       = ["+aes"]
    units       = 1024
  }

  # === MEMORY CONFIGURATION ===
  memory {
    dedicated = var.memory
    floating  = var.floating_memory != null ? var.floating_memory : var.memory
  }

  # === STORAGE CONFIGURATION ===
  dynamic "disk" {
    for_each = var.disk_size != null ? [1] : []
    content {
      interface    = "scsi0"
      size         = var.disk_size
      datastore_id = var.datastore_disk
      iothread     = local.safe_iothread
      ssd          = local.safe_ssd_emulation
      discard      = local.safe_discard
    }
  }

  # === NETWORK CONFIGURATION ===
  network_device {
    bridge = var.network_bridge
    model  = "virtio"
  }

  # === OPERATING SYSTEM TYPE ===
  operating_system {
    type = "l26"
  }
  
  # OS Type Options:
  # l26     = Linux 2.6/3.x/4.x/5.x kernels (modern Linux)
  # l24     = Linux 2.4 kernels (older Linux)
  # win10   = Windows 10/Server 2016/2019
  # other   = Generic/unspecified OS

  # === SERIAL CONSOLE ===
  serial_device {}

  # === PCI DEVICE PASSTHROUGH ===
  # Allows direct hardware access for specific devices (GPUs, NICs, etc.)
  dynamic "hostpci" {
    for_each = var.hostpci
    content {
      device  = hostpci.value.device
      mapping = hostpci.value.mapping
      pcie    = lookup(hostpci.value, "pcie", false)
      rombar  = lookup(hostpci.value, "rombar", true)
      xvga    = lookup(hostpci.value, "xvga", false)
    }
  }

  # === TIMEOUT CONFIGURATION ===
  timeout_clone       = 1800                               # Clone operation timeout (30 minutes)
  timeout_create      = 600                                # VM creation timeout (10 minutes)
  timeout_migrate     = 1800                               # Migration timeout (30 minutes)
  timeout_reboot      = 1800                               # Reboot timeout (30 minutes)
  timeout_shutdown_vm = 1800                               # Shutdown timeout (30 minutes)
  timeout_start_vm    = 1800                               # Start timeout (30 minutes)
  timeout_stop_vm     = 300                                # Force stop timeout (5 minutes)

  # === CLOUD-INIT CONFIGURATION ===
  dynamic "initialization" {
    for_each = var.cloud_init_enabled ? [1] : []
    content {
      datastore_id = local.safe_cloud_init_ds
      user_data_file_id = var.user_data_file_id
    }
  }

  # === LIFECYCLE MANAGEMENT ===
  lifecycle {
    ignore_changes = [
      description,
    ]
  }
}

