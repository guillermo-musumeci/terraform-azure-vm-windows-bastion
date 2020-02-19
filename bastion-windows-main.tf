######################################
## Deploy Windows Bastion VM - Main ##
######################################

# Create Network Security Group to Access Bastion VM from Internet
resource "azurerm_network_security_group" "bastion-windows-nsg" {
  name                = "${var.company}-${var.environment}-bastion-windows-nsg"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name

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
    application = var.app_name
    environment = var.environment 
  }
}

# Associate the Bastion NSG with the Subnet
resource "azurerm_subnet_network_security_group_association" "bastion-windows-nsg-association" {
  subnet_id                 = azurerm_subnet.network-subnet.id
  network_security_group_id = azurerm_network_security_group.bastion-windows-nsg.id
}

# Get a Static Public IP for Bastion
resource "azurerm_public_ip" "bastion-windows-ip" {
  name                = "${var.company}-${var.environment}-bastion-windows-ip"
  location            = azurerm_resource_group.network-rg.location
  resource_group_name = azurerm_resource_group.network-rg.name
  allocation_method   = "Static"
  
  tags = { 
    application = var.app_name
    environment = var.environment 
  }
}

# Create Network Card for Bastion VM
resource "azurerm_network_interface" "bastion-windows-nic" {
  name                      = "${var.company}-${var.environment}-bastion-windows-nic"
  location                  = azurerm_resource_group.network-rg.location
  resource_group_name       = azurerm_resource_group.network-rg.name
  network_security_group_id = azurerm_network_security_group.bastion-windows-nsg.id

  ip_configuration {
    name                          = "internal"
    subnet_id                     = azurerm_subnet.network-subnet.id
    private_ip_address_allocation = "Dynamic"
    public_ip_address_id          = azurerm_public_ip.bastion-windows-ip.id
  }

  tags = { 
    application = var.app_name
    environment = var.environment 
  }
}

# Create Windows Bastion Server
resource "azurerm_virtual_machine" "bastion-windows-vm" {
  name                  = "${var.company}-${var.environment}-bastion-windows-vm"
  location              = azurerm_resource_group.network-rg.location
  resource_group_name   = azurerm_resource_group.network-rg.name
  network_interface_ids = [azurerm_network_interface.bastion-windows-nic.id]
  vm_size               = var.bastion-windows-vm-size

  # Comment this line to keep the OS disk when deleting the VM
  delete_os_disk_on_termination = true
  # Comment this line to keep the data disks when deleting the VM
  delete_data_disks_on_termination = true

  storage_image_reference {
    publisher = "MicrosoftWindowsServer"
    offer     = "WindowsServer"    
    sku       = var.windows-2019-sku
    version   = "latest"
  }
  
  storage_os_disk {
    name              = "${var.company}-${var.environment}-bastion-windows-os-disk"
    caching           = "ReadWrite"
    create_option     = "FromImage"
    managed_disk_type = "Standard_LRS"
  }

  os_profile {
    computer_name  = var.bastion-windows-vm-hostname
    admin_username = var.bastion-windows-admin-username
    admin_password = var.bastion-windows-admin-password
  }

  os_profile_windows_config {
    provision_vm_agent        = true
    enable_automatic_upgrades = true
  }

  tags = {
    application = var.app_name
    environment = var.environment 
  }
}
