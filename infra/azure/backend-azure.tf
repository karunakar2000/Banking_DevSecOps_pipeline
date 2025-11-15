# infra/azure/backend-azure.tf
// Remote backend for DTB-Azure infrastructure (AKS, network, etc.)

terraform {
  backend "azurerm" {
    resource_group_name  = "dtb-tfstate-rg"        
    storage_account_name = "dtbtfstateaccount"     # TODO: change to your Storage Account
    container_name       = "terraform-state"       # TODO: ensure container exists
    key                  = "azure/infra/terraform.tfstate"
  }
}
