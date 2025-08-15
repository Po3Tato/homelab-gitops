terraform {
  required_providers {
    proxmox = {
      source = "bpg/proxmox"
    }
  }
}

locals {
  safe_cpu_cores       = var.cpu_cores == null ? 1 : var.cpu_cores
  safe_cpu_units       = var.cpu_units == null ? 1024 : var.cpu_units
  safe_memory          = var.memory == null ? 512 : var.memory
  safe_swap            = var.swap == null ? 0 : var.swap
  safe_disk_size       = var.disk_size == null ? 4 : var.disk_size
  safe_unprivileged    = var.unprivileged == null ? true : var.unprivileged
  safe_start_on_boot   = var.start_on_boot == null ? true : var.start_on_boot
  safe_protection      = var.protection == null ? false : var.protection
  safe_nesting         = var.nesting == null ? false : var.nesting
  safe_fuse            = var.fuse == null ? false : var.fuse
  safe_keyctl          = var.keyctl == null ? false : var.keyctl
}

resource "proxmox_virtual_environment_container" "lxc" {
  description  = var.description != null ? var.description : "Managed by OpenTofu"
  tags         = var.tags
  node_name    = var.node_name
  vm_id        = var.vm_id
  pool_id      = var.pool_id
  unprivileged = local.safe_unprivileged
  started      = var.started
  start_on_boot = local.safe_start_on_boot
  protection   = local.safe_protection
  template     = var.template

  dynamic "clone" {
    for_each = var.clone != null ? [var.clone] : []
    content {
      vm_id        = clone.value.vm_id
      node_name    = lookup(clone.value, "node_name", var.node_name)
      datastore_id = lookup(clone.value, "datastore_id", var.datastore_disk)
    }
  }

  operating_system {
    template_file_id = var.template_file_id
    type             = var.os_type
  }

  cpu {
    architecture = var.cpu_architecture
    cores        = local.safe_cpu_cores
    units        = local.safe_cpu_units
  }

  memory {
    dedicated = local.safe_memory
    swap      = local.safe_swap
  }

  disk {
    datastore_id = var.datastore_disk
    size         = local.safe_disk_size
  }

  dynamic "network_interface" {
    for_each = var.network_interfaces != null ? var.network_interfaces : []
    content {
      name        = network_interface.value.name
      bridge      = lookup(network_interface.value, "bridge", var.default_bridge)
      enabled     = lookup(network_interface.value, "enabled", true)
      firewall    = lookup(network_interface.value, "firewall", false)
      mac_address = lookup(network_interface.value, "mac_address", null)
      mtu         = lookup(network_interface.value, "mtu", null)
      rate_limit  = lookup(network_interface.value, "rate_limit", null)
      vlan_id     = lookup(network_interface.value, "vlan_id", null)
    }
  }

  # Fixed: hostname should be inside initialization block
  initialization {
    hostname = var.hostname

    dynamic "dns" {
      for_each = var.initialization != null && lookup(var.initialization, "dns", null) != null ? [var.initialization.dns] : []
      content {
        domain  = lookup(dns.value, "domain", null)
        servers = lookup(dns.value, "servers", null)
      }
    }

    dynamic "ip_config" {
      for_each = var.initialization != null ? lookup(var.initialization, "ip_configs", []) : []
      content {
        dynamic "ipv4" {
          for_each = lookup(ip_config.value, "ipv4", null) != null ? [ip_config.value.ipv4] : []
          content {
            address = ipv4.value.address
            gateway = lookup(ipv4.value, "gateway", null)
          }
        }
        dynamic "ipv6" {
          for_each = lookup(ip_config.value, "ipv6", null) != null ? [ip_config.value.ipv6] : []
          content {
            address = ipv6.value.address
            gateway = lookup(ipv6.value, "gateway", null)
          }
        }
      }
    }

    dynamic "user_account" {
      for_each = var.initialization != null && lookup(var.initialization, "user_account", null) != null ? [var.initialization.user_account] : []
      content {
        keys     = lookup(user_account.value, "keys", null)
        password = lookup(user_account.value, "password", null)
      }
    }
  }

  dynamic "mount_point" {
    for_each = var.mount_points != null ? var.mount_points : []
    content {
      path          = mount_point.value.path
      volume        = mount_point.value.volume
      size          = lookup(mount_point.value, "size", null)
      acl           = lookup(mount_point.value, "acl", null)
      backup        = lookup(mount_point.value, "backup", null)
      quota         = lookup(mount_point.value, "quota", null)
      read_only     = lookup(mount_point.value, "read_only", null)
      replicate     = lookup(mount_point.value, "replicate", null)
      shared        = lookup(mount_point.value, "shared", null)
      mount_options = lookup(mount_point.value, "mount_options", null)
    }
  }

  dynamic "device_passthrough" {
    for_each = var.device_passthrough != null ? var.device_passthrough : []
    content {
      path       = device_passthrough.value.path
      deny_write = lookup(device_passthrough.value, "deny_write", false)
      gid        = lookup(device_passthrough.value, "gid", null)
      uid        = lookup(device_passthrough.value, "uid", null)
      mode       = lookup(device_passthrough.value, "mode", null)
    }
  }

  features {
    nesting = local.safe_nesting
    fuse    = local.safe_fuse
    keyctl  = local.safe_keyctl
    mount   = var.mount_types != null ? var.mount_types : []
  }

  console {
    enabled   = var.console_enabled
    type      = var.console_type
    tty_count = var.console_tty_count
  }

  dynamic "startup" {
    for_each = var.startup != null ? [var.startup] : []
    content {
      order      = startup.value.order
      up_delay   = lookup(startup.value, "up_delay", null)
      down_delay = lookup(startup.value, "down_delay", null)
    }
  }

  hook_script_file_id = var.hook_script_file_id

  timeout_create = var.timeout_create
  timeout_clone  = var.timeout_clone
  timeout_delete = var.timeout_delete
  timeout_update = var.timeout_update
}
