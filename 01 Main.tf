######################################################
# This file deploys the base Azure Resource
# Resource Group + vNet
######################################################

######################################################################
# Access to Azure
######################################################################

# Configure the Microsoft Azure Provider with Azure provider variable defined in AzureDFProvider.tf

provider "azurerm" {
  subscription_id = "${var.AzureSubscriptionID2}"
  client_id       = "${var.AzureClientID}"
  client_secret   = "${var.AzureClientSecret}"
  tenant_id       = "${var.AzureTenantID}"
}

######################################################################
# Foundations resources, including ResourceGroup and vNET
######################################################################

# Creating the ResourceGroups

module "ResourceGroup" {
  #Module Location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//01 ResourceGroup/"

  #Module variable
  RGName              = "${var.RGName}-${var.EnvironmentUsageTag}${var.EnvironmentTag}New"
  RGLocation          = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}



# Creating VNet

module "VNet" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//02 VNet"

  #Module variable
  vNetName            = "${var.vNetName}${var.EnvironmentUsageTag}${var.EnvironmentTag}"
  RGName              = "${module.ResourceGroup.Name}"
  vNetLocation        = "${var.AzureRegion}"
  vNetAddressSpace    = "${var.vNet1IPRange}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}


#Creating Storage Account for logs and Diagnostics

module "DiagStorageAccount" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//03 StorageAccountGP"

  #Module variable
  StorageAccountName     = "${var.EnvironmentTag}log"
  RGName                 = "${module.ResourceGroup.Name}"
  StorageAccountLocation = "${var.AzureRegion}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

module "LogStorageContainer" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//04 StorageAccountContainer"

  #Module variable
  StorageContainerName = "logs"
  RGName               = "${module.ResourceGroup.Name}"
  StorageAccountName   = "${module.DiagStorageAccount.Name}"
  AccessType           = "private"
}


module "LogEventGridStorageContainer" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//04 StorageAccountContainer"

  #Module variablegit 
  StorageContainerName = "logseventgrid"
  RGName               = "${module.ResourceGroup.Name}"
  StorageAccountName   = "${module.DiagStorageAccount.Name}"
  AccessType           = "private"
}


#Creating Storage Account for files exchange

module "FilesExchangeStorageAccount" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//03 StorageAccountGP"

  #Module variable
  StorageAccountName     = "${var.EnvironmentTag}file"
  RGName                 = "${module.ResourceGroup.Name}"
  StorageAccountLocation = "${var.AzureRegion}"
  StorageAccountTier     = "${lookup(var.storageaccounttier, 0)}"
  StorageReplicationType = "${lookup(var.storagereplicationtype, 0)}"
  EnvironmentTag         = "${var.EnvironmentTag}"
  EnvironmentUsageTag    = "${var.EnvironmentUsageTag}"
}

#Creating Storage Share

module "InfraFileShare" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//05 StorageAccountShare"

  #Module variable
  ShareName          = "infrafileshare"
  RGName             = "${module.ResourceGroup.Name}"
  StorageAccountName = "${module.FilesExchangeStorageAccount.Name}"
}


module "KeyVault" {
  #Module location

  source = "github.com/dfrappart/Terra-AZModuletest//Modules//27 Keyvault"

  #Module variables
  KeyVaultName            = "${var.EnvironmentUsageTag}${var.EnvironmentTag}-KeyVault"
  KeyVaultRG              = "${module.ResourceGroup.Name}"
  KeyVaultObjectIDPolicy2 = "${var.AzureServicePrincipalInteractive}"
  KeyVaultObjectIDPolicy1 = "${var.AzureTFSP}"
  KeyVaultTenantID        = "${var.AzureTenantID}"
  KeyVaultSKUName         = "premium"
  EnvironmentTag          = "${var.EnvironmentTag}"
  EnvironmentUsageTag     = "${var.EnvironmentUsageTag}"
}


