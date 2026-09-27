terraform {
  required_version = ">= 1.12.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=5.0.0"
    }
  }
  # backend "azurerm" {
  #   resource_group_name  = "rg-terraform-ashu"
  #   storage_account_name = "stateashudev"
  #   container_name       = "tfstate"
  #   key                  = "dev.tfstate"
  # }
}

provider "azurerm" {
  features {}
}