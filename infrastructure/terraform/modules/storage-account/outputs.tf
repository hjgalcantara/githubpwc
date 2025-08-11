output "storage_account_ids" {
  value = { 
    for key, st in azurerm_storage_account.st : key => st.id 
  }
  description = "Map of storage account IDs."
}

output "storage_account_names" {
  value = {
    for key, st in azurerm_storage_account.st : key => st.name
  }
  description = "Map of storage account names."
}