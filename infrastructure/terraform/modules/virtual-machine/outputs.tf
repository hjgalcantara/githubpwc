output "vm_ids" {
  description = "IDs of the created virtual machines."
  value       = { for k, v in azurerm_windows_virtual_machine.vm : k => v.id }
}

output "vm_private_ips" {
  description = "Private IP addresses of the VMs."
  value       = { for k, v in azurerm_network_interface.nic : k => v.private_ip_address }
}

output "vm_admin_secret_ids" {
  description = "Key Vault secret IDs for VM admin passwords."
  value       = { for k, v in azurerm_key_vault_secret.vm_admin_password : k => v.id }
}

output "vm_nic_ids" {
  description = "IDs of network interfaces attached to the VMs."
  value       = { for k, v in azurerm_network_interface.nic : k => v.id }
}