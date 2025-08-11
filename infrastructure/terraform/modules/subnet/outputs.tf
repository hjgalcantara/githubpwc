output "subnet_names" {
  value = { 
    for key, subnet in azurerm_subnet.subnet : key => subnet.name
  }
  description = "The names of the subnets."
}

output "subnet_ids" {
  value       = { 
    for key, subnet in azurerm_subnet.subnet : key => subnet.id }
  description = "The IDs of the subnets."
}

output "subnet_addresses" {
  value       = { 
    for key, subnet in azurerm_subnet.subnet : key => subnet.address_prefixes }
  description = "The address prefixes of the subnets."
}