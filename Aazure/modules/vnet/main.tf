resource "azurerm_virtual_network" "windows_virtual_network" {
   name = "windows_virtual_network"
   location = var.loaction_name
   resource_group_name = var.resource_group_name
   address_space = ["10.0.0.0/16"]
}

 resource "azurerm_subnet" "Einfo-subnet" {
    name = "Einfo-subnet"
    resource_group_name = var.resource_group_name
    virtual_network_name = azurerm_virtual_network.windows_virtual_network.name
    address_prefixes = ["10.0.0.0/24"]
 }

