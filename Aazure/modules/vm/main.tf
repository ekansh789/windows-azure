
variable "subnet_id" {}
variable "nsg_id" {}

resource "azurerm_public_ip" "WorkPublicIp" {
  allocation_method   = "Dynamic"
  location            = var.location_name
  name                = "WorkPublicIp"
  resource_group_name = var.resource_group_name
}

resource "azurerm_network_interface" "myAZ-NIC" {
  location            = var.location_name
  name                = "myAZ-NIC"
  resource_group_name = var.resource_group_name

  ip_configuration {
    name                          = "myAZ-NIC_config"
    subnet_id                     = var.subnet_id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.WorkPublicIp.id

  }
}

resource "azurerm_network_interface_security_group_association" "nsg_assoc" {
  network_interface_id      = azurerm_network_interface.myAZ-NIC.id
  network_security_group_id = var.nsg_id
}

resource "azurerm_windows_virtual_machine" "WindowsMachine" {
  name                = "WindowsMachine"
  resource_group_name = var.resource_group_name
  location            = var.location_name
  size                = "Standard_DS1_V2"
  admin_username      = "adminWindows"
  admin_password      = "Ekansh@123"

  os_disk {
    caching           = "ReadWrite"
    storage_account_type = "Standard_LRS"

  }



  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
  network_interface_ids = [azurerm_network_interface.myAZ-NIC.id]


}




#Install IIS web server to the virtual machine using azurerm_virtual_machine_extension

resource "azurerm_virtual_machine_extension" "iis" {
  name                       = "iis"
  virtual_machine_id         = azurerm_windows_virtual_machine.WindowsMachine.id
  publisher                  = "Microsoft.Compute"
  type                       = "CustomScriptExtension"
  type_handler_version       = "1.8"
  auto_upgrade_minor_version = true
  settings                   = <<SETTINGS
 {
   "commandToExecute": "powershell -ExecutionPolicy Unrestricted Install-WindowsFeature -Name Web-Server -IncludeAllSubFeature -IncludeManagementTools"
 }
 SETTINGS
}