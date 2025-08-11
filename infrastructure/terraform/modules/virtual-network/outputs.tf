output "virtual_network_names" {
  value = { 
    for key, vnet in azurerm_virtual_network.vnet : key => vnet.name
  }
  description = "The names of the virtual networks."
}

output "virtual_network_ids" {
  value = { 
    for key, vnet in azurerm_virtual_network.vnet : key => vnet.id 
  }
}