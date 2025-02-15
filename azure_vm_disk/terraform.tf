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
