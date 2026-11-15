# Azure vnet

resource "azurerm_virtual_network" "my_vnet" {
  name                = "terraform-vnet"
  location            = var.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  address_space       = ["10.0.0.0/16"]
}

# subnet inside the vnet

resource "azurerm_subnet" "my_subnet" {
  name                 = "terraform-subnet"
  resource_group_name  = azurerm_resource_group.my_resource_group.name
  virtual_network_name = azurerm_virtual_network.my_vnet.name
  address_prefixes     = ["10.0.1.0/24"]

}