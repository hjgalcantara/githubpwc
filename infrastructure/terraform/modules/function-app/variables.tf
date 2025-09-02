variable "private_dns_zone_blob_id" {
  description = "The DNS zone ID for the blob storage"
  type        = string
}

variable "private_dns_zone_dfs_id" {
  description = "The DNS zone ID for the Data Lake Storage Gen2"
  type        = string
}

variable "private_dns_zone_file_id" {
  description = "The DNS zone ID for the file storage"
  type        = string
}

variable "private_dns_zone_queue_id" {
  description = "The DNS zone ID for the queue storage"
  type        = string
}

variable "private_dns_zone_table_id" {
  description = "value for the DNS zone ID for the table storage"
  type        = string
}

variable "private_dns_zone_sites_id" {
  description = "The DNS zone ID for the Function app sites"
  type        = string

}

variable "function_apps" {
  description = "Map of function app configurations"
  type = map(object({
    func_name                     = string
    st_func_name                  = string
    log_name                      = string
    appi_name                     = string
    asp_name                      = string
    st_func_blob_name             = string
    st_func_dfs_name              = string
    st_func_table_name            = string
    st_func_queue_name            = string
    st_func_file_name             = string
    func_sites_name               = string
    location                      = string
    resource_group_name           = string
    subnet_id                     = string
    func_subnet_id                = string
    os_type                       = string
    sku_name                      = string
    dotnet_version                = string
    account_kind                  = string
    account_tier                  = string
    account_replication_type      = string
    is_hns_enabled                = bool
    public_network_access_enabled = bool
  }))
}

variable "default_tags" {
  type        = map(string)
  description = "Default tags to apply to all resources"
}
