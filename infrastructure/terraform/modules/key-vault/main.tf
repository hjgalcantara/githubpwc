resource "azurerm_key_vault" "kv" {
  for_each = var.key_vaults

  name                          = each.value.key_vault_name
  location                      = each.value.location
  resource_group_name           = each.value.resource_group_name
  tenant_id                     = var.tenant_id
  soft_delete_retention_days    = each.value.soft_delete_retention_days
  purge_protection_enabled      = each.value.purge_protection_enabled
  sku_name                      = "standard"
  public_network_access_enabled = each.value.public_network_access_enabled
  enable_rbac_authorization     = true

  tags = var.default_tags
}

resource "azurerm_private_endpoint" "keyvault-private-endpoint" {
  for_each = {
    for k, kv in var.key_vaults : k => kv
    if !kv.public_network_access_enabled
  }

  name                = each.value.pep_kv_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  subnet_id           = var.network_subnet_id

  private_service_connection {
    name                           = "psc-${each.value.pep_kv_name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_key_vault.kv[each.key].id
    subresource_names              = ["vault"]
  }

  tags = var.default_tags
  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      var.private_dns_zone_kv_id
    ]
  }
}
