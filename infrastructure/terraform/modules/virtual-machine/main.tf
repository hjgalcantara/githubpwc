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

resource "azurerm_windows_virtual_machine" "vm" {
  for_each = var.virtual_machines

  name                = each.value.vm_name
  resource_group_name = each.value.resource_group_name
  location            = each.value.location
  size                = each.value.vm_size
  admin_username      = each.value.admin_username
  admin_password      = each.value.admin_password

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

resource "azurerm_dev_test_global_vm_shutdown_schedule" "vm_shutdown_sched" {
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
