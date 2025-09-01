variable "default_tags" {
  description = "Tags applied to all resources"
  type        = map(string)
  default     = {}
}

variable "public_ips" {
  description = "Map of Public IPs for ER Gateways"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    allocation_method   = string
    sku                 = string
  }))
}

variable "virtual_network_gateways" {
  description = "Map of Virtual Network Gateways"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    subnet_id           = string
    public_ip_key       = string # must match a key in var.public_ips
  }))
}

variable "express_route_circuits" {
  description = "Map of ExpressRoute circuits"
  type = map(object({
    name                  = string
    location              = string
    resource_group_name   = string
    service_provider_name = string
    peering_location      = string
    bandwidth_in_mbps     = number
    sku_tier              = optional(string, "Standard")
    sku_family            = optional(string, "MeteredData")
  }))
}

variable "express_route_peers" {
  description = "Map of ExpressRoute circuit private peerings"
  type = map(object({
    circuit_key                = string # must match a key in var.express_route_circuits
    primary_peer_address_prefix   = string
    secondary_peer_address_prefix = string
    vlan_id                       = number
    peer_asn                      = number
  }))
}