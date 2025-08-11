output "network_security_group_names" {
  value       = { 
    for key, nsg in azurerm_network_security_group.nsg : key => nsg.name }
  description = "The names of the network security groups."
}

output "network_security_group_ids" {
  value       = { 
    for key, nsg in azurerm_network_security_group.nsg : key => nsg.id }
  description = "The IDs of the network security groups."
}