# Generate a random admin password per VM
resource "random_password" "vm_admin_password" {
  for_each         = var.virtual_machines
  length           = 16
  special          = true
  min_special      = 1
  min_numeric      = 1
  min_upper        = 1
  min_lower        = 1
  override_special = "$%&-_+{}<>"
}

# Store VM admin login in Key Vault
resource "azurerm_key_vault_secret" "vm_admin_login" {
  for_each     = var.virtual_machines
  name         = "auto-${each.key}-vm-admin-login"
  value        = each.value.administrator_login
  key_vault_id = each.value.key_vault_id
}

# Store VM admin password in Key Vault
resource "azurerm_key_vault_secret" "vm_admin_password" {
  for_each     = var.virtual_machines
  name         = "auto-${each.key}-vm-admin-password"
  value        = random_password.vm_admin_password[each.key].result
  key_vault_id = each.value.key_vault_id
}

# Network Interface
resource "azurerm_network_interface" "nic" {
  for_each = var.virtual_machines

  name                = each.value.nic_name
  location            = each.value.location
  resource_group_name = each.value.resource_group_name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = each.value.subnet_id
    private_ip_address_allocation = "Dynamic"
  }

  tags = var.default_tags
}

# Windows VM
resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.virtual_machines

  name                = each.value.vm_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.vm_size
  admin_username      = azurerm_key_vault_secret.vm_admin_login[each.key].value
  admin_password      = azurerm_key_vault_secret.vm_admin_password[each.key].value

  os_disk {
    caching              = each.value.os_disk_caching
    storage_account_type = each.value.os_disk_storage_account_type
  }

  source_image_reference {
    publisher = each.value.image_publisher
    offer     = each.value.image_offer
    sku       = each.value.image_sku
    version   = each.value.image_version
  }

  identity {
    type = "SystemAssigned"
  }

  network_interface_ids = [azurerm_network_interface.nic[each.key].id]

  tags = var.default_tags
}

# Auto-shutdown schedule
resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm_shutdown_schedule" {
  for_each = var.virtual_machines

  virtual_machine_id = azurerm_windows_virtual_machine.vm[each.key].id
  location           = each.value.location
  enabled            = each.value.shutdown_enabled

  daily_recurrence_time = each.value.shutdown_time
  timezone              = each.value.shutdown_timezone

  notification_settings {
    enabled = each.value.shutdown_notification_enabled
  }

  tags = var.default_tags
}