variable "storage_accounts" {
  description = "Map of storage accounts to create"
  type        = map(object({
    st_name                           = string
    pep_st_blob_name = string
    pep_st_dfs_name = string
    resource_group_name            = string
    location                       = string
    account_kind                   = string
    account_tier                   = string
    account_replication_type       = string
    public_network_access_enabled  = bool
    is_hns_enabled                 = bool
    subnet_id                      = string
  }))
}

variable "private_dns_zone_blob_id" {
  description = "The DNS zone ID for the blob storage"
  type        = string
}

variable "private_dns_zone_dfs_id" {
  description = "The DNS zone ID for the Data Lake Storage Gen2"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}