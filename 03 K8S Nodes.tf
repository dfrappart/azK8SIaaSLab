##############################################################
#This file creates K8S Nodes
##############################################################



#Availability set creation

module "AS_K8SNodes" {
  #Module source

  #source = "./Modules/13 AvailabilitySet"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//13 AvailabilitySet"

  #Module variables
  ASName              = "AS_K8SNodes"
  RGName              = "${module.ResourceGroup.Name}"
  ASLocation          = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#NIC Creation

module "NICs_K8SNodes" {
  #module source

  #source = "./Modules/09 NICWithoutPIPWithCount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//09 NICWithoutPIPWithCount"

  #Module variables

  NICcount            = "2"
  NICName             = "NIC_K8SNode"
  NICLocation         = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroup.Name}"
  SubnetId            = "${module.FE_Subnet.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}


#Datadisk creation

module "DataDisks_K8SNodes" {
  #Module source

  #source = "./Modules/06 ManagedDiskswithcount"
  source = "github.com/dfrappart/Terra-AZBasiclinuxWithModules//Modules//06 ManagedDiskswithcount"

  #Module variables

  Manageddiskcount    = "2"
  ManageddiskName     = "DataDisk_K8SNode"
  RGName              = "${module.ResourceGroup.Name}"
  ManagedDiskLocation = "${var.AzureRegion}"
  StorageAccountType  = "${lookup(var.Manageddiskstoragetier, 0)}"
  CreateOption        = "Empty"
  DiskSizeInGB        = "63"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#VM creation

module "VMs_K8SNodes" {
  #module source

  #source = "./Modules/14 LinuxVMWithCount"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//14 - 2 LinuxVMWithCountwithCustomData"

  #Module variables

  VMCount           = "2"
  VMName            = "K8SNode"
  VMLocation        = "${var.AzureRegion}"
  VMRG              = "${module.ResourceGroup.Name}"
  VMNICid           = ["${module.NICs_K8SNodes.Ids}"]
  VMSize            = "${lookup(var.VMSize, 1)}"
  ASID              = "${module.AS_K8SNodes.Id}"
  VMStorageTier     = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName       = "${var.VMAdminName}"
  VMAdminPassword   = "${var.VMAdminPassword}"
  DataDiskId        = ["${module.DataDisks_K8SNodes.Ids}"]
  DataDiskName      = ["${module.DataDisks_K8SNodes.Names}"]
  DataDiskSize      = ["${module.DataDisks_K8SNodes.Sizes}"]
  VMPublisherName   = "${lookup(var.PublisherName, 2)}"
  VMOffer           = "${lookup(var.Offer, 2)}"
  VMsku             = "${lookup(var.sku, 2)}"
  DiagnosticDiskURI = "${module.DiagStorageAccount.PrimaryBlobEP}"
  CloudinitscriptPath    = "./Scripts/baseline.sh"
  PublicSSHKey        = "${var.AzurePublicSSHKey}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}