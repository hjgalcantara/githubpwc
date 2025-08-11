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

module "resource_group" {
  source = "../../../modules/resource-group"

  resource_groups = {
    "rg1" = {
      name     = "rg-${local.client}${local.project}-${local.environment}-lz"
      location = local.region
    }
    "rg2" = {
      name     = "rg-${local.client}${local.project}-${local.environment}-wl"
      location = local.region
    }
    "rg3" = {
      name     = "rg-${local.client}${local.project}-${local.environment}-mgt"
      location = local.region
    }
  }
  default_tags = local.default_tags
}

module "virtual_network" {
  source = "../../../modules/virtual-network"

  virtual_networks = {
    "vnet1" = {
      name = "vnet-${local.client}${local.project}-${local.environment}-lz"
      address_space = var.virtual_networks["vnet1"].address_space
      location = local.region
      resource_group_name = module.resource_group.resource_group_names["rg1"]
    }
    "vnet2" = {
      name = "vnet-${local.client}${local.project}-${local.environment}-wl"
      address_space = var.virtual_networks["vnet2"].address_space
      location = local.region
      resource_group_name = module.resource_group.resource_group_names["rg2"]
    }
    vnet3 = {
      name = "vnet-${local.client}${local.project}-${local.environment}-mgt"
      address_space = var.virtual_networks["vnet3"].address_space
      location = local.region
      resource_group_name = module.resource_group.resource_group_names["rg3"]
    }
  }

  virtual_network_peerings = {
    "vnet1-vnet2" = {
      name                      = "${module.virtual_network.virtual_network_names["vnet1"]}-peer-to-${module.virtual_network.virtual_network_names["vnet2"]}"
      resource_group_name       = module.resource_group.resource_group_names["rg1"]
      virtual_network_name      = module.virtual_network.virtual_network_names["vnet1"]
      remote_virtual_network_id = module.virtual_network.virtual_network_ids["vnet2"]
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
    "vnet2-vnet1" = {
      name                      = "${module.virtual_network.virtual_network_names["vnet2"]}-peer-to-${module.virtual_network.virtual_network_names["vnet1"]}"
      resource_group_name       = module.resource_group.resource_group_names["rg2"]
      virtual_network_name      = module.virtual_network.virtual_network_names["vnet2"]
      remote_virtual_network_id = module.virtual_network.virtual_network_ids["vnet1"]
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
    "vnet2-vnet3" = {
      name                      = "${module.virtual_network.virtual_network_names["vnet2"]}-peer-to-${module.virtual_network.virtual_network_names["vnet3"]}"
      resource_group_name       = module.resource_group.resource_group_names["rg2"]
      virtual_network_name      = module.virtual_network.virtual_network_names["vnet2"]
      remote_virtual_network_id = module.virtual_network.virtual_network_ids["vnet3"]
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
    "vnet3-vnet2" = {
      name                      = "${module.virtual_network.virtual_network_names["vnet3"]}-peer-to-${module.virtual_network.virtual_network_names["vnet2"]}"
      resource_group_name       = module.resource_group.resource_group_names["rg3"]
      virtual_network_name      = module.virtual_network.virtual_network_names["vnet3"]
      remote_virtual_network_id = module.virtual_network.virtual_network_ids["vnet2"]
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
    "vnet3-vnet1" = {
      name                      = "${module.virtual_network.virtual_network_names["vnet3"]}-peer-to-${module.virtual_network.virtual_network_names["vnet1"]}"
      resource_group_name       = module.resource_group.resource_group_names["rg3"]
      virtual_network_name      = module.virtual_network.virtual_network_names["vnet3"]
      remote_virtual_network_id = module.virtual_network.virtual_network_ids["vnet1"]
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
    "vnet1-vnet3" = {
      name                      = "${module.virtual_network.virtual_network_names["vnet1"]}-peer-to-${module.virtual_network.virtual_network_names["vnet3"]}"
      resource_group_name       = module.resource_group.resource_group_names["rg1"]
      virtual_network_name      = module.virtual_network.virtual_network_names["vnet1"]
      remote_virtual_network_id = module.virtual_network.virtual_network_ids["vnet3"]
      allow_virtual_network_access = true
      allow_forwarded_traffic      = true
      allow_gateway_transit        = false
      use_remote_gateways          = false
    }
  }
  default_tags = local.default_tags
}

module "subnet" {
  source = "../../../modules/subnet"

  subnets = {
    "snet1" = {
      name = "AzureFirewallSubnet"
      resource_group_name = module.resource_group.resource_group_names["rg1"]
      virtual_network_name = module.virtual_network.virtual_network_names["vnet1"]
      address_prefixes = var.subnets["snet1"].address_prefixes
    }
    "snet2" = {
      name = "snet-${local.client}${local.project}-${local.environment}-iapep01"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_name = module.virtual_network.virtual_network_names["vnet2"]
      address_prefixes = var.subnets["snet2"].address_prefixes
    }
    "snet3" = {
      name = "snet-${local.client}${local.project}-${local.environment}-iafunc01"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_name = module.virtual_network.virtual_network_names["vnet2"]
      address_prefixes = var.subnets["snet3"].address_prefixes
      delegation = {
          name = "function"
          service_delegation = {
            name = "Microsoft.Web/serverFarms"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/action" #,
              # "Microsoft.Network/virtualNetworks/subnets/join/action", 
              # "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
            ]            
          }
      }
    }      
    "snet4" = {
      name = "snet-${local.client}${local.project}-${local.environment}-iapbi01"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_name = module.virtual_network.virtual_network_names["vnet2"]
      address_prefixes = var.subnets["snet4"].address_prefixes
      delegation = {
          name = "powerbi"
          service_delegation = {
            name = "Microsoft.PowerPlatform/vnetaccesslinks"
            actions = [
              "Microsoft.Network/virtualNetworks/subnets/join/action" #, 
              # "Microsoft.Network/virtualNetworks/subnets/prepareNetworkPolicies/action"
            ]            
          }
      }
    }
    "snet5" = {
      name = "snet-${local.client}${local.project}-${local.environment}-mzmgmt01"
      resource_group_name = module.resource_group.resource_group_names["rg3"]
      virtual_network_name = module.virtual_network.virtual_network_names["vnet3"]
      address_prefixes = var.subnets["snet5"].address_prefixes
    }
    "snet6" = {
      name = "AzureBastionSubnet"
      resource_group_name = module.resource_group.resource_group_names["rg3"]
      virtual_network_name = module.virtual_network.virtual_network_names["vnet3"]
      address_prefixes = var.subnets["snet6"].address_prefixes
    }
    "snet7" = {
      name = "snet-${local.client}${local.project}-${local.environment}-mzpep01"
      resource_group_name = module.resource_group.resource_group_names["rg3"]
      virtual_network_name = module.virtual_network.virtual_network_names["vnet3"]
      address_prefixes = var.subnets["snet7"].address_prefixes
    }
  }
}

module "network_security_group" {
  source = "../../../modules/network-security-group"

  network_security_groups = {
    "nsg1" = {
      name = "nsg-${local.client}${local.project}-${local.environment}-iafunc01"
      location = local.region
      resource_group_name = module.resource_group.resource_group_names["rg2"]
    }
    "nsg2" = {
      name = "nsg-${local.client}${local.project}-${local.environment}-iapbi01"
      location = local.region
      resource_group_name = module.resource_group.resource_group_names["rg2"]
    }
    "nsg3" = {
      name = "nsg-${local.client}${local.project}-${local.environment}-mzmgmt01"
      location = local.region
      resource_group_name = module.resource_group.resource_group_names["rg3"]
    }
    "nsg4" = {
      name = "nsg-${local.client}${local.project}-${local.environment}-iapep01"
      location = local.region
      resource_group_name = module.resource_group.resource_group_names["rg2"]
    }
    "nsg5" = {
      name = "nsg-${local.client}${local.project}-${local.environment}-bastion01"
      location = local.region
      resource_group_name = module.resource_group.resource_group_names["rg3"]
    }
    "nsg6" = {
      name = "nsg-${local.client}${local.project}-${local.environment}-mzpep01"
      location = local.region
      resource_group_name = module.resource_group.resource_group_names["rg3"]
    }
  }
  security_rules = var.nsg_security_rules

  subnet_nsg_associations = {
    "snet3-nsg1" = {
      subnet_id = module.subnet.subnet_ids["snet3"]
      network_security_group_id = module.network_security_group.network_security_group_ids["nsg1"]
    }
    "snet4-nsg2" = {
      subnet_id = module.subnet.subnet_ids["snet4"]
      network_security_group_id = module.network_security_group.network_security_group_ids["nsg2"]
    }
    "snet5-nsg3" = {
      subnet_id = module.subnet.subnet_ids["snet5"]
      network_security_group_id = module.network_security_group.network_security_group_ids["nsg3"]
    }
    "snet2-nsg4" = {
      subnet_id = module.subnet.subnet_ids["snet2"]
      network_security_group_id = module.network_security_group.network_security_group_ids["nsg4"]
    }
    "snet6-nsg5" = {
      subnet_id = module.subnet.subnet_ids["snet6"]
      network_security_group_id = module.network_security_group.network_security_group_ids["nsg5"]
    }
    "snet7-nsg6" = {
      subnet_id = module.subnet.subnet_ids["snet7"]
      network_security_group_id = module.network_security_group.network_security_group_ids["nsg6"]
    }
  }
  default_tags = local.default_tags
}

module "private_dns_zone" {
  source = "../../../modules/private-dns-zone"

  private_dns_zones = {
    "dnspr1" = {
      name                = "privatelink.datafactory.azure.net"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
    }
    "dnspr2" = {
      name                = "privatelink.blob.core.windows.net"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
    }
    "dnspr3" = {
      name                = "privatelink.dfs.core.windows.net"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
    }
    "dnspr4" = {
      name                = "privatelink.azurewebsites.net"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
    }
    "dnspr5" = {
      name                = "privatelink.vaultcore.azure.net"
      resource_group_name = module.resource_group.resource_group_names["rg3"]
    }
    "dnspr6" = {
      name                = "privatelink.table.core.windows.net"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
    }
    "dnspr7" = {
      name                = "privatelink.queue.core.windows.net"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
    }
    "dnspr8" = {
      name                = "privatelink.file.core.windows.net"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
    }
  }

  vnet_links = {
    "dnspr1-vnet1" = {
      zone_key            = "dnspr1"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet1"]
    }
    "dnspr1-vnet2" = {
      zone_key            = "dnspr1"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet2"]
    }
    "dnspr1-vnet3" = {
      zone_key            = "dnspr1"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet3"]
    }
    dnspr2-vnet1 = {
      zone_key            = "dnspr2"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet1"]
    }
    "dnspr2-vnet2" = {
      zone_key            = "dnspr2"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet2"]
    }
    "dnspr2-vnet3" = {
      zone_key            = "dnspr2"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet3"]
    }
    dnspr3-vnet1 = {
      zone_key            = "dnspr3"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet1"]
    }
    "dnspr3-vnet2" = {
      zone_key            = "dnspr3"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet2"]
    }
    "dnspr3-vnet3" = {
      zone_key            = "dnspr3"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet3"]
    }
    dnspr4-vnet1 = {
      zone_key            = "dnspr4"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet1"]
    }
    "dnspr4-vnet2" = {
      zone_key            = "dnspr4"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet2"]
    }
    "dnspr4-vnet3" = {
      zone_key            = "dnspr4"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet3"]
    }
    dnspr5-vnet1 = {
      zone_key            = "dnspr5"
      resource_group_name = module.resource_group.resource_group_names["rg3"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet1"]
    }
    "dnspr5-vnet2" = {
      zone_key            = "dnspr5"
      resource_group_name = module.resource_group.resource_group_names["rg3"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet2"]
    }
    "dnspr5-vnet3" = {
      zone_key            = "dnspr5"
      resource_group_name = module.resource_group.resource_group_names["rg3"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet3"]
    }
    dnspr6-vnet1 = {
      zone_key            = "dnspr6"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet1"]
    }
    "dnspr6-vnet2" = {
      zone_key            = "dnspr6"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet2"]
    }
    "dnspr6-vnet3" = {
      zone_key            = "dnspr6"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet3"]
    }
    dnspr7-vnet1 = {
      zone_key            = "dnspr7"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet1"]
    }
    "dnspr7-vnet2" = {
      zone_key            = "dnspr7"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet2"]
    }
    "dnspr7-vnet3" = {
      zone_key            = "dnspr7"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet3"]
    }
    dnspr8-vnet1 = {
      zone_key            = "dnspr8"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet1"]
    }
    "dnspr8-vnet2" = {
      zone_key            = "dnspr8"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet2"]
    }
    "dnspr8-vnet3" = {
      zone_key            = "dnspr8"
      resource_group_name = module.resource_group.resource_group_names["rg2"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet3"]
    }
  }


  default_tags = local.default_tags
  
}

module "bastion" {
  source = "../../../modules/bastion"

  bastions = {
    "bastion1" = {
      name                = "bas-${local.client}${local.project}-${local.environment}-mgt"
      location            = local.region
      resource_group_name = module.resource_group.resource_group_names["rg3"]
      virtual_network_id  = module.virtual_network.virtual_network_ids["vnet3"]
      subnet_id           = module.subnet.subnet_ids["snet6"]
      sku                 = var.bastions["bastion1"].sku
      public_ip_key       = "pip-bas1"
    }
  }

  public_ips = {
    "pip-bas1" = {
      name                = "pip-bas-${local.client}${local.project}-${local.environment}-mgt"
      location            = local.region
      resource_group_name = module.resource_group.resource_group_names["rg3"]
      allocation_method   = var.public_ips["pip-bas1"].allocation_method
      sku                 = var.public_ips["pip-bas1"].sku
    }
  }

  default_tags = local.default_tags
  
}

module "key_vault" {
  source = "../../../modules/key-vault"


  key_vaults = {
    "kv1" = {
      key_vault_name                = "kv-${local.client}${local.project}-${local.environment}-mgt"
      location            = local.region
      resource_group_name = module.resource_group.resource_group_names["rg3"]
      soft_delete_retention_days = var.key_vaults["kv1"].soft_delete_retention_days
      purge_protection_enabled = var.key_vaults["kv1"].purge_protection_enabled
      public_network_access_enabled = var.key_vaults["kv1"].public_network_access_enabled
      pep_kv_name = "pep-kv-${local.client}${local.project}-${local.environment}-01"

    }
  }
      tenant_id = data.azurerm_client_config.current.tenant_id
      network_subnet_id = module.subnet.subnet_ids["snet7"]
      private_dns_zone_kv_id = module.private_dns_zone.private_dns_zone_ids["dnspr5"]
      default_tags = local.default_tags
}

module "route_table" {
  source = "../../../modules/route-table"

  route_tables = {
    "rt1" = {
      name                = "rt-${local.client}${local.project}-${local.environment}-afw"
      location            = local.region
      resource_group_name = module.resource_group.resource_group_names["rg1"]
      routes = var.route_tables["rt1"].routes
    }
    "rt2" = {
      name                = "rt-${local.client}${local.project}-${local.environment}-mzmgmt01"
      location            = local.region
      resource_group_name = module.resource_group.resource_group_names["rg3"]
      routes = var.route_tables["rt2"].routes
    }
  }

  subnet_route_table_associations = {
    "snet1-rt1" = {
      subnet_id      = module.subnet.subnet_ids["snet1"]
      route_table_id = module.route_table.route_table_ids["rt1"]
    }
    "snet2-rt2" = {
      subnet_id      = module.subnet.subnet_ids["snet5"]
      route_table_id = module.route_table.route_table_ids["rt2"]
    }
  }
  default_tags = local.default_tags
}