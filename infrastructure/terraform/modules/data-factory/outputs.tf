output "data_factories_names" {
  value = {
    for key, df in azurerm_data_factory.adf : key => df.name
  }
  description = "Map of Data Factory names."
}

output "data_factories_ids" {
  value = {
    for key, df in azurerm_data_factory.adf : key => df.id
  }
  description = "Map of Data Factory IDs."
}

output "data_factories_system_assigned_identity_principal_ids" {
  value = {
    for key, df in azurerm_data_factory.adf : key => df.identity[0].principal_id
  }
  description = "Map of Data Factory system-assigned identity principal IDs."
}
