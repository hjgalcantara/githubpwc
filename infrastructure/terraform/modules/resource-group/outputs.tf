output "resource_group_names" {
  value = { 
    for key, rg in azurerm_resource_group.rg : key => rg.name 
  }
  description = "Map of input keys to resource group names"
}

output "resource_group_ids" {
  value = { 
    for key, rg in azurerm_resource_group.rg : key => rg.id 
  }
}