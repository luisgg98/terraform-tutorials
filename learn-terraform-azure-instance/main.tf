# Run correctly AZURE COMMANDS CLI
# https://discuss.hashicorp.com/t/values-of-identifieruris-property-must-use-a-verified-domain-documentation-needs-an-update/37828

## <https://www.terraform.io/docs/providers/azurerm/r/resource_group.html>
resource "azurerm_resource_group" "rg" {
  name     = "azure_dkv_test_terraform"
  location = "West Europe"
}

## <https://www.terraform.io/docs/providers/azurerm/r/availability_set.html>
resource "azurerm_availability_set" "az_av_set" {
  name                = var.vm_az_av_set
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

## <https://www.terraform.io/docs/providers/azurerm/r/virtual_network.html>
resource "azurerm_virtual_network" "vnet" {
  name                = var.vm_vnet
  address_space       = ["10.0.0.0/16"]
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
}

## <https://www.terraform.io/docs/providers/azurerm/r/subnet.html> 
resource "azurerm_subnet" "subnet" {
  name                 = "internal"
  resource_group_name  = azurerm_resource_group.rg.name
  virtual_network_name = azurerm_virtual_network.vnet.name
  address_prefixes       = ["10.0.2.0/24"]
}

# Create public IPs
resource "azurerm_public_ip" "my_terraform_public_ip" {
  name                = "myPublicIP"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name
  allocation_method   = "Dynamic"
}

# Create Network Security Group and rule
resource "azurerm_network_security_group" "my_terraform_nsg" {
  name                = "myNetworkSecurityGroup"
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  security_rule {
    name                       = "SSH"
    priority                   = 1001
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "22"
    source_address_prefix      = "*"
    destination_address_prefix = "*"
  }
}



## <https://www.terraform.io/docs/providers/azurerm/r/network_interface.html>
resource "azurerm_network_interface" "az-network-interface" {
  name                = var.vm_nic_name
  location            = azurerm_resource_group.rg.location
  resource_group_name = azurerm_resource_group.rg.name

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.my_terraform_public_ip.id
  }
}

# Connect the security group to the network interface
resource "azurerm_network_interface_security_group_association" "example" {
  network_interface_id      = azurerm_network_interface.az-network-interface.id
  network_security_group_id = azurerm_network_security_group.my_terraform_nsg.id
}

# Create (and display) an SSH key
resource "tls_private_key" "example_ssh" {
  algorithm = "RSA"
  rsa_bits  = 4096
}


## <https://www.terraform.io/docs/providers/azurerm/r/windows_virtual_machine.html>
resource "azurerm_linux_virtual_machine" "az_virtual_machine" {
  name                = var.virtual_machine_name
  resource_group_name = azurerm_resource_group.rg.name
  location            = azurerm_resource_group.rg.location
  size                = "Standard_F2"
  admin_username      = var.vm_admin_user
  admin_password      = var.vm_admin_pass
  availability_set_id = azurerm_availability_set.az_av_set.id
  disable_password_authentication= false
  network_interface_ids = [
    azurerm_network_interface.az-network-interface.id,
  ]

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

admin_ssh_key {
    username   = var.vm_admin_user
    public_key = tls_private_key.example_ssh.public_key_openssh
  }

}

#az ad sp create-for-rbac -n "api://azure_test" --role="Contributor" --scopes="/subscriptions/4f1dae9f-889b-499d-b400-35b9a74d7d43"
