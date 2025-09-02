resource "azurerm_databricks_workspace" "dbw" {
  for_each = var.databricks_workspaces

  name                                  = each.value.databricks_workspace_name
  resource_group_name                   = each.value.resource_group_name
  location                              = each.value.location
  sku                                   = "Premium"
  managed_resource_group_name           = each.value.managed_resource_group_name
  public_network_access_enabled         = each.value.public_network_access_enabled
  network_security_group_rules_required = each.value.network_security_group_rules_required

  custom_parameters {
    public_subnet_name                                   = each.value.public_subnet_name
    private_subnet_name                                  = each.value.private_subnet_name
    no_public_ip                                         = each.value.no_public_ip
    virtual_network_id                                   = each.value.virtual_network_id
    public_subnet_network_security_group_association_id  = each.value.public_subnet_network_security_group_association_id
    private_subnet_network_security_group_association_id = each.value.private_subnet_network_security_group_association_id
  }

  tags = var.default_tags
}

resource "azurerm_databricks_access_connector" "dbw_connector" {
  for_each = var.databricks_workspaces

  name                = each.value.databricks_access_connector_name
  resource_group_name = azurerm_databricks_workspace.dbw[each.key].resource_group_name
  location            = azurerm_databricks_workspace.dbw[each.key].location

  identity {
    type = "SystemAssigned"
  }

  tags = var.default_tags
}
