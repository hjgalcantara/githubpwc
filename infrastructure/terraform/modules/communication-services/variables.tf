variable "default_tags" {
  description = "Default tags to apply to all resources"
  type        = map(string)
  default     = {}
}

variable "communication_services" {
  description = "Map of communication services to create"
  type = map(object({
    communication_service_name = string
    resource_group_name        = string
    data_location              = string
  }))
  default = {}

}
