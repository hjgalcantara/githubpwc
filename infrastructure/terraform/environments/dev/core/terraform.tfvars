project = "clas"
client = "moe"
environment = "dev"
region = "southeastasia"
owner = "hill.joseph.a.alcantara@pwccom"
approver = "richard.sm.chong@pwc.com"

storage_account = {
  st1 = {
    account_kind                   = "StorageV2"
    account_tier                   = "Standard"
    account_replication_type       = "LRS"
    public_network_access_enabled  = false
    is_hns_enabled                 = true
  }
}

data_factory = {
  adf1 = {
    public_network_enabled = false
  }
}

function_apps = {
  func1 = {
    os_type                      = "Windows"
    sku_name                     = "P1v2"
    dotnet_version               = "v8.0"
    account_kind                 = "StorageV2"
    account_tier                 = "Standard"
    account_replication_type     = "LRS"
    is_hns_enabled               = true
    public_network_access_enabled = false
  }
}

virtual_machines = {
  "vm1" = {
    admin_username = "vmmoeadmin"
    admin_password = "P@ssw0rd12345"
    vm_size = "Standard_D2_v3"
    os_disk_caching = "ReadWrite"
    os_disk_storage_account_type = "Standard_LRS"
    image_publisher = "MicrosoftWindowsServer"
    image_offer = "WindowsServer"
    image_sku = "2019-Datacenter"
    image_version = "latest"
    shutdown_enabled = true
    shutdown_time = "1800"
    shutdown_timezone = "Singapore Standard Time"
    shutdown_notification_enabled = false
  }
}