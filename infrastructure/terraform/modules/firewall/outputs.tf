output "firewall_ids" {
  description = "Map of firewall IDs"
  value = {
  for key, afw in azurerm_firewall.afw : key => afw.id }
}

output "firewall_private_ips" {
  description = "Map of firewall private IPs"
  value = {
  for key, afw in azurerm_firewall.afw : key => afw.ip_configuration[0].private_ip_address }
}

output "policy_ids" {
  description = "Map of firewall policy IDs"
  value = {
  for key, afwp in azurerm_firewall_policy.afwp : key => afwp.id }
}

output "public_ip_ids" {
  description = "Map of public IP IDs"
  value = {
  for key, pip in azurerm_public_ip.pip-afw : key => pip.id }
}