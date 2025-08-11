output "communication_service_ids" {
  value = { 
    for key, acs in azurerm_communication_service.acs : key => acs.id }
}

output "acs_primary_connection_string" {
  value = { 
    for key, acs in azurerm_communication_service.acs : key => acs.primary_connection_string }
}

output "acs_secondary_connection_string" {
  value = { 
    for key, acs in azurerm_communication_service.acs : key => acs.secondary_connection_string }
}

output "communication_service_hostnames" {
  value = { 
    for key, acs in azurerm_communication_service.acs : key => acs.hostname }
}