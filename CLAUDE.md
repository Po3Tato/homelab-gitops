# CLAUDE.md

This file provides guidance to Claude Code when working with code in this repository.

## Repository Overview

GitOps-driven multi-cloud homelab infrastructure using Proxmox (on-premises) and Vultr (cloud). 
Infrastructure as Code with OpenTofu/Terraform, configuration management with Ansible.

**Security Design**: Generic resource naming (vm-web-01, instance-app-01) with all sensitive infrastructure details stored in GitHub Secrets to prevent information disclosure.

## Key Structure

- `.github/workflows/`: Deployment and maintenance workflows
  - `maintenance.yml`: System maintenance (weekly schedule + manual)
  - `proxmox-template-create.yml`: Create Proxmox VM templates
  - `proxmox-vm-deploy.yml`: Deploy Proxmox VMs
  - `vultr-deploy.yml`: Deploy Vultr instances
  
- `infra/`: OpenTofu/Terraform configurations
  - `proxmox/`: On-premises infrastructure
    - `prod/`: Production VMs and containers
    - `prod-proxy/`: Proxy/load balancer infrastructure
    - `modules/`: Reusable VM and LXC modules
    - `cloud-init/`: Proxmox-specific cloud-init templates
  - `vultr/`: Cloud infrastructure
    - `prod/`: Production cloud instances
    - `modules/`: Firewall and instance modules
    - `cloud-init/`: Vultr-specific cloud-init templates

- `ansible/`: Minimal maintenance automation
  - `inventory/infra/`: Environment inventories (prod, vps, prod-proxy)
  - `playbooks/system/`: System maintenance only
    - `srv_update.yml`: System package updates

- `justfile`: Simplified system management commands (update/reboot only)


### Automated Maintenance

**Weekly Schedule**: Every Sunday at 2 AM UTC - automatic system updates

## Development Notes

### Technical Details
- **State Management**: OpenTofu state stored in Backblaze
- **Secret Management**: 
  - Infrastructure secrets in GitHub Secrets
  - Application secrets in Ansible Vaults
- **Environments**: prod, vps, prod-proxy
- **Cloud-init**: Templates stored in each infrastructure provider's folder
- **Networking**: Tailscale for secure cross-cloud connectivity
- **Provider**: Using bpg/proxmox provider (v0.78.1) for Proxmox

### Required GitHub Secrets
See `GITHUB_SECRETS.md` for complete list of required secrets.

**Security Note**: All infrastructure details (node names, regions, VLANs, etc.) are stored as GitHub Secrets. The `.tfvars` files use `${SECRET_NAME}` that are replaced at runtime.

### Workflow Triggers
- Workflows are manual (workflow_dispatch)
- Use GitHub UI or CLI to trigger deployments
- Each workflow handles specific infrastructure components

# important-instruction-reminders
Do what has been asked; nothing more, nothing less.
NEVER create files unless they're absolutely necessary for achieving your goal.
ALWAYS prefer editing an existing file to creating a new one.
NEVER proactively create documentation files (*.md) or README files. Only create documentation files if explicitly requested by the User.