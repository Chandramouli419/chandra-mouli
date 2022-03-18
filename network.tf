resource "azurerm_virtual_network" "mainvnet" {
  name                = "${var.prefix}-${var.env}-vnet"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name
  address_space       = var.vnetCIDR
  dns_servers         = var.dnsServers

  tags = {
      Environment = var.env
      CostCenter = "IT"
  }
}

resource "azurerm_subnet" "bastion" {
  name                 = "${var.prefix}-${var.env}-bastion-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.mainvnet.name
  address_prefixes     = var.bastionCIDR

  
}

resource "azurerm_subnet" "web" {
  name                 = "${var.prefix}-${var.env}-web-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.mainvnet.name
  address_prefixes     = var.webCIDR

 
}

resource "azurerm_subnet" "app" {
  name                 = "${var.prefix}-${var.env}-app-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.mainvnet.name
  address_prefixes     = var.appCIDR

}

resource "azurerm_subnet" "db" {
  name                 = "${var.prefix}-${var.env}-db-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.mainvnet.name
  address_prefixes     = var.dbCIDR

}


resource "azurerm_subnet" "api" {
  name                 = "${var.prefix}-${var.env}-api-subnet"
  resource_group_name  = azurerm_resource_group.main.name
  virtual_network_name = azurerm_virtual_network.mainvnet.name
  address_prefixes     = var.apiCIDR

  
}