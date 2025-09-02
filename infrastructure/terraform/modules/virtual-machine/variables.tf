variable "virtual_machines" {
  description = "Map of VM configurations."
  type = map(object({
    vm_name                        = string
    nic_name                       = string
    resource_group_name            = string
    location                       = string
    vm_size                        = string
    administrator_login            = string
    key_vault_id                   = string
    subnet_id                      = string
    os_disk_caching                = string
    os_disk_storage_account_type   = string
    image_publisher                = string
    image_offer                    = string
    image_sku                      = string
    image_version                  = string
    shutdown_enabled               = bool
    shutdown_time                  = string
    shutdown_timezone              = string
    shutdown_notification_enabled  = bool
  }))
}

variable "default_tags" {
  description = "Default tags to apply to all resources."
  type        = map(string)
  default     = {}
}