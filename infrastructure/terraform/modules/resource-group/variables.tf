variable "resource_groups" {
  description = "A map of resource groups to be created."
  type = map(object({
    name     = string
    location = string
  }))
}

variable "default_tags" {
  description = "Default tags to be applied to the resource."
  type = map(string)
}