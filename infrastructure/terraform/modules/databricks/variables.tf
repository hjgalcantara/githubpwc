variable "databricks_workspaces" {
  description = "Map of Databricks workspaces with required settings."
  type = map(object({
    databricks_workspace_name                            = string
    databricks_access_connector_name                     = string
    resource_group_name                                  = string
    location                                             = string
    managed_resource_group_name                          = string
    public_network_access_enabled                        = bool
    network_security_group_rules_required                = string
    public_subnet_name                                   = string
    private_subnet_name                                  = string
    no_public_ip                                         = bool
    virtual_network_id                                   = string
    public_subnet_network_security_group_association_id  = string
    private_subnet_network_security_group_association_id = string
  }))
}

variable "default_tags" {
  description = "Default tags applied to all resources."
  type        = map(string)
  default     = {}
}
