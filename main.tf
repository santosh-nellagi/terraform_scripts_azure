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

resource "azurerm_storage_account" "santoshstg1" {
  name                     = "santoshstg1"
  resource_group_name      = azurerm_resource_group.santoshrg.name
  location                 = azurerm_resource_group.santoshrg.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}
resource "azurerm_storage_container" "sancont" {
  name = "sancont"
  storage_account_name = azurerm_storage_account.santoshstg1.name
  container_access_type = "private"
  
  
}

resource "azurerm_storage_blob" "sabblob" {
  name = "sanblob"
  storage_account_name = azurerm_storage_account.santoshstg1.name
  storage_container_name = azurerm_storage_container.sancont.name
  type = "Block"
  source = "portfolio-01.jpg"
  
}
