variable "virtual_networks" {
  description = "A map of virtual networks to be created."
  type = map(object({
    name                = string
    address_space       = list(string)
    location            = string
    resource_group_name = string
  }))
}

variable "virtual_network_peerings" {
  description = "Map of virtual network peerings to create, where each key is a unique identifier for the peering."
  type = map(object({
    name                      = string
    resource_group_name       = string
    virtual_network_name      = string
    remote_virtual_network_id = string
    allow_virtual_network_access = optional(bool, true)
    allow_forwarded_traffic      = optional(bool, false)
    allow_gateway_transit        = optional(bool, false)
    use_remote_gateways          = optional(bool, false)
  }))
  default = {}
}

variable "default_tags" {
  description = "Default tags to be applied to the virtual networks."
  type        = map(string)
}