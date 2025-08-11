output "private_dns_zone_ids" {
  description = "Map of private DNS zone IDs"
  value       = { 
    for key, dns in azurerm_private_dns_zone.dnspr : key => dns.id }
}

output "private_dns_zone_names" {
  description = "Map of private DNS zone names"
  value       = {
    for key, dns in azurerm_private_dns_zone.dnspr : key => dns.name }
}

output "private_dns_zone_vnet_link_ids" {
  description = "Map of private DNS zone virtual network link IDs"
  value       = {
    for key, link in azurerm_private_dns_zone_virtual_network_link.dnspr_vnet_link : key => link.id }
}