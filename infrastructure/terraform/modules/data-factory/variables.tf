variable "data_factories" {
  description = "Map of Data Factory configurations"
  type = map(object({
    adf_name               = string
    pep_adf_name           = string
    location               = string
    resource_group_name    = string
    public_network_enabled = optional(bool, true)
    subnet_id              = optional(string)
  }))
  default = {}
}

variable "private_dns_zone_adf_id" {
  description = "ID of the private DNS zone for Data Factory"
  type        = string
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}
