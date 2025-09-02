output "databricks_workspace_ids" {
  description = "IDs of the created Databricks workspaces."
  value       = { for k, v in azurerm_databricks_workspace.dbw : k => v.id }
}

output "databricks_access_connector_ids" {
  description = "IDs of the created Databricks access connectors."
  value       = { for k, v in azurerm_databricks_access_connector.dbw_connector : k => v.id }
}

output "databricks_workspace_urls" {
  description = "Workspace URLs for Databricks."
  value       = { for k, v in azurerm_databricks_workspace.dbw : k => v.workspace_url }
}
