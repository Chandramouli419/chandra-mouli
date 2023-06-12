provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "example" {
  name     = "example-resource-group"
  location = "eastus"
}

resource "azurerm_storage_account" "example" {
  name                     = "examplestorageaccount"
  resource_group_name      = azurerm_resource_group.example.name
  location                 = azurerm_resource_group.example.location
  account_tier             = "Standard"
  account_replication_type = "LRS"
}

variable "container_names" {
  type    = list(string)
  default = ["container1", "container2", "container3"]
}

resource "azurerm_storage_container" "example" {
  count                = length(var.container_names)
  name                 = var.container_names[count.index]
  storage_account_name = azurerm_storage_account.example.name
  container_access_type = "private"
}
