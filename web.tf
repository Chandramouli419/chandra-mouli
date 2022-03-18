resource "azurerm_public_ip" "webip" {
  count = var.webvmcount
  name                = "${var.prefix}-${var.env}-web-pip-${count.index+1}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  allocation_method   = "Static"

  tags = {
    environment = "Testing"
  }
}


resource "azurerm_network_interface" "web" {
  count = var.webvmcount
  name                = "${var.prefix}-${var.env}-web-nic-${count.index+1}"
  location            = azurerm_resource_group.main.location
  resource_group_name = azurerm_resource_group.main.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.web.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id = element(azurerm_public_ip.webip.*.id, count.index)
  }
}

resource "azurerm_linux_virtual_machine" "web" {
  count = var.webvmcount
  name                = "${var.prefix}-${var.env}-web-vm-${count.index+1}"
  resource_group_name = azurerm_resource_group.main.name
  location            = azurerm_resource_group.main.location
  size                = var.webVmSize
  admin_username      = var.username
  network_interface_ids = [element(azurerm_network_interface.web.*.id, count.index)]

  admin_ssh_key {
    username   = var.username
    public_key = file(var.pubKeyPath)
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "UbuntuServer"
    sku       = "18.04-LTS"
    version   = "latest"
  }
}



output "web_PIP" {
  value = [azurerm_public_ip.webip.*.ip_address]
}