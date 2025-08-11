project = "clas"
client = "moe"
environment = "dev"
region = "southeastasia"
owner = "hill.joseph.a.alcantara@pwccom"
approver = "richard.sm.chong@pwc.com"

virtual_networks = {
    vnet1 = {
        address_space = ["192.168.0.0/24"]
    }
    vnet2 = {
        address_space = ["192.168.1.0/24"]
    }
    vnet3 = {
        address_space = ["192.168.2.0/24"]
    }
}

subnets = {
    snet1 = {
        address_prefixes = ["192.168.0.0/26"]
    }
    snet2 = {
        address_prefixes = ["192.168.1.0/28"]
    }
    snet3 = {
        address_prefixes = ["192.168.1.16/28"]
    }
    snet4 = {
        address_prefixes = ["192.168.1.32/28"]
    }
    snet5 = {
        address_prefixes = ["192.168.2.0/28"]
    }
    snet6 = {
        address_prefixes = ["192.168.2.64/26"]
    }
    snet7 = {
        address_prefixes = ["192.168.2.192/28"]
    }
}

nsg_security_rules = {
  "nsg5" = [
    {
      name = "AllowHttpsInbound"
      priority = 120
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "443"
      source_address_prefix = "*"
      destination_address_prefix = "*"
    },
    {
      name = "AllowGatewayManagerInbound"
      priority = 130
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "443"
      source_address_prefix = "GatewayManager"
      destination_address_prefix = "*"
    },
    {
      name = "AllowALBInbound"
      priority = 140
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "443"
      source_address_prefix = "AzureLoadBalancer"
      destination_address_prefix = "*"
    },
    {
      name = "AllowBastionHostInbound"
      priority = 150
      direction = "Inbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_ranges = ["8080", "5701"]
      source_address_prefix = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name = "AllowSshRdpOutbound"
      priority = 100
      direction = "Outbound"
      access = "Allow"
      protocol = "*"
      source_port_range = "*"
      destination_port_ranges = ["3389", "22"]
      source_address_prefix = "*"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name = "AllowAzureCloudOutbound"
      priority = 110
      direction = "Outbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_range = "443"
      source_address_prefix = "*"
      destination_address_prefix = "AzureCloud"
    },
    {
      name = "AllowBastionHostOutbound"
      priority = 120
      direction = "Outbound"
      access = "Allow"
      protocol = "Tcp"
      source_port_range = "*"
      destination_port_ranges = ["8080", "5701"]
      source_address_prefix = "VirtualNetwork"
      destination_address_prefix = "VirtualNetwork"
    },
    {
      name = "AllowHttpOutbound"
      priority = 130
      direction = "Outbound"
      access = "Allow"
      protocol = "*"
      source_port_range = "*"
      destination_port_range = "80"
      source_address_prefix = "*"
      destination_address_prefix = "Internet"
    }
  ]
}

public_ips = {
  "pip-bas1" = {
    allocation_method   = "Static"
    sku                 = "Standard"
  }
}

bastions = {
  "bastion1" = {
    sku = "Basic"
  }
}

key_vaults = {
  "kv1" = {
    soft_delete_retention_days = 7
    purge_protection_enabled    = false
    public_network_access_enabled = false
  }
}

route_tables = {
  rt1 = {
    routes = [
      {
        name           = "default"
        address_prefix = "0.0.0.0/0"
        next_hop_type  = "Internet"
      }
    ]
  }
  rt2 = {
    routes = [
      {
        name                   = "route-to-internet"
        address_prefix         = "0.0.0.0/0"
        next_hop_type          = "VirtualAppliance"
        next_hop_in_ip_address = "192.168.0.4"
      }
    ]
  }
}