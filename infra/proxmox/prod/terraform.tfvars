# Proxmox Production Configuration

node_name      = "${PROXMOX_NODE_NAME}"
datastore_disk = "${PROXMOX_DATASTORE}"
network_bridge = "${PROXMOX_NETWORK_BRIDGE}"

vm_basename = "vm"
environment = "prod"

vms = {
  web-1 = {
    name        = "vm-web-01"
    vm_id       = 201
    node_name   = "${PROXMOX_NODE_NAME}"
    cpu_cores   = 2
    memory      = 4096
    disk_size   = 32
    vlan_id     = "${VLAN_PROD}"
    clone_vm_id = "${TEMPLATE_UBUNTU_2404}"
    tags        = ["production", "web", "container-runtime"]
  }
  
  web-2 = {
    name        = "vm-web-02"
    vm_id       = 202
    node_name   = "${PROXMOX_NODE_NAME}"
    cpu_cores   = 2
    memory      = 4096
    disk_size   = 32
    vlan_id     = "${VLAN_PROD}"
    clone_vm_id = "${TEMPLATE_UBUNTU_2404}"
    tags        = ["production", "web", "container-runtime"]
  }
  
  app-1 = {
    name        = "vm-app-01"
    vm_id       = 210
    node_name   = "${PROXMOX_NODE_NAME}"
    cpu_cores   = 4
    memory      = 8192
    disk_size   = 64
    vlan_id     = "${VLAN_PROD}"
    clone_vm_id = "${TEMPLATE_UBUNTU_2404}"
    tags        = ["production", "app", "container-runtime", "orchestrator"]
  }
  
  data-1 = {
    name        = "vm-data-01"
    vm_id       = 220
    node_name   = "${PROXMOX_NODE_NAME}"
    cpu_cores   = 4
    memory      = 8192
    disk_size   = 100
    vlan_id     = "${VLAN_PROD}"
    clone_vm_id = "${TEMPLATE_UBUNTU_2404}"
    tags        = ["production", "database", "persistent-storage"]
  }
}