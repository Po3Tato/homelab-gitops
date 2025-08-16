# === INFRASTRUCTURE CONFIGURATION ===
virtual_environment_endpoint  = "${PROXMOX_ENDPOINT}"
virtual_environment_api_token = "${PROXMOX_API_TOKEN}"
node_name                     = "${PROXMOX_NODE_NAME}"
datastore_disk               = "${PROXMOX_DATASTORE}"
network_bridge               = "${PROXMOX_NETWORK_BRIDGE}"

# === VM DEFAULTS ===
agent_enabled = true
vm_reboot     = false
default_max_cpu         = 4
default_machine_type    = "pc"
default_full_clone      = true
default_discard         = "on"
default_cpu_type        = "x86-64-v2-AES"
default_hotplug_cpu     = false
default_hotplugged_vcpu = 0
default_numa            = true
default_iothread        = true
default_ssd_emulation   = true
default_viommu          = ""

# === SSH AND DOMAIN CONFIGURATION ===
ssh_public_key = "${SSH_PUBLIC_KEY}"
domain_name    = "${DOMAIN_NAME}"

# === TAILSCALE CONFIGURATION ===
tailscale_authkeys = {
  controlplane = "${TAILSCALE_AUTHKEY_CP}"
  workers      = "${TAILSCALE_AUTHKEY_WKR}"
}

# === PROXMOX INFRASTRUCTURE MAPPING ===
proxmox_nodes = {
  0 = "${PROXMOX_NODE_0}"
  1 = "${PROXMOX_NODE_1}"
  2 = "${PROXMOX_NODE_2}"
}

proxmox_templates = {
  0 = "${PROXMOX_TEMPLATE_0}"
  1 = "${PROXMOX_TEMPLATE_1}" 
  2 = "${PROXMOX_TEMPLATE_2}"
}

# === CONTROLPLANE VMS ===
controlplane_count        = 3
controlplane_vm_id_start  = 100
controlplane_cpu_cores    = 2
controlplane_memory       = 4096
controlplane_disk_size    = 50
controlplane_node_number  = 0
controlplane_vlan_id      = 110

# === WORKER VMS ===
workers_count        = 3
workers_vm_id_start  = 110
workers_cpu_cores    = 4
workers_memory       = 8192
workers_disk_size    = 100
workers_node_number  = 1
workers_vlan_id      = 105

# === NETWORK CONFIGURATION ===
enable_vlans = true