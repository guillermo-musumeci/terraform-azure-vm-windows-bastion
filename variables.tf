# ============================== #
# Declare variables and defaults #
# ============================== #

# Prefix used to name objects
variable "prefix" {
    description = "Prefix used to name objects"
    type        = "string"
    default     = "tf-poc"
}

# Environment
variable "environment" {
    description = "Name of environment to deploy"
    type        = "string"
    default     = "mgmt"
}

# Location Resource Group
variable "rg-location" {
    description = "Location of Resource Group"
    type        = "string"
    default     = "West Europe"
}

# Vnet CIDR
variable "vnet-cidr" {
    description = "Vnet CIDR"
    type        = "string"
    default     = "10.100.0.0/16"
}

# CIDR of Management Subnet
variable "mgmt-subnet-cidr" {
    description = "CIDR of Management Subnet"
    type        = "string"
    default     = "10.100.0.0/24"
}

# Windows Server SKU used to build VMs
variable "windows-sku" {
    description = "Windows Server SKU used to build VMs"
    type        = "string"
    default     = "2019-Datacenter"
}

# Windows Bastion VM Admin User
variable "tf-bastion-win-admin-user" {
    description = "Windows Bastion VM Admin User"
    type        = "string"
    default     = "tfadmin"
}

# Windows Bastion VM Admin Password
variable "tf-bastion-win-admin-password" {
    description = "Windows Bastion VM Admin Password"
    type        = "string"
    default     = "S3cr3t0s"
}

# Windows Bastion VM Name (limited to 15 characters long)
variable "tf-bastion-win-vm-name" {
    description = "Windows Bastion VM Name"
    type        = "string"
    default     = "tfbastionwin1"
}
