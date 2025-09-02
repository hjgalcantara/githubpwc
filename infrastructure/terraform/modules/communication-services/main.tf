resource "azurerm_communication_service" "acs" {
  for_each = var.communication_services

  name                = each.value.communication_service_name
  resource_group_name = each.value.resource_group_name
  data_location       = each.value.data_location
  tags                = var.default_tags
}
