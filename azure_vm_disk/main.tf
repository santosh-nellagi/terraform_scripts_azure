
resource "azurerm_resource_group" "santoshrg" {
  name     = "santoshrg"
  location = local.resource_location
}
resource "azurerm_virtual_network" "ventapp" {
  name = local.virtual_network.name
  resource_group_name = azurerm_resource_group.santoshrg.name
  location = local.resource_location
  address_space = local.virtual_network.address_range
}

resource "azurerm_subnet" "websubnet" {
  name                 = local.subnet[0].name
  resource_group_name  = azurerm_resource_group.santoshrg.name
  virtual_network_name = azurerm_virtual_network.ventapp.name
  address_prefixes     = local.subnet[0].subnet_address_range
}
resource "azurerm_subnet" "appsubnet" {
  name                 = local.subnet[1].name
  resource_group_name  = azurerm_resource_group.santoshrg.name
  virtual_network_name = azurerm_virtual_network.ventapp.name
  address_prefixes     = local.subnet[1].subnet_address_range
}

resource "azurerm_public_ip" "webip" {
  name                = "webip"
  resource_group_name = azurerm_resource_group.santoshrg.name
  location            = local.resource_location
  allocation_method   = "Static"
}


resource "azurerm_network_interface" "nic" {
  name                = "nic"
  location            = local.resource_location
  resource_group_name = azurerm_resource_group.santoshrg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.websubnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.webip.id
  }
}


resource "azurerm_network_security_group" "webnsg" {
  name = "webnsg"
  location = local.resource_location
  resource_group_name = azurerm_resource_group.santoshrg.name
  security_rule {
    name                       = "rdp"
    priority                   = 200
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "*"
    destination_address_prefix = "*"

  }
  
}

resource "azurerm_subnet_network_security_group_association" "nsgsub" {
  subnet_id = azurerm_subnet.websubnet.id
  network_security_group_id = azurerm_network_security_group.webnsg.id
}


resource "azurerm_windows_virtual_machine" "webvm" {
  name                = var.vm_name
  resource_group_name = azurerm_resource_group.santoshrg.name
  location            = local.resource_location
  size                = var.vm_size
  admin_username      = "webuser"
  admin_password      = var.vm_password
  network_interface_ids = [
    azurerm_network_interface.nic.id,
  ]
  vm_agent_platform_updates_enabled = true

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2022-Datacenter"
    version   = "latest"
  }
}

resource "azurerm_managed_disk" "datadisk" {
  name                 = "datadisk"
  location             = local.resource_location
  resource_group_name  = azurerm_resource_group.santoshrg.name
  storage_account_type = "Standard_LRS"
  create_option        = "Empty"
  disk_size_gb         = "1"
}

resource "azurerm_virtual_machine_data_disk_attachment" "dattcah" {
  managed_disk_id    = azurerm_managed_disk.datadisk.id
  virtual_machine_id = azurerm_windows_virtual_machine.webvm.id
  lun                = "0"
  caching            = "ReadWrite"
}

output "publicip" {
  value = azurerm_public_ip.webip.ip_address
  
}