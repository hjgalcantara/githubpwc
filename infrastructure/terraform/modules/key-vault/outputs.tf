output "key_vault_names" {
  value = {
  for key, kv in azurerm_key_vault.kv : key => kv.name }
  description = "The names of the Key Vaults."

}

output "key_vault_ids" {
  value = {
  for key, kv in azurerm_key_vault.kv : key => kv.id }
  description = "The IDs of the Key Vaults."

}
