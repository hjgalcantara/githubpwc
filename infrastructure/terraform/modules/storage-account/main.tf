resource "azurerm_storage_account" "st"   {
    for_each = var.storage_accounts

    name = each.value.st_name
    resource_group_name = each.value.resource_group_name
    location = each.value.location
    account_kind = each.value.account_kind
    account_tier = each.value.account_tier
    account_replication_type = each.value.account_replication_type
    public_network_access_enabled = each.value.public_network_access_enabled
    is_hns_enabled = each.value.is_hns_enabled

    tags = var.default_tags
}

resource "azurerm_private_endpoint" "blob-private-endpoint" {
  for_each = { 
    for k, st in var.storage_accounts : 
    k => st 
    if !st.public_network_access_enabled
  }
  
  name                = each.value.pep_st_blob_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  subnet_id           = var.storage_accounts[each.key].subnet_id

  private_service_connection {
    name                           = "psc-${each.value.pep_st_blob_name}"
    private_connection_resource_id = azurerm_storage_account.st[each.key].id
    is_manual_connection           = false
    subresource_names              = ["blob"]
  }

  tags = var.default_tags

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      var.private_dns_zone_blob_id
    ]
  }
}

resource "azurerm_private_endpoint" "dfs-private-endpoint" {
  for_each = { 
    for k, st in var.storage_accounts : 
    k => st 
    if !st.public_network_access_enabled
  }

  name                = each.value.pep_st_dfs_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  subnet_id           = var.storage_accounts[each.key].subnet_id

  private_service_connection {
    name                           = "psc-${each.value.pep_st_dfs_name}"
    private_connection_resource_id = azurerm_storage_account.st[each.key].id
    is_manual_connection           = false
    subresource_names              = ["dfs"]
  }

  tags = var.default_tags

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      var.private_dns_zone_dfs_id
    ]
  }
}