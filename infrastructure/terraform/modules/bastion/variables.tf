variable "public_ips" {
  description = "Map of public IP configurations"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    allocation_method   = string
    sku                 = string
  }))
  default = {}
}

variable "bastions" {
  description = "Map of Azure Bastion configurations"
  type = map(object({
    name                = string
    location            = string
    resource_group_name = string
    sku                 = string
    subnet_id           = string
    public_ip_key       = string
  }))
  default = {}
}

variable "default_tags" {
  
}