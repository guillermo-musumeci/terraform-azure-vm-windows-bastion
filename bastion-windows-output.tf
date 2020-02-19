########################################
## Deploy Windows Bastion VM - Output ##
########################################

# Bastion Windows VM ID
output "bastion_windows_vm_id" {
  value = azurerm_virtual_machine.bastion-windows-vm.id
}

# Bastion Windows VM Username
output "bastion_windows_vm_username" {
  value = var.bastion-windows-admin-username
}

# Bastion Windows VM Password
output "bastion_windows_vm_password" {
  value = var.bastion-windows-admin-password
}

# Bastion Windows VM Public IP
output "bastion_windows_public_ip" {
  value = azurerm_public_ip.bastion-windows-ip.ip_address
}