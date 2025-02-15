locals {
  resource_location = "North Europe"
  virtual_network ={
    name = "vent1"
    address_range = ["10.0.0.0/16"]
  }

  subnet = [
    {
      name = "websubnet"
      subnet_address_range = ["10.0.0.0/24"]
    },
    {
      name = "appsubnet"
      subnet_address_range = ["10.0.1.0/24"]
    }
  ]
}