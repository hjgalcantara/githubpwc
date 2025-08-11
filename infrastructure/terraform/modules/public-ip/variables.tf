variable "public_ips" {
  description = "Map of public IPs to create"
  type        = map(object({
    name                = string
    location            = string
    resource_group_name = string
    allocation_method   = string
    sku                 = string
  }))
  default     = {}
}

variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}