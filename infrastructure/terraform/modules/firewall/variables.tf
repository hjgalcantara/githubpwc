variable "public_ips" {
  description = "Map of public IP configurations"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    allocation_method   = string
    sku                 = string
  }))
  default = {}
}

variable "firewalls" {
  description = "Map of Azure Firewalls to deploy"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku_name            = string
    sku_tier            = string
    subnet_id           = string
    policy_key          = string
    public_ip_keys      = map(string)
  }))
}

variable "firewall_policies" {
  description = "Map of firewall policy configurations"
  type = map(object({
    name                   = string
    location               = string
    resource_group_name    = string
    sku                    = string
    threat_intelligence_mode = string
    }))
    default = {}
}

variable "rule_collection_groups" {
  description = "Map of rule collection group configurations"
  type = map(object({
    policy_key  = string
    name        = string
    priority    = number
    application_rule_collections = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules    = list(object({
        name              = string
        protocol_type     = string
        protocol_port     = number
        source_addresses  = optional(list(string))
        destination_fqdns = optional(list(string))
        terminate_tls     = optional(bool)
        web_categories    = optional(list(string))
      }))
    })), [])
    network_rule_collections = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules    = list(object({
        name                  = string
        protocols             = list(string)
        source_addresses      = list(string)
        destination_addresses = list(string)
        destination_ports     = list(string)
      }))
    })), [])
    nat_rule_collections = optional(list(object({
      name     = string
      priority = number
      action   = string
      rules    = list(object({
        name                = string
        protocols           = list(string)
        source_addresses    = list(string)
        destination_address = string
        destination_ports   = list(string)
        translated_address  = string
        translated_port     = number
      }))
    })), [])
  }))
  default = {}
}

variable "default_tags" {
  description = "Default tags for resources"
  type        = map(string)
  default     = {}
}