
resource "azurerm_network_security_rule" "bastion-ssh" {
  name                        = "bastion-ssh"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "22"
  source_address_prefix       = "45.117.65.87/32"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.bastion.name
}

resource "azurerm_subnet_network_security_group_association" "bastion" {
  subnet_id                 = azurerm_subnet.bastion.id
  network_security_group_id = azurerm_network_security_group.bastion.id
  depends_on = [azurerm_linux_virtual_machine.bastion ]
}

resource "azurerm_network_security_group" "web" {
  name                = "mytf-web-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    environment = "Testing"
  }
}

resource "azurerm_network_security_rule" "web-http" {
  name                        = "web-http"
  priority                    = 100
  direction                   = "Inbound"
  access                      = "Allow"
  protocol                    = "Tcp"
  source_port_range           = "*"
  destination_port_range      = "80"
  source_address_prefix       = "*"
  destination_address_prefix  = "*"
  resource_group_name         = azurerm_resource_group.main.name
  network_security_group_name = azurerm_network_security_group.web.name
}

resource "azurerm_subnet_network_security_group_association" "web" {
  subnet_id                 = azurerm_subnet.web.id
  network_security_group_id = azurerm_network_security_group.web.id
  depends_on = [azurerm_linux_virtual_machine.bastion ]
} 


resource "azurerm_network_security_group" "app" {
    name                = "mytf-app-nsg"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
  
    tags = {
      environment = "Testing"
    }
  }
   
  resource "azurerm_subnet_network_security_group_association" "app" {
    subnet_id                 = azurerm_subnet.app.id
    network_security_group_id = azurerm_network_security_group.app.id
    depends_on = [azurerm_linux_virtual_machine.bastion ]
  } 


  resource "azurerm_network_security_group" "db" {
    name                = "mytf-db-nsg"
    location            = azurerm_resource_group.main.location
    resource_group_name = azurerm_resource_group.main.name
  
    tags = {
      environment = "Testing"
    }
  }
   
  resource "azurerm_subnet_network_security_group_association" "db" {
    subnet_id                 = azurerm_subnet.db.id
    network_security_group_id = azurerm_network_security_group.db.id
    depends_on = [azurerm_linux_virtual_machine.bastion ]
  } 


resource "azurerm_network_security_group" "bastion" {
  name                = "mytf-bastion-nsg"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  tags = {
    environment = "Testing"
  }
}

