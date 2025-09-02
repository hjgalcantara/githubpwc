variable "sql_servers" {
  description = "Map of SQL Server configurations."
  type = map(object({
    sql_server_name               = string
    administrator_login           = string
    resource_group_name           = string
    location                      = string
    version                       = string
    minimum_tls_version           = string
    public_network_access_enabled = bool
    login_name                    = string
    object_id                     = string
    key_vault_id                  = string
    pep_sql_name                  = string
  }))
}

variable "network_subnet_id" {
  description = "Subnet ID for the SQL private endpoint."
  type        = string
}

variable "private_dns_zone_sql_id" {
  description = "Private DNS zone ID for SQL Server."
  type        = string
}

variable "default_tags" {
  description = "Tags applied to all resources."
  type        = map(string)
  default     = {}
}
