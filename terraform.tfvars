####################
# Common Variables #
####################
company     = "kopicloud"
app_name    = "iaas"
environment = "development"
location    = "northeurope"

##################
# Authentication #
##################
azure-subscription-id = ""
azure-client-id       = ""
azure-client-secret   = ""
azure-tenant-id       = ""

###########
# Network #
###########
network-vnet-cidr   = "10.128.0.0/16"
network-subnet-cidr = "10.128.1.0/24"

######################
# Bastion Windows VM #
######################
bastion-windows-vm-hostname    = "bastionwin1"
bastion-windows-vm-size        = "Standard_B2s"
bastion-windows-admin-username = "tfadmin"
bastion-windows-admin-password = "S3cr3ts24"
