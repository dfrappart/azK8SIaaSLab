##############################################################
#This file creates K8S Bastion
##############################################################



#Bastion public IP Creation

module "BastionPublicIP" {
  #Module source
  #source = "./Modules/10 PublicIP"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//10 PublicIP"

  #Module variables
  PublicIPCount       = "1"
  PublicIPName        = "bastionpip"
  PublicIPLocation    = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroup.Name}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Availability set creation

module "AS_Bastion" {
  #Module source

  #source = "./Modules/13 AvailabilitySet"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//13 AvailabilitySet"

  #Module variables
  ASName              = "AS_Bastion"
  RGName              = "${module.ResourceGroup.Name}"
  ASLocation          = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#NIC Creation

module "NICs_Bastion" {
  #module source

  #source = "./Modules/12 NICwithPIPWithCount"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//12-1 NICwithPIPWithCount"

  #Module variables

  NICCount            = "1"
  NICName             = "NIC_Bastion"
  NICLocation         = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroup.Name}"
  SubnetId            = "${module.Bastion_Subnet.Id}"
  PublicIPId          = ["${module.BastionPublicIP.Ids}"]
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Datadisk creation

module "DataDisks_Bastion" {
  #Module source

  #source = "./Modules/06 ManagedDiskswithcount"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//11 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "1"
  ManageddiskName     = "DataDisk_Bastion"
  RGName              = "${module.ResourceGroup.Name}"
  ManagedDiskLocation = "${var.AzureRegion}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM creation

module "VMs_Bastion" {
  #module source

  #source = "./Modules/14 LinuxVMWithCount"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//14 - 2 LinuxVMWithCountwithCustomData"

  #Module variables

  VMCount           = "1"
  VMName            = "Bastion"
  VMLocation        = "${var.AzureRegion}"
  VMRG              = "${module.ResourceGroup.Name}"
  VMNICid           = ["${module.NICs_Bastion.Ids}"]
  VMSize            = "${lookup(var.VMSize, 1)}"
  ASID              = "${module.AS_Bastion.Id}"
  VMStorageTier     = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName       = "${var.VMAdminName}"
  VMAdminPassword   = "${var.VMAdminPassword}"
  DataDiskId        = ["${module.DataDisks_Bastion.Ids}"]
  DataDiskName      = ["${module.DataDisks_Bastion.Names}"]
  DataDiskSize      = ["${module.DataDisks_Bastion.Sizes}"]
  VMPublisherName   = "${lookup(var.PublisherName, 2)}"
  VMOffer           = "${lookup(var.Offer, 2)}"
  VMsku             = "${lookup(var.sku, 2)}"
  DiagnosticDiskURI = "${module.DiagStorageAccount.PrimaryBlobEP}"
  CloudinitscriptPath    = "./Scripts/baseline.sh"
  PublicSSHKey        = "${var.AzurePublicSSHKey}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}