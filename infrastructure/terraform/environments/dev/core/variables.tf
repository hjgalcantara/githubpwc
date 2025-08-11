variable "project" {
    description = "The name of the project."
    type        = string
}

variable "client"  {
    description = "The name of the client."
    type        = string
}

variable "environment" {
    description = "The environment (e.g., dev, prod)."
    type        = string
}

variable "region" {
    description = "The Azure region where resources will be deployed."
    type        = string
}

variable "owner" {
    description = "The name of the owner of the resources."
    type        = string
}

variable "approver" {
    description = "The name of the approver for the resources."
    type        = string
}

variable "storage_account" {
    description = "The configuration for the storage account."
    type        = map(object({
        account_kind                   = string
        account_tier                   = string
        account_replication_type       = string
        public_network_access_enabled  = bool
        is_hns_enabled                 = bool
    }))
}

variable "data_factory" {
    description = "The configuration for the Data Factory."
    type        = map(object({
        public_network_enabled = bool
    }))
  
}

variable "function_apps" {
    description = "Map of function app configurations"
    type = map(object({
        os_type                        = string
        sku_name                       = string
        dotnet_version                 = string
        account_kind                   = string
        account_tier                   = string
        account_replication_type       = string
        is_hns_enabled                 = bool
        public_network_access_enabled  = bool
    }))
}

variable "virtual_machines" {
  description = "Map of virtual machine configurations"
  type = map(object({
    admin_username = string
    admin_password = string
    vm_size        = string
    os_disk_caching = string
    os_disk_storage_account_type = string
    image_publisher = string
    image_offer     = string
    image_sku       = string
    image_version  = string
    shutdown_enabled = bool
    shutdown_time = optional(string)
    shutdown_timezone = optional(string)
    shutdown_notification_enabled = bool
  }))
}