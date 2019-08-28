# ========================= #
# Deploy Windows Bastion VM #
# ========================= #

# Configure the Azure Provider
provider "azurerm" { }

# Create Resource Group
resource "azurerm_resource_group" "tf-rg" {
  name = "${var.prefix}-rg-${var.environment}"
  location = "${var.rg-location}"
}

# Create a virtual network
resource "azurerm_virtual_network" "tf-vnet" {
  name                = "${var.prefix}-vnet-${var.environment}"
  resource_group_name = "${azurerm_resource_group.tf-rg.name}"
  location            = "${var.rg-location}"
  address_space       = ["${var.vnet-cidr}"]
  
  tags = { 
    environment = "${var.environment}" 
  }
}

# Create Security Group to Access Bastion VM from Internet
resource "azurerm_network_security_group" "tf-bastion-nsg" {
  name                = "${var.prefix}-bastion-nsg-${var.environment}"
  location            = "${azurerm_resource_group.tf-rg.location}"
  resource_group_name = "${azurerm_resource_group.tf-rg.name}"

  security_rule {
    name                       = "AllowRDP"
    description                = "Allow RDP"
    priority                   = 100
    direction                  = "Inbound"
    access                     = "Allow"
    protocol                   = "Tcp"
    source_port_range          = "*"
    destination_port_range     = "3389"
    source_address_prefix      = "Internet"
    destination_address_prefix = "*"
  }

  tags = {
    environment = "${var.environment}" 
  }
}

# Create a subnet for managmenent VMs
resource "azurerm_subnet" "tf-subnet-mgmt" {
  name                 = "${var.prefix}-subnet-mgmt-${var.environment}"
  resource_group_name  = "${azurerm_resource_group.tf-rg.name}"
  virtual_network_name = "${azurerm_virtual_network.tf-vnet.name}"
  address_prefix       = "${var.mgmt-subnet-cidr}"
}

# Associate the Bastion NSG with the Management Subnet
resource "azurerm_subnet_network_security_group_association" "tf-bastion-nsg-association" {
  subnet_id                 = "${azurerm_subnet.tf-subnet-mgmt.id}"
  network_security_group_id = "${azurerm_network_security_group.tf-bastion-nsg.id}"
}

# Get a Static Public IP for Bastion
resource "azurerm_public_ip" "tf-bastion-win-ip" {
  name                = "${var.prefix}-bastion-win-ip-${var.environment}"
  location            = "${azurerm_resource_group.tf-rg.location}"
  resource_group_name = "${azurerm_resource_group.tf-rg.name}"
  allocation_method   = "Static"
  
  tags = { 
    environment = "${var.environment}" 
  }
}

# Create Network Card for Bastion VM
resource "azurerm_network_interface" "tf-bastion-win-nic" {
  name                      = "${var.prefix}-bastion-win-nic-${var.environment}"
  location                  = "${azurerm_resource_group.tf-rg.location}"
  resource_group_name       = "${azurerm_resource_group.tf-rg.name}"
  network_security_group_id = "${azurerm_network_security_group.tf-bastion-nsg.id}"

  ip_configuration {
    name                          = "internal"
    subnet_id                     = "${azurerm_subnet.tf-subnet-mgmt.id}"
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = "${azurerm_public_ip.tf-bastion-win-ip.id}"
  }

  tags = { 
    environment = "${var.environment}" 
  }
}

# Create Windows Bastion Server
resource "azurerm_virtual_machine" "tf-bastion-win-vm" {
  name                  = "${var.prefix}-bastion-win-vm-${var.environment}"
  location              = "${azurerm_resource_group.tf-rg.location}"
  resource_group_name   = "${azurerm_resource_group.tf-rg.name}"
  network_interface_ids = ["${azurerm_network_interface.tf-bastion-win-nic.id}"]
  vm_size               = "Standard_B1s"

  # Comment this line to keep the OS disk when deleting the VM
  delete_os_disk_on_termination = true
  # Comment this line to keep the data disks when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"    
    sku       = "${var.windows-sku}"
    version   = "latest"
  }
  storage_os_disk {
    name              = "${var.tf-bastion-win-vm-name}-os-disk-${var.environment}"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }
  os_profile {
    computer_name  = "${var.tf-bastion-win-vm-name}"
    admin_username = "${var.tf-bastion-win-admin-user}"
    admin_password = "${var.tf-bastion-win-admin-password}"
  }
 os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }
  tags = {
    environment = "${var.environment}"
  }
}
