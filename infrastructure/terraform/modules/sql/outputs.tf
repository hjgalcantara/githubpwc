output "sql_server_ids" {
  description = "IDs of the created SQL servers."
  value       = { for k, v in azurerm_mssql_server.sql : k => v.id }
}

output "sql_server_fqdns" {
  description = "Fully qualified domain names of the SQL servers."
  value       = { for k, v in azurerm_mssql_server.sql : k => v.fully_qualified_domain_name }
}

output "sql_admin_secret_ids" {
  description = "Key Vault secret IDs for SQL admin passwords."
  value       = { for k, v in azurerm_key_vault_secret.sql_admin_password : k => v.id }
}

output "sql_private_endpoint_ids" {
  description = "IDs of SQL private endpoints."
  value       = { for k, v in azurerm_private_endpoint.sql_private_endpoint : k => v.id }
}
