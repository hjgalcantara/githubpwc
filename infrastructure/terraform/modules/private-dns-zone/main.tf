resource "azurerm_private_dns_zone" "dnspr" {
    for_each = var.private_dns_zones
  name                = each.value.name
  resource_group_name = each.value.resource_group_name
  tags                = var.default_tags
}

resource "azurerm_private_dns_zone_virtual_network_link" "dnspr_vnet_link" {
  for_each = var.vnet_links

  name                  = each.key
  resource_group_name   = each.value.resource_group_name
  private_dns_zone_name = azurerm_private_dns_zone.dnspr[each.value.zone_key].name
  virtual_network_id    = each.value.virtual_network_id
  registration_enabled  = "false"
  tags                  = var.default_tags
}
