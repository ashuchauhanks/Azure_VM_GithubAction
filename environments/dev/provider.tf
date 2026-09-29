terraform {
  required_version = ">= 1.12.2"
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = ">=5.0.0"
    }
  }
  backend "azurerm" {
    resource_group_name  = "rg-statebk"
    storage_account_name = "ashustgstatebk"
    container_name       = "tfstate"
    key                  = "azvmagent.tfstate"
  }
}

provider "azurerm" {
  features {}
}