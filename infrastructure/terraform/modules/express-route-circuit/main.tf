resource "azurerm_public_ip" "pip_ergw" {
  for_each = var.public_ips

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  tags                = var.default_tags
}

resource "azurerm_virtual_network_gateway" "ergw" {
  for_each = var.virtual_network_gateways

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  type                = "ExpressRoute"
  vpn_type            = "RouteBased"
  active_active       = false
  sku                 = "HighPerformance"

  ip_configuration {
    name                  = "ipconfig-${each.key}"
    public_ip_address_id  = azurerm_public_ip.pip_ergw[each.value.public_ip_key].id
    subnet_id             = each.value.subnet_id
  }

  tags = var.default_tags
}

resource "azurerm_express_route_circuit" "erc" {
  for_each = var.express_route_circuits

  name                  = each.value.name
  location              = each.value.location
  resource_group_name   = each.value.resource_group_name
  service_provider_name = each.value.service_provider_name
  peering_location      = each.value.peering_location
  bandwidth_in_mbps     = each.value.bandwidth_in_mbps

  sku {
    tier   = lookup(each.value, "sku_tier", "Standard")
    family = lookup(each.value, "sku_family", "MeteredData")
  }

  tags = var.default_tags
}

resource "azurerm_express_route_circuit_peering" "private" {
  for_each = var.express_route_peers

  peering_type                = "AzurePrivatePeering"
  express_route_circuit_name  = azurerm_express_route_circuit.erc[each.value.circuit_key].name
  resource_group_name         = azurerm_express_route_circuit.erc[each.value.circuit_key].resource_group_name
  primary_peer_address_prefix = each.value.primary_peer_address_prefix
  secondary_peer_address_prefix = each.value.secondary_peer_address_prefix
  vlan_id                     = each.value.vlan_id
  peer_asn                    = each.value.peer_asn
}