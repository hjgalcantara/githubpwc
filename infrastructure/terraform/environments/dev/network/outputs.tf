output "resource_group_names" {
  value       = module.resource_group.resource_group_names
  description = "Map of resource group names by key."
}

output "virtual_network_names" {
  value       = module.virtual_network.virtual_network_names
  description = "Map of virtual network names by key."
}

output "virtual_network_ids" {
  value       = module.virtual_network.virtual_network_ids
  description = "Map of virtual network IDs by key."
}

output "subnet_names" {
  value       = module.subnet.subnet_names
  description = "Map of subnet names by key."
}

output "subnet_ids" {
  value       = module.subnet.subnet_ids
  description = "Map of subnet IDs by key."
}

output "subnet_addresses" {
  value       = module.subnet.subnet_addresses
  description = "Map of subnet address prefixes by key."
}

output "network_security_group_names" {
  value       = module.network_security_group.network_security_group_names
  description = "Map of NSG names by key."
}

output "network_security_group_ids" {
  value       = module.network_security_group.network_security_group_ids
  description = "Map of NSG IDs by key."
}

output "private_dns_zone_ids" {
  value       = module.private_dns_zone.private_dns_zone_ids
  description = "Map of private DNS zone IDs by key." 
}

output "key_vault_names" {
  value = module.key_vault.key_vault_names
  description = "Map of key vault names by key."
}

output "key_vault_ids" {
  value = module.key_vault.key_vault_ids
  description = "Map of key vauld resource IDs by key"
}