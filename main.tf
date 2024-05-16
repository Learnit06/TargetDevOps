terraform {
  required_providers {
    azurerm = {
      source  = "hashicorp/azurerm"
      version = "=3.0.0"
    }
  }
}

# Configure the Microsoft Azure Provider
provider "azurerm" {
  features {}
}

resource "azurerm_resource_group" "Terraform1" {
  name     = "Terraform1-resources1"
  location = "EAST US"
}

resource "azurerm_virtual_network" "Terraform1" {
  name                = "Terraform1-network"
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.Terraform1.location
  resource_group_name = azurerm_resource_group.Terraform1.name
}

resource "azurerm_subnet" "Terraform1" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.Terraform1.name
  virtual_network_name = azurerm_virtual_network.Terraform1.name
  address_prefixes     = ["10.0.2.0/24"]
}

resource "azurerm_public_ip" "Terraform1" {
  name                     = "Terraform1_pip"
  resource_group_name = azurerm_resource_group.Terraform1.name
  location                 = azurerm_resource_group.Terraform1.location
  allocation_method        = "Dynamic"
}

resource "azurerm_network_interface" "Terraform1" {
  name                = "Terraform1-nic"
  location            = azurerm_resource_group.Terraform1.location
  resource_group_name = azurerm_resource_group.Terraform1.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.Terraform1.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.Terraform1.id
  }
}

resource "azurerm_linux_virtual_machine" "Terraform1" {
  name                = "Terraform1-machine"
  resource_group_name = azurerm_resource_group.Terraform1.name
  location            = azurerm_resource_group.Terraform1.location
  size                = "Standard_F2"
  admin_username      = "adminuser"
  network_interface_ids = [
    azurerm_network_interface.Terraform1.id,
  ]

  admin_ssh_key {
    username   = "adminuser"
    public_key = file("~/.ssh/id_rsa.pub")
  }

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = "Canonical"
    offer     = "0001-com-ubuntu-server-jammy"
    sku       = "22_04-lts"
    version   = "latest"
  }
}
