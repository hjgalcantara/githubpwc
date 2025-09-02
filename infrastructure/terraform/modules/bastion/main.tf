resource "azurerm_public_ip" "pip-bas" {
  for_each = var.public_ips

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  allocation_method   = each.value.allocation_method
  sku                 = each.value.sku
  tags                = var.default_tags
}

resource "azurerm_bastion_host" "bas" {
  for_each = var.bastions

  name                = each.value.name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = each.value.sku

  ip_configuration {
    name                 = "ipconfig"
    subnet_id            = each.value.subnet_id
    public_ip_address_id = azurerm_public_ip.pip-bas[each.value.public_ip_key].id
  }

  tags = var.default_tags
}
