# Vultr Production Configuration

username     = "${ADMIN_USERNAME}"
hostname     = "instance"
domain       = "${MAIN_DOMAIN}"
ssh_key_name = "${SSH_KEY_NAME}"
region       = "${VULTR_REGION}"
os_id        = "${VULTR_OS_ID}"
script_name  = "cloud-init.yaml"

instance_basename = "instance"
environment      = "prod"

backups_enabled = "${BACKUPS_ENABLED}"
backup_schedule = {
  type = "${BACKUP_TYPE}"
  hour = "${BACKUP_HOUR}"
  dow  = "${BACKUP_DOW}"
}

instances = {
  "web-01" = {
    plan   = "${VULTR_PLAN_WEB}"
    region = "${VULTR_REGION}"
    number = 1
    tags   = ["production", "web-tier"]
  }
  
  "web-02" = {
    plan   = "${VULTR_PLAN_WEB}"
    region = "${VULTR_REGION}"
    number = 1
    tags   = ["production", "web-tier"]
  }
  
  "app-01" = {
    plan   = "${VULTR_PLAN_APP}"
    region = "${VULTR_REGION}"
    number = 1
    tags   = ["production", "app-tier", "container-runtime"]
  }
}