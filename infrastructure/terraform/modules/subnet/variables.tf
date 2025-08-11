variable "subnets" {
  description = "Map of subnets to create, where each key is a unique identifier for the subnet."
  type        = map(object({
    name                 = string
    resource_group_name = string
    virtual_network_name = string
    address_prefixes     = list(string)
    service_endpoints    = optional(list(string), [])

    delegation = optional(object({
      name = string
      service_delegation = object({
        name = string
        actions = optional(list(string), [])
      })
    }), null)
  }))
}