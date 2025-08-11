data "azurerm_client_config" "current" {}

data "terraform_remote_state" "network" {
  backend = "azurerm"
  config = {
    resource_group_name  = "rg-moeclas-d-ie"
    storage_account_name = "stmoeclasdtfstat"
    container_name       = "dev"
    key                  = "network.tfstate"
  }
}