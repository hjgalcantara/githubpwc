variable "network_security_groups" {
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
  }))
}

variable "security_rules" {
  type = map(list(object({
    name                       = string
    priority                   = number
    direction                  = string
    access                     = string
    protocol                   = string
    source_port_range          = optional(string)
    destination_port_range     = optional(string)
    destination_port_ranges    = optional(list(string))
    source_address_prefix      = optional(string)
    destination_address_prefix = optional(string)
  })))
  default = {}
}

variable "subnet_nsg_associations" {
  description = "Map of subnet to network security group associations, where each key is a unique identifier for the association."
  type = map(object({
    subnet_id                 = string
    network_security_group_id = string
  }))
  default = {}
}

variable "default_tags" {
  description = "Default tags to be applied to the network security groups."
  type        = map(string)
  default     = {}
}
