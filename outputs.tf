# Public IP of Bastion-win VM
output "bastion-win-public-ip" {
    value = "${azurerm_public_ip.tf-bastion-win-ip.ip_address}"
}
