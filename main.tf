resource "azurerm_resource_group" "my_resource_group" {
  name     = "terraform-rg"
  location = var.location
}
