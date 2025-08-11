output "public_ip_names" {
  value = { 
    for key, pip in azurerm_public_ip.pip : key => pip.name 
  }
  description = "Map of public IP names by key."
}

output "public_ip_ids" {
  value = { 
    for key, pip in azurerm_public_ip.pip : key => pip.id 
  }
  description = "Map of public IP IDs by key."
}