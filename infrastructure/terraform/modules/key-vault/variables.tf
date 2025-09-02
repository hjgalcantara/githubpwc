variable "key_vaults" {
  description = "Map of key vaults to create"
  type = map(object({
    key_vault_name                = string
    location                      = string
    resource_group_name           = string
    soft_delete_retention_days    = number
    purge_protection_enabled      = bool
    public_network_access_enabled = bool
    pep_kv_name                   = string
  }))
  default = {}
}

variable "tenant_id" {
  description = "Tenant ID for the Azure subscription"
  type        = string
}

variable "network_subnet_id" {
  description = "Subnet ID for the private endpoint"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}

}

variable "private_dns_zone_kv_id" {
  description = "Private DNS zone ID for the key vault"
  type        = string
}
