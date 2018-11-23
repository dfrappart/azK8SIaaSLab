##############################################################
#This file creates K8S Masters
##############################################################



#Availability set creation

module "AS_K8SMasters" {
  #Module source

  #source = "./Modules/13 AvailabilitySet"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//13 AvailabilitySet"

  #Module variables
  ASName              = "AS_K8SMasters"
  RGName              = "${module.ResourceGroup.Name}"
  ASLocation          = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#NIC Creation

module "NICs_K8SMasters" {
  #module source

  #source = "./Modules/09 NICWithoutPIPWithCount"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//12-2 NICWithoutPIPWithCount"

  #Module variables

  NICcount            = "1"
  NICName             = "NIC_K8SMaster"
  NICLocation         = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroup.Name}"
  SubnetId            = "${module.BE_Subnet.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}


#Datadisk creation

module "DataDisks_K8SMasters" {
  #Module source

  #source = "./Modules/06 ManagedDiskswithcount"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//11 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "1"
  ManageddiskName     = "DataDisk_K8SMaster"
  RGName              = "${module.ResourceGroup.Name}"
  ManagedDiskLocation = "${var.AzureRegion}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM creation

module "VMs_K8SMasters" {
  #module source

  #source = "./Modules/14 LinuxVMWithCount"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//14 - 2 LinuxVMWithCountwithCustomData"

  #Module variables

  VMCount           = "1"
  VMName            = "K8SMaster"
  VMLocation        = "${var.AzureRegion}"
  VMRG              = "${module.ResourceGroup.Name}"
  VMNICid           = ["${module.NICs_K8SMasters.Ids}"]
  VMSize            = "${lookup(var.VMSize, 1)}"
  ASID              = "${module.AS_K8SMasters.Id}"
  VMStorageTier     = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName       = "${var.VMAdminName}"
  VMAdminPassword   = "${var.VMAdminPassword}"
  DataDiskId        = ["${module.DataDisks_K8SMasters.Ids}"]
  DataDiskName      = ["${module.DataDisks_K8SMasters.Names}"]
  DataDiskSize      = ["${module.DataDisks_K8SMasters.Sizes}"]
  VMPublisherName   = "${lookup(var.PublisherName, 2)}"
  VMOffer           = "${lookup(var.Offer, 2)}"
  VMsku             = "${lookup(var.sku, 2)}"
  DiagnosticDiskURI = "${module.DiagStorageAccount.PrimaryBlobEP}"
  CloudinitscriptPath    = "./Scripts/baseline.sh"
  PublicSSHKey        = "${var.AzurePublicSSHKey}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}