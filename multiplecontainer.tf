resource "azurerm_resource_group" "santosh123" {
    name = "santosh123"
    location = "North Europe"
  
}
resource "azurerm_storage_account" "sanstorage345" {
  name = "sanstorage345"
  resource_group_name = azurerm_resource_group.santosh123.name
  location = azurerm_resource_group.santosh123.location
  account_tier = "Standard"
  account_replication_type = "LRS"
  
}
resource "azurerm_storage_container" "scripts" {
    count = 3
    name = "scripts-${count.index}"
    storage_account_name    = azurerm_storage_account.sanstorage345.name
 container_access_type = "private"

}