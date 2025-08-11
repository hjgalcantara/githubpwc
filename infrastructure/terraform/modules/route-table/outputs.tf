output "route_table_ids" {
  description = "Map of created route tables"
  value = { for k, rt in azurerm_route_table.rt : k => rt.id }
}

output "subnet_route_table_associations" {
  description = "Map of subnet to route table associations"
  value = { for k, assoc in azurerm_subnet_route_table_association.rt_subnet_association : k => assoc.id }
}