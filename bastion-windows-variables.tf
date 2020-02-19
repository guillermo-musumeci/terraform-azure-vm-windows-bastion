###########################################
## Deploy Windows Bastion VM - Variables ##
###########################################

# Windows Bastion VM Admin User
variable "bastion-windows-admin-username" {
  type        = string
  description = "Windows Bastion VM Admin User"
  default     = "tfadmin"
}

# Windows Bastion VM Admin Password
variable "bastion-windows-admin-password" {
  type        = string
  description = "Windows Bastion VM Admin Password"
  default     = "S3cr3ts24"
}

# Windows Bastion VM Hostname (limited to 15 characters long)
variable "bastion-windows-vm-hostname" {
  type        = string
  description = "Windows Bastion VM Hostname"
  default     = "bastionwwin1"
}

# Windows Bastion VM Virtual Machine Size
variable "bastion-windows-vm-size" {
  type        = string
  description = "Windows Bastion VM Size"
  default     = "Standard_B2s"
}

##############
## OS Image ##
##############

# Windows Server 2019 SKU used to build VMs
variable "windows-2019-sku" {
  description = "Windows Server 2019 SKU used to build VMs"
  type        = "string"
  default     = "2019-Datacenter"
}

# Windows Server 2016 SKU used to build VMs
variable "windows-2016-sku" {
  description = "Windows Server 2016 SKU used to build VMs"
  type        = "string"
  default     = "2016-Datacenter"
}

# Windows Server 2012 R2 SKU used to build VMs
variable "windows-2012-sku" {
  description = "Windows Server 2012 R2 SKU used to build VMs"
  type        = "string"
  default     = "2012-R2-Datacenter"
}