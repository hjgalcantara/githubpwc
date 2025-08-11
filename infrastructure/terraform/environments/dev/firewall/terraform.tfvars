project = "clas"
client = "moe"
environment = "dev"
region = "southeastasia"
owner = "hill.joseph.a.alcantara@pwccom"
approver = "richard.sm.chong@pwc.com"

firewall = {
  "afw1" = {
    sku_name            = "AZFW_VNet"
    sku_tier            = "Standard"
    policy_key          = "afwp1"
  }
}

firewall_policy = {
  "afwp1" = {
    sku = "Standard"
    threat_intelligence_mode = "Alert"
  }
}

public_ip = {
  "pip-afw1" = {
    allocation_method = "Static"
    sku               = "Standard"
  }
}