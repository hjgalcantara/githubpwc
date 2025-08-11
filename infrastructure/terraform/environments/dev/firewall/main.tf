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

module "firewall" {
  source = "../../../modules/firewall"

  public_ips = {
    pip-afw1 = {
      name                = "pip-${local.client}${local.project}-${local.environment}-afw01"
      location            = local.region
      resource_group_name = data.terraform_remote_state.network.outputs.resource_group_names["rg1"]
      allocation_method   = var.public_ip["pip-afw1"].allocation_method
      sku                 = var.public_ip["pip-afw1"].sku
    }
  }
  
  firewalls = {
    fw1 = {
      name                = "afw-${local.client}${local.project}-${local.environment}"
      location            = local.region
      resource_group_name = data.terraform_remote_state.network.outputs.resource_group_names["rg1"]
      subnet_id           = data.terraform_remote_state.network.outputs.subnet_ids["snet1"]
      sku_name            = var.firewall["afw1"].sku_name
      sku_tier            = var.firewall["afw1"].sku_tier
      policy_key          = var.firewall["afw1"].policy_key

      public_ip_keys = {
        "0" = "pip-afw1"
      }
    }
  }

  firewall_policies = {
    "afwp1" = {
      name                   = "afwp-${local.client}${local.project}-${local.environment}-01"
      location               = local.region
      resource_group_name    = data.terraform_remote_state.network.outputs.resource_group_names["rg1"]
      sku                    = var.firewall_policy["afwp1"].sku
      threat_intelligence_mode = var.firewall_policy["afwp1"].threat_intelligence_mode
    }
  }

  rule_collection_groups = {
    "afwp-rcg1" = {
      name               = "afwp-rcg-${local.client}${local.project}-${local.environment}-01"
      policy_key         = "afwp1"
      priority           = 100

      application_rule_collections = [
        {
          name     = "app-rule-collection-01"
          priority = 200
          action   = "Allow"
          rules    = [
            {
              name             = "app-rule-01" #temporary rule for tools
              protocol_type    = "Https"
              protocol_port    = 443
              source_addresses = data.terraform_remote_state.network.outputs.subnet_addresses["snet5"]
              destination_fqdns = [
                "winscp.net", #WinSCP
                "cdn.winscp.net", #WinSCP
                "putty.org", #Putty
                "www.chiark.greenend.org.uk", #Putty
                "the.earth.li", #Putty
              ]
            }
          ]
        }
      ]

      network_rule_collections = [
        {
          name     = "network-rule-collection-01"
          priority = 100
          action   = "Allow"
          rules    = [
            {
              
              name             = "network-rule-01"
              protocols    = ["TCP"]
              destination_ports = [22]
              source_addresses = data.terraform_remote_state.network.outputs.subnet_addresses["snet5"]
              destination_addresses = [
                "52.77.46.4"
              ]
            }
          ]
        }
      ]
    }
  }

  default_tags = local.default_tags
}