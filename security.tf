# creating nsg 

resource "azurerm_network_security_group" "my_nsg" {
  name                = "terraform-nsg"
  location            = var.location
  resource_group_name = azurerm_resource_group.my_resource_group.name
}

# creating inbound security rule in the nsg for allowing http

resource "azurerm_network_security_rule" "my_nsg_rule" {
  name                        = "allow-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 80
  source_address_prefix       = "Internet"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.my_resource_group.name
  network_security_group_name = azurerm_network_security_group.my_nsg.name
}

# creating inbound security rule in the nsg for allowing ssh

resource "azurerm_network_security_rule" "ssh_rule" {
  name                        = "allow-ssh"
  priority                    = 200
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = 22
  source_address_prefix       = "157.49.42.44/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.my_resource_group.name
  network_security_group_name = azurerm_network_security_group.my_nsg.name
}

# Associating NSG with subnet

resource "azurerm_subnet_network_security_group_association" "my_subnet_nsg" {
  subnet_id                 = azurerm_subnet.my_subnet.id
  network_security_group_id = azurerm_network_security_group.my_nsg.id
}