variable "project" {
    description = "The name of the project."
    type        = string
}

variable "client"  {
    description = "The name of the client."
    type        = string
}

variable "environment" {
    description = "The environment (e.g., dev, prod)."
    type        = string
}

variable "region" {
    description = "The Azure region where resources will be deployed."
    type        = string
}

variable "owner" {
    description = "The name of the owner of the resources."
    type        = string
}

variable "approver" {
    description = "The name of the approver for the resources."
    type        = string
}

variable "virtual_networks" {
    description = "A map of virtual networks to be created."
    type = map(object({
        address_space = list(string)
    }))
    default = {}
}

variable "subnets" {
    description = "A map of subnets to be created within the virtual networks."
    type = map(object({
        address_prefixes = list(string)
    }))
    default = {}
}

variable "nsg_security_rules" {
  type = map(list(object({
    name                         = string
    priority                     = number
    direction                    = string
    access                       = string
    protocol                     = string
    source_port_range            = optional(string)
    source_port_ranges           = optional(list(string))
    destination_port_range       = optional(string)
    destination_port_ranges      = optional(list(string))
    source_address_prefix        = optional(string)
    source_address_prefixes      = optional(list(string))
    destination_address_prefix   = optional(string)
    destination_address_prefixes = optional(list(string))
  })))
  default = {}
}

variable "public_ips" {
    description = "A map of public IPs to be created."
    type = map(object({
        allocation_method = string
        sku               = optional(string, "Basic")
    }))
    default = {}
}

variable "bastions" {
    description = "A map of Azure Bastion configurations."
    type = map(object({
        sku                 = string
    }))
    default = {}
}

variable "key_vaults" {
    description = "A map of Azure Key Vault configurations."
    type = map(object({
        soft_delete_retention_days = number
        purge_protection_enabled    = bool
        public_network_access_enabled = bool
    }))
    default = {}
}

variable "route_tables" {
  description = "Route table definitions and their associated routes"
  type = map(object({
    routes = optional(list(object({
      name                   = string
      address_prefix         = string
      next_hop_type          = string
      next_hop_in_ip_address = optional(string)
    })), [])
  }))
}