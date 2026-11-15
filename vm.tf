# creating public ip for vm

resource "azurerm_public_ip" "my_public_ip" {
  name                = "terraform-vm-public-ip"
  location            = var.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  allocation_method   = "Static"
  sku                 = "Standard"
}

# creating nic for vm

resource "azurerm_network_interface" "my_nic" {
  name                = "terraform-vm-nic"
  location            = var.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
  ip_configuration {
    name                          = "Internal"
    subnet_id                     = azurerm_subnet.my_subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_public_ip.id
  }
}

# azure vm configuration 


resource "azurerm_linux_virtual_machine" "my_vm" {
  name                = "terraform-ubuntu-vm"
  resource_group_name = azurerm_resource_group.my_resource_group.name
  location            = var.location
  size                = "Standard_F1als_v7"

  admin_username = "azureuser"

  network_interface_ids = [
    azurerm_network_interface.my_nic.id
  ]

  admin_ssh_key {
    username   = "azureuser"
    public_key = file(pathexpand("~/.ssh/id_ed25519.pub"))
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "ubuntu-24_04-lts"
    sku       = "server"
    version   = "latest"
  }
}
