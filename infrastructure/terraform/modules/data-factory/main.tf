resource "azurerm_data_factory" "adf" {
  for_each = var.data_factories

  name                   = each.value.adf_name
  location               = each.value.location
  resource_group_name    = each.value.resource_group_name
  public_network_enabled = each.value.public_network_enabled

  identity {
    type = "SystemAssigned"
  }

  tags = var.default_tags
}

resource "azurerm_private_endpoint" "adf-private-endpoint" {
  for_each = {
    for k, df in var.data_factories :
    k => df
    if !df.public_network_enabled
  }

  name                = each.value.pep_adf_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  subnet_id           = var.data_factories[each.key].subnet_id

  private_service_connection {
    name                           = "psc-${each.value.pep_adf_name}"
    private_connection_resource_id = azurerm_data_factory.adf[each.key].id
    is_manual_connection           = false
    subresource_names              = ["dataFactory"]
  }

  tags = var.default_tags

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      var.private_dns_zone_adf_id
    ]
  }
}

