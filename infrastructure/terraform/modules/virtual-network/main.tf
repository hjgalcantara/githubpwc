resource "azurerm_virtual_network" "vnet" {
    for_each = var.virtual_networks
    
    name                = each.value.name
    address_space       = each.value.address_space
    location            = each.value.location
    resource_group_name = each.value.resource_group_name
    tags                = var.default_tags
    
    lifecycle {
        ignore_changes = [
        tags,
        ]
    }
}

resource "azurerm_virtual_network_peering" "vnet_peering" {
    for_each = var.virtual_network_peerings

    name                      = each.value.name
    resource_group_name       = each.value.resource_group_name
    virtual_network_name      = each.value.virtual_network_name
    remote_virtual_network_id = each.value.remote_virtual_network_id
    allow_virtual_network_access = each.value.allow_virtual_network_access
    allow_forwarded_traffic      = each.value.allow_forwarded_traffic
    allow_gateway_transit        = each.value.allow_gateway_transit
    use_remote_gateways          = each.value.use_remote_gateways
}