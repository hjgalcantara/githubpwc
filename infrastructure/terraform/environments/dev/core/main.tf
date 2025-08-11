locals {
  default_tags = {
    projectName  = var.project
    clientName   = var.client
    environment  = var.environment
    ownerName    = var.owner
    approverName = var.approver
    createdBy    = "terraform"
  }
  client       = var.client
  project      = var.project
  environment  = var.environment
  region       = var.region
}

module "storage_account" {
  source = "../../../modules/storage-account"

  storage_accounts = {
    st1 = {
      st_name                           = "st${local.client}${local.project}${local.environment}01"
      pep_st_blob_name               = "pep-st-${local.client}${local.project}-${local.environment}-01"
      pep_st_dfs_name               = "pep-st-${local.client}${local.project}-${local.environment}-02"
      resource_group_name            = data.terraform_remote_state.network.outputs.resource_group_names["rg2"]
      location                       = local.region
      account_kind                   = var.storage_account["st1"].account_kind
      account_tier                   = var.storage_account["st1"].account_tier
      account_replication_type       = var.storage_account["st1"].account_replication_type
      public_network_access_enabled  = var.storage_account["st1"].public_network_access_enabled
      is_hns_enabled                 = var.storage_account["st1"].is_hns_enabled
      subnet_id                      = data.terraform_remote_state.network.outputs.subnet_ids["snet2"]
    }
  }
    private_dns_zone_blob_id            = data.terraform_remote_state.network.outputs.private_dns_zone_ids["dnspr2"]
    private_dns_zone_dfs_id             = data.terraform_remote_state.network.outputs.private_dns_zone_ids["dnspr3"]
    default_tags = local.default_tags
}

module "data_factory" {
  source = "../../../modules/data-factory"

  data_factories = {
    adf1 = {
      adf_name                    = "adf-${local.client}${local.project}-${local.environment}-01"
      pep_adf_name            = "pep-adf-${local.client}${local.project}-${local.environment}-01"
      location                = local.region
      resource_group_name     = data.terraform_remote_state.network.outputs.resource_group_names["rg2"]
      public_network_enabled  = var.data_factory["adf1"].public_network_enabled
      subnet_id               = data.terraform_remote_state.network.outputs.subnet_ids["snet2"]
    }
  }
  private_dns_zone_adf_id = data.terraform_remote_state.network.outputs.private_dns_zone_ids["dnspr1"]
  default_tags            = local.default_tags
}

module "function_app" {
  source = "../../../modules/function-app"

function_apps = {
    func1 = {
      func_name                      = "func-${local.client}${local.project}-${local.environment}-01"
      st_func_name                   = "stfunc${local.client}${local.project}${local.environment}01"
      log_name                       = "log-${local.client}${local.project}-${local.environment}-01"
      appi_name                      = "appi-${local.client}${local.project}-${local.environment}-01"
      asp_name                       = "asp-${local.client}${local.project}-${local.environment}-01"
      st_func_blob_name             = "pep-st-func-${local.client}${local.project}-${local.environment}-01"
      st_func_dfs_name              = "pep-st-func-${local.client}${local.project}-${local.environment}-02"
      st_func_table_name            = "pep-st-func-${local.client}${local.project}-${local.environment}-03"
      st_func_queue_name            = "pep-st-func-${local.client}${local.project}-${local.environment}-04"
      st_func_file_name             = "pep-st-func-${local.client}${local.project}-${local.environment}-05"
      func_sites_name               = "pep-func-${local.client}${local.project}-${local.environment}-01"
      location                    = local.region
      resource_group_name           = data.terraform_remote_state.network.outputs.resource_group_names["rg2"]
      func_subnet_id                = data.terraform_remote_state.network.outputs.subnet_ids["snet3"]
      subnet_id                     = data.terraform_remote_state.network.outputs.subnet_ids["snet2"]
      os_type                       = var.function_apps["func1"].os_type
      sku_name                      = var.function_apps["func1"].sku_name
      dotnet_version                = var.function_apps["func1"].dotnet_version
      account_kind                  = var.function_apps["func1"].account_kind
      account_tier                  = var.function_apps["func1"].account_tier
      account_replication_type      = var.function_apps["func1"].account_replication_type
      is_hns_enabled                = var.function_apps["func1"].is_hns_enabled
      public_network_access_enabled = var.function_apps["func1"].public_network_access_enabled
    }
  }

  private_dns_zone_blob_id  = data.terraform_remote_state.network.outputs.private_dns_zone_ids["dnspr2"]
  private_dns_zone_dfs_id   = data.terraform_remote_state.network.outputs.private_dns_zone_ids["dnspr3"]
  private_dns_zone_file_id  = data.terraform_remote_state.network.outputs.private_dns_zone_ids["dnspr8"]
  private_dns_zone_table_id = data.terraform_remote_state.network.outputs.private_dns_zone_ids["dnspr6"]
  private_dns_zone_queue_id = data.terraform_remote_state.network.outputs.private_dns_zone_ids["dnspr7"]
  private_dns_zone_sites_id = data.terraform_remote_state.network.outputs.private_dns_zone_ids["dnspr4"]

  default_tags = local.default_tags
}


module "virtual_machine" {
  source = "../../../modules/virtual-machine"

  virtual_machines = {
    "vm1" = {
      vm_name   = "vm${local.client}${local.project}ado" #vmmoeclasado
      resource_group_name = data.terraform_remote_state.network.outputs.resource_group_names["rg3"]
      location  = local.region
      vm_size = var.virtual_machines["vm1"].vm_size #"Standard_D2_v3"
      admin_username = var.virtual_machines["vm1"].admin_username
      admin_password = var.virtual_machines["vm1"].admin_password
      nic_name = "nic-ado-${local.client}${local.project}-${local.environment}-01"
      subnet_id = data.terraform_remote_state.network.outputs.subnet_ids["snet5"]
      os_disk_caching = var.virtual_machines["vm1"].os_disk_caching #ReadWrite
      os_disk_storage_account_type = var.virtual_machines["vm1"].os_disk_storage_account_type #Standard_LRS
      image_publisher = var.virtual_machines["vm1"].image_publisher #MicrosoftWindowsServer
      image_offer = var.virtual_machines["vm1"].image_offer #WindowsServer
      image_sku = var.virtual_machines["vm1"].image_sku #2019-Datacenter
      image_version = var.virtual_machines["vm1"].image_version #latest
      shutdown_enabled             = var.virtual_machines["vm1"].shutdown_enabled
      shutdown_time                = var.virtual_machines["vm1"].shutdown_time #"1800"
      shutdown_timezone            = var.virtual_machines["vm1"].shutdown_timezone #Singapore Standard Time
      shutdown_notification_enabled = var.virtual_machines["vm1"].shutdown_notification_enabled
    }
  }
  default_tags = local.default_tags
}