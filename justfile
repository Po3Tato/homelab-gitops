# Justfile menu commands
default:
    @echo "Available commands:"
    @echo ""
    @echo "System Management:"
    @echo "  just update [ENV] [HOST]     - Update system packages"
    @echo "  just update-all              - Update all infrastructure"
    @echo "  just reboot [ENV] [HOST]     - Reboot systems"
    @echo "  just status [ENV] [HOST]     - Check system status"
    @echo ""
    @echo "Environments: prod, vps, prod-proxy"
    @echo ""
    @echo "Examples:"
    @echo "  just update                  - Update all prod systems"
    @echo "  just update vps              - Update all vps systems"
    @echo "  just update prod webserver   - Update specific host"
    @echo "  just reboot prod webserver   - Reboot specific host"
    @echo "  just status vps              - Check vps environment status"


update ENV='prod' HOST='':
    #!/usr/bin/env bash
    cd ansible
    if [ -z "{{HOST}}" ]; then
        echo "Updating all hosts in {{ENV}} environment..."
        ansible-playbook playbooks/system/srv_update.yml \
            -i inventory/infra/{{ENV}}/hosts.yml
    else
        echo "Updating {{HOST}} in {{ENV}} environment..."
        ansible-playbook playbooks/system/srv_update.yml \
            -i inventory/infra/{{ENV}}/hosts.yml \
            --limit {{HOST}}
    fi

update-all:
    #!/usr/bin/env bash
    cd ansible
    echo "Updating all infrastructure..."
    for env in prod vps prod-proxy; do
        if [ -f "inventory/infra/$env/hosts.yml" ]; then
            echo "Updating $env environment..."
            ansible-playbook playbooks/system/srv_update.yml \
                -i inventory/infra/$env/hosts.yml
        fi
    done

reboot ENV='prod' HOST='':
    #!/usr/bin/env bash
    cd ansible
    if [ -z "{{HOST}}" ]; then
        echo "Rebooting all hosts in {{ENV}} environment..."
        ansible all \
            -i inventory/infra/{{ENV}}/hosts.yml \
            -m ansible.builtin.reboot \
            -a "test_command=whoami pre_reboot_delay=5 post_reboot_delay=10 reboot_timeout=600" \
            --become
    else
        echo "Rebooting {{HOST}} in {{ENV}} environment..."
        ansible {{HOST}} \
            -i inventory/infra/{{ENV}}/hosts.yml \
            -m ansible.builtin.reboot \
            -a "test_command=whoami pre_reboot_delay=5 post_reboot_delay=10 reboot_timeout=600" \
            --become
    fi

status ENV='prod' HOST='':
    #!/usr/bin/env bash
    cd ansible
    if [ -z "{{HOST}}" ]; then
        echo "Checking status of all hosts in {{ENV}} environment..."
        ansible all \
            -i inventory/infra/{{ENV}}/hosts.yml \
            -m ping
    else
        echo "Checking status of {{HOST}} in {{ENV}} environment..."
        ansible {{HOST}} \
            -i inventory/infra/{{ENV}}/hosts.yml \
            -m ping
    fi