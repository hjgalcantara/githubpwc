# Generate a random admin password per SQL server
resource "random_password" "sql_admin_password" {
  for_each         = var.sql_servers
  length           = 16
  special          = true
  min_special      = 1
  min_numeric      = 1
  min_upper        = 1
  min_lower        = 1
  override_special = "$%&-_+{}<>"
}

# Store SQL admin login in Key Vault
resource "azurerm_key_vault_secret" "sql_admin_login" {
  for_each     = var.sql_servers
  name         = "auto-${each.key}-sql-admin-login"
  value        = each.value.administrator_login
  key_vault_id = each.value.key_vault_id
}

# Store SQL admin password in Key Vault
resource "azurerm_key_vault_secret" "sql_admin_password" {
  for_each     = var.sql_servers
  name         = "auto-${each.key}-sql-admin-password"
  value        = random_password.sql_admin_password[each.key].result
  key_vault_id = each.value.key_vault_id
}

# SQL Server
resource "azurerm_mssql_server" "sql" {
  for_each = var.sql_servers

  name                          = each.value.sql_server_name
  resource_group_name           = each.value.resource_group_name
  location                      = each.value.location
  version                       = each.value.version
  administrator_login           = azurerm_key_vault_secret.sql_admin_login[each.key].value
  administrator_login_password  = azurerm_key_vault_secret.sql_admin_password[each.key].value
  minimum_tls_version           = each.value.minimum_tls_version
  public_network_access_enabled = each.value.public_network_access_enabled

  azuread_administrator {
    login_username = each.value.login_name
    object_id      = each.value.object_id
  }

  identity {
    type = "SystemAssigned"
  }

  tags = var.default_tags
}

# Private Endpoint (only if public network is disabled)
resource "azurerm_private_endpoint" "sql_private_endpoint" {
  for_each = {
    for k, sql in var.sql_servers : k => sql
    if !sql.public_network_access_enabled
  }

  name                = each.value.pep_sql_name
  location            = azurerm_mssql_server.sql[each.key].location
  resource_group_name = azurerm_mssql_server.sql[each.key].resource_group_name
  subnet_id           = var.network_subnet_id

  private_service_connection {
    name                           = "psc-${each.value.pep_sql_name}"
    is_manual_connection           = false
    private_connection_resource_id = azurerm_mssql_server.sql[each.key].id
    subresource_names              = ["sqlServer"]
  }

  private_dns_zone_group {
    name                 = "default"
    private_dns_zone_ids = [var.private_dns_zone_sql_id]
  }

  tags = var.default_tags
}
