resource "azurerm_storage_account" "st-func" {
  for_each = var.function_apps

  name = each.value.st_func_name
  resource_group_name = each.value.resource_group_name
  location = each.value.location
  account_kind = each.value.account_kind
  account_tier = each.value.account_tier
  account_replication_type = each.value.account_replication_type
  public_network_access_enabled = each.value.public_network_access_enabled
  is_hns_enabled = each.value.is_hns_enabled

  tags = var.default_tags
  
}

resource "azurerm_log_analytics_workspace" "log" {
  for_each = var.function_apps

  name                = each.value.log_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  sku                 = "PerGB2018"
  retention_in_days   = 30

  tags = var.default_tags
}

resource "azurerm_application_insights" "appi" {
  for_each = var.function_apps

  name                = each.value.appi_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  workspace_id        = azurerm_log_analytics_workspace.log[each.key].id
  application_type    = "web"

  tags = var.default_tags
}

resource "azurerm_service_plan" "asp" {
  for_each = var.function_apps

  name                = each.value.asp_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  os_type             = each.value.os_type
  sku_name            = each.value.sku_name

  tags                = var.default_tags
}

resource "azurerm_windows_function_app" "func" {
  for_each = var.function_apps

  name                = each.value.func_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name
  storage_account_name = azurerm_storage_account.st-func[each.key].name
  storage_account_access_key = azurerm_storage_account.st-func[each.key].primary_access_key
  virtual_network_subnet_id = each.value.func_subnet_id
  service_plan_id     = azurerm_service_plan.asp[each.key].id
  public_network_access_enabled = each.value.public_network_access_enabled

  app_settings = {
    FUNCTIONS_EXTENSION_VERSION = "~4"
    WEBSITE_RUN_FROM_PACKAGE = "1"
    APPINSIGHTS_INSTRUMENTATIONKEY = azurerm_application_insights.appi[each.key].instrumentation_key
  }

  site_config {
    application_stack {
      dotnet_version = each.value.dotnet_version
    }
  }

  identity {
    type = "SystemAssigned"
  }

  tags                          = var.default_tags
}


resource "azurerm_private_endpoint" "st-func-blob-private-endpoint" {
  for_each = {
    for k, func in var.function_apps : k => func
    if !func.public_network_access_enabled
  }

  name                = each.value.st_func_blob_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  subnet_id           = var.function_apps[each.key].subnet_id

  private_service_connection {
    name                           = "psc-${each.value.st_func_blob_name}"
    private_connection_resource_id = azurerm_storage_account.st-func[each.key].id
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

resource "azurerm_private_endpoint" "st-func-dfs-private-endpoint" {
  for_each = {
    for k, func in var.function_apps : k => func
    if !func.public_network_access_enabled
  }

  name                = each.value.st_func_dfs_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  subnet_id           = var.function_apps[each.key].subnet_id

  private_service_connection {
    name                           = "psc-${each.value.st_func_dfs_name}"
    private_connection_resource_id = azurerm_storage_account.st-func[each.key].id
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

resource "azurerm_private_endpoint" "st-func-table-private-endpoint" {
  for_each = {
    for k, func in var.function_apps : k => func
    if !func.public_network_access_enabled
  }

  name                = each.value.st_func_table_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  subnet_id           = var.function_apps[each.key].subnet_id

  private_service_connection {
    name                           = "psc-${each.value.st_func_table_name}"
    private_connection_resource_id = azurerm_storage_account.st-func[each.key].id
    is_manual_connection           = false
    subresource_names              = ["table"]
  }
  tags = var.default_tags
  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      var.private_dns_zone_table_id
    ]
  }
}

resource "azurerm_private_endpoint" "st-func-queue-private-endpoint" {
  for_each = {
    for k, func in var.function_apps : k => func
    if !func.public_network_access_enabled
  }

  name                = each.value.st_func_queue_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  subnet_id           = var.function_apps[each.key].subnet_id

  private_service_connection {
    name                           = "psc-${each.value.st_func_queue_name}"
    private_connection_resource_id = azurerm_storage_account.st-func[each.key].id
    is_manual_connection           = false
    subresource_names              = ["queue"]
  }
  tags = var.default_tags
  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      var.private_dns_zone_queue_id
    ]
  }
}

resource "azurerm_private_endpoint" "st-func-file-private-endpoint" {
  for_each = {
    for k, func in var.function_apps : k => func
    if !func.public_network_access_enabled
  }

  name                = each.value.st_func_file_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  subnet_id           = var.function_apps[each.key].subnet_id

  private_service_connection {
    name                           = "psc-${each.value.st_func_file_name}"
    private_connection_resource_id = azurerm_storage_account.st-func[each.key].id
    is_manual_connection           = false
    subresource_names              = ["file"]
  }
  tags = var.default_tags
  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      var.private_dns_zone_file_id
    ]
  }
}

resource "azurerm_private_endpoint" "func-private-endpoint" {
  for_each = {
    for k, func in var.function_apps : k => func
    if !func.public_network_access_enabled
  }

  name                = each.value.func_sites_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  subnet_id           = var.function_apps[each.key].subnet_id

  private_service_connection {
    name                           = "psc-${each.value.func_sites_name}"
    private_connection_resource_id = azurerm_windows_function_app.func[each.key].id
    is_manual_connection           = false
    subresource_names              = ["sites"]
  }

  tags = var.default_tags

  private_dns_zone_group {
    name = "default"
    private_dns_zone_ids = [
      var.private_dns_zone_sites_id
      ]
  }
}