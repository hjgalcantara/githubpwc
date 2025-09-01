output "public_ip_ids" {
  description = "IDs of the created Public IPs"
  value       = { for k, v in azurerm_public_ip.pip_ergw : k => v.id }
}

output "virtual_network_gateway_ids" {
  description = "IDs of the created Virtual Network Gateways"
  value       = { for k, v in azurerm_virtual_network_gateway.ergw : k => v.id }
}

output "express_route_circuit_ids" {
  description = "IDs of the created ExpressRoute circuits"
  value       = { for k, v in azurerm_express_route_circuit.erc : k => v.id }
}

output "express_route_peering_ids" {
  description = "IDs of the created ExpressRoute private peerings"
  value       = { for k, v in azurerm_express_route_circuit_peering.private : k => v.id }
}