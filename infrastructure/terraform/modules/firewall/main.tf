resource "azurerm_public_ip" "pip-afw" {
  for_each = var.public_ips

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  tags                = var.default_tags
}

resource "azurerm_firewall_policy" "afwp" {
  for_each = var.firewall_policies

  name                     = each.value.name
  resource_group_name      = each.value.resource_group_name
  location                 = each.value.location
  sku                      = each.value.sku
  threat_intelligence_mode = each.value.threat_intelligence_mode
  tags                     = var.default_tags
}

resource "azurerm_firewall_policy_rule_collection_group" "afwp-rcg" {
  for_each = var.rule_collection_groups

  name               = each.value.name
  firewall_policy_id = azurerm_firewall_policy.afwp[each.value.policy_key].id
  priority           = each.value.priority

  # Application Rules
  dynamic "application_rule_collection" {
    for_each = try(each.value.application_rule_collections, [])
    content {
      name     = application_rule_collection.value.name
      priority = application_rule_collection.value.priority
      action   = application_rule_collection.value.action

      dynamic "rule" {
        for_each = application_rule_collection.value.rules
        content {
          name = rule.value.name
          protocols {
            type = rule.value.protocol_type
            port = rule.value.protocol_port
          }
          source_addresses  = try(rule.value.source_addresses, null)
          destination_fqdns = try(rule.value.destination_fqdns, null)
          terminate_tls     = try(rule.value.terminate_tls, false)
          web_categories    = try(rule.value.web_categories, null)
        }
      }
    }
  }

  # Network Rules
  dynamic "network_rule_collection" {
    for_each = try(each.value.network_rule_collections, [])
    content {
      name     = network_rule_collection.value.name
      priority = network_rule_collection.value.priority
      action   = network_rule_collection.value.action

      dynamic "rule" {
        for_each = network_rule_collection.value.rules
        content {
          name                  = rule.value.name
          protocols             = rule.value.protocols
          source_addresses      = rule.value.source_addresses
          destination_addresses = rule.value.destination_addresses
          destination_ports     = rule.value.destination_ports
        }
      }
    }
  }

  # NAT Rules
  dynamic "nat_rule_collection" {
    for_each = try(each.value.nat_rule_collections, [])
    content {
      name     = nat_rule_collection.value.name
      priority = nat_rule_collection.value.priority
      action   = nat_rule_collection.value.action

      dynamic "rule" {
        for_each = nat_rule_collection.value.rules
        content {
          name                = rule.value.name
          protocols           = rule.value.protocols
          source_addresses    = rule.value.source_addresses
          destination_address = rule.value.destination_address
          destination_ports   = rule.value.destination_ports
          translated_address  = rule.value.translated_address
          translated_port     = rule.value.translated_port
        }
      }
    }
  }
}

resource "azurerm_firewall" "afw" {
  for_each = var.firewalls

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku_name            = each.value.sku_name
  sku_tier            = each.value.sku_tier
  firewall_policy_id  = azurerm_firewall_policy.afwp[each.value.policy_key].id
  tags                = var.default_tags

  dynamic "ip_configuration" {
    for_each = each.value.public_ip_keys
    iterator = ip
    content {
      name                 = "ipconfig-${ip.key}"
      public_ip_address_id = azurerm_public_ip.pip-afw[ip.value].id
      subnet_id            = ip.key == "0" ? each.value.subnet_id : null
    }
  }
  depends_on = [azurerm_public_ip.pip-afw, azurerm_firewall_policy.afwp]
}
