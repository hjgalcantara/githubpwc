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

variable "public_ip" {
    description = "Map of public IPs to create."
    type = map(object({
        allocation_method = string
        sku               = string
    }))
    default = {}
}

variable "firewall" {
    description = "Map of firewall configurations."
    type = map(object({
        sku_name            = string
        sku_tier            = string
        policy_key          = string
    }))
    default = {} 
}

variable "firewall_policy" {
    description = "Map of firewall policy configurations."
    type = map(object({
        sku                    = string
        threat_intelligence_mode = string
        }))
    default = {}
}

variable "rule_collection_groups" {
    description = "Map of rule collection group configurations."
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
                name                  = string
                protocols             = list(string)
                source_addresses      = list(string)
                destination_addresses = list(string)
                destination_ports     = list(string)
            }))
        })), [])
    }))
    default = {}
}