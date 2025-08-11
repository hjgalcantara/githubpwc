output "bastion_names" {
  description = "Map of Bastion host names"
  value       = { for key, bastion in azurerm_bastion_host.bas : key => bastion.name } 
}

output "bastion_ids" {
  description = "Map of Bastion host IDs"
  value       = { for key, bastion in azurerm_bastion_host.bas : key => bastion.id }
}

output "public_ip_ids" {
  description = "Map of public IP IDs"
  value       = {
     for key, pip in azurerm_public_ip.pip-bas : key => pip.id }
}