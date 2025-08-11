variable "private_dns_zones" {
  description = "Map of private DNS zones to create."
  type = map(object({
    name                = string
    resource_group_name = string
  }))
  default = {}
}

variable "vnet_links" {
  description = "Map of virtual network links to create."
  type = map(object({
    zone_key            = string
    resource_group_name = string
    virtual_network_id  = string
  }))
  default = {}
}
variable "default_tags" {
  description = "Default tags to be applied to the private DNS zones and links."
  type        = map(string)
  default     = {}
}