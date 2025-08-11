variable "route_tables" {
  description = "Map of route tables and their routes"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), [])
  }))
}

variable "subnet_route_table_associations" {
  description = "Map of subnet to route table associations"
  type = map(object({
    subnet_id      = string
    route_table_id = string
  }))
}

variable "default_tags" {
  description = "Default tags applied to all resources"
  type        = map(string)
  default     = {}
}
