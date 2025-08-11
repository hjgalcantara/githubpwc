variable "virtual_machines" {
  description = "Map of virtual machine configurations."
  type = map(object({
    vm_name                      = string
    resource_group_name          = string
    location                     = string
    vm_size                      = string
    admin_username               = string
    admin_password               = string
    nic_name                     = string
    subnet_id                    = string
    os_disk_caching              = string
    os_disk_storage_account_type = string
    image_publisher              = string
    image_offer                  = string
    image_sku                    = string
    image_version                = string
    shutdown_enabled             = bool
    shutdown_time                = string
    shutdown_timezone            = string
    shutdown_notification_enabled = bool
  }))
}

variable "default_tags" {
  description = "Default tags to be applied to resources"
  type        = map(string)
  default     = {}
}
