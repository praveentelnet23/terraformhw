terraform {
  required_providers {
    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.83.0"
    }
  }
}

provider "azurerm" {
  subscription_id = "fdc1c342-95d4-499f-a68b-c7f8e86c4121"
  tenant_id = "3f77c0c0-62fe-4bff-9f58-3f8721b5f3ab"
  client_id = "6b0d0231-a7a9-452b-9cc3-5f56dd4e585d"
  client_secret = "S_~8Q~5qTDZRlDRsmU54O~UK0SCKEKWGG5JVmbH1"
  features {}
}

resource "azurerm_resource_group" "test-1" {
  name     = "test-2"
  location = "East US"
}

resource "azurerm_storage_account" "example" {
  name                     = "hw13storage"
  resource_group_name      = "test-2"
  location                 = "East US"
  account_tier             = "Standard"
  account_replication_type = "GRS"
}

# Create an App Service (web service)
resource "azurerm_app_service" "app_service" {
  name                = "myAppService"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  app_service_plan_id = azurerm_app_service_plan.app_service_plan.id
}

# Create an App Service Plan
resource "azurerm_app_service_plan" "app_service_plan" {
  name                = "myAppServicePlan"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  kind                = "Windows"
  reserved            = true

  sku {
    size = "F1"
    tier = "Free"
  }
}

# Create a Windows Virtual Machine
resource "azurerm_windows_virtual_machine" "example" {
  name                  = "myVM"
  resource_group_name   = azurerm_resource_group.rg.name
  location              = azurerm_resource_group.rg.location
  size                  = "Standard_DS1_v2"
  admin_username        = "adminuser"
  admin_password        = "Password1234!"
  network_interface_ids = [azurerm_network_interface.example.id]
  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }
  source_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"
    sku       = "2019-Datacenter"
    version   = "latest"
  }
}

# Create a network interface
resource "azurerm_network_interface" "example" {
  name                = "myVM-NIC"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.example.id
    private_ip_address_allocation = "Dynamic"
  }
}

# Create a virtual network
resource "azurerm_virtual_network" "example" {
  name                = "myVNET"
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  address_space       = ["10.0.0.0/16"]
}

# Create a subnet
resource "azurerm_subnet" "example" {
  name                 = "mySubnet"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.example.name
  address_prefixes     = ["10.0.1.0/24"]
}
