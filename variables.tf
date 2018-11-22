######################################################
# Variables for Template
######################################################

# Variable to define the Azure Region

variable "AzureRegion" {
  type    = "string"
  default = "westeurope"
}

# Variable to define the Tag

variable "EnvironmentTag" {
  type    = "string"
  default = "K8SIaaS"
}

variable "EnvironmentUsageTag" {
  type    = "string"
  default = "Lab"
}

# Variable to define the Resource Group Name

variable "RGName" {
  type    = "string"
  default = "RG"
}

#Variable defining the vnet name

variable "vNetName" {
  type    = "string"
  default = "VNet"
}

#Variable defining the vnet ip range

variable "vNet1IPRange" {
  type    = "list"
  default = ["10.0.0.0/20"]
}

variable "vNet2IPRange" {
  type    = "list"
  default = ["10.0.16.0/20"]
}

variable "SubnetAddressRange" {
  #Note: Subnet must be in range included in the vNET Range

  default = {
    "0" = "10.0.0.0/24"
    "1" = "10.0.1.0/24"
    "2" = "10.0.2.0/24"
    "3" = "10.0.3.0/25"
    "4" = "10.0.3.128/25"
    "5" = "10.0.16.0/24"
    "6" = "10.0.17.0/24"
    "7" = "10.0.18.0/24"
    "8" = "10.0.19.0/25"
    "9" = "10.0.19.128/25"    
  }
}

variable "SubnetName" {
  default = {
    "0" = "FE_Subnet"
    "1" = "BE_Subnet"
    "2" = "Bastion_Subnet"
    "3" = "AzureFirewallSubnet"
    "4" = "GatewaySubnet"
  }
}

#variable defining VM size
variable "VMSize" {
  type = "map"

  default = {
    "0" = "Standard_F1S_v2"
    "1" = "Standard_F2S_v2"
    "2" = "Standard_D2_v3"
    "3" = "Standard_D4_v3"
  }
}

# variable defining storage account tier

variable "storageaccounttier" {
  default = {
    "0" = "standard"
    "1" = "premium"
  }
}

# variable defining storage replication type

variable "storagereplicationtype" {
  default = {
    "0" = "LRS"
    "1" = "GRS"
    "2" = "RAGRS"
    "3" = "ZRS"
  }
}

# variable defining storage account tier for managed disk

variable "Manageddiskstoragetier" {
  default = {
    "0" = "standard_lrs"
    "1" = "premium_lrs"
  }
}

# variable defining VM image 

# variable defining VM image 

variable "PublisherName" {
  default = {
    "0" = "microsoftwindowsserver"
    "1" = "MicrosoftVisualStudio"
    "2" = "canonical"
    "3" = "credativ"
    "4" = "Openlogic"
    "5" = "RedHat"
    "6" = "MicrosoftSQLServer"
  }
}

variable "Offer" {
  default = {
    "0" = "WindowsServer"
    "1" = "Windows"
    "2" = "ubuntuserver"
    "3" = "debian"
    "4" = "CentOS"
    "5" = "RHEL"
    "6" = "SQL2016SP1-WS2016"
  }
}

variable "sku" {
  default = {
    "0" = "2016-Datacenter"
    "1" = "Windows-10-N-x64"
    "2" = "16.04.0-LTS"
    "3" = "9"
    "4" = "7.4"
    "5" = "7.4"
    "6" = "Enterprise"
  }
}
