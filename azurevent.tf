terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=4.4.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
 # This is only required when the User, Service Principal, or Identity running Terraform lacks the permissions to register Azure Resource Providers.
  features {}
  subscription_id = "220fb593-4f80-4800-9b85-5690834daaa2"
}

# Create a resource group
resource "azurerm_resource_group" "santoshrg" {
  name     = "santoshrg"
  location = "West Europe"
}
resource "azurerm_virtual_network" "ventapp" {
  name = "ventapp"
  resource_group_name = azurerm_resource_group.santoshrg.name
  location = azurerm_resource_group.santoshrg.location
  address_space = ["10.0.0.0/16"]

  subnet {
    name = "websubnet"
    address_prefixes = ["10.0.0.0/24"]

  }
  subnet {
    name = "appsubent"
    address_prefixes = ["10.0.1.0/24"]
  }
}
