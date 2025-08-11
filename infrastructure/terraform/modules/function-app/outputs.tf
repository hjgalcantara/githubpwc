output "function_app_names" {
  value       = { 
    for key, func in azurerm_windows_function_app.func : key => func.name }
  description = "The names of the Function Apps."
  
}

output "function_app_ids" {
  value       = { 
    for key, func in azurerm_windows_function_app.func : key => func.id }
  description = "The IDs of the Function Apps."

}
