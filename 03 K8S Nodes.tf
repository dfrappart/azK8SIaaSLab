##############################################################
#This file creates K8S Nodes
##############################################################

#LB K8S Creation

module "K8SLB" {

  #Module source
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//37 ExternalLB Standalone"

  #Module variables
  ExtLBName           = "k8slb"
  AzureRegion         = "${var.AzureRegion}"
  FEConfigName        = "k8slbconfig"
  PublicIPId          = "${element(module.NodesPublicIP.Ids,0)}"
  RGName              = "${module.ResourceGroup.Name}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

module "K8SLBBE" {

  #Module source
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//38 BackEndPool"

  #Module variables
  LBBackEndPoolName = "k8slbbe"
  RGName            = "${var.AzureRegion}"
  LBId              = "${module.K8SLB.Id}"

}

module "K8SLBProbe" {

  #Module source
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//39 HealthProbe"

  #Module variables
  LBProbeName       = "k8slbbe"
  RGName            = "${var.AzureRegion}"
  LBId              = "${module.K8SLB.Id}"
  LBProbePort       = "80"
  
}

module "K8SLBRule" {

  #Module source
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//40 LBRule"

  #Module variables
  FERuleName     = "k8slbrule"
  RGName         = "${var.AzureRegion}"
  LBId           = "${module.K8SLB.Id}"
  LBProbId       = "${module.K8SLBProbe.Id}"
  BEPoolId       = "${module.K8SLBBE.Id}"
  FEConfigName   = "k8slbconfig"

}


#Nodes public IP Creation

module "NodesPublicIP" {
  #Module source
  #source = "./Modules/10 PublicIP"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//10 PublicIP"

  #Module variables
  PublicIPCount       = "1"
  PublicIPName        = "nodepip"
  PublicIPLocation    = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroup.Name}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Availability set creation

module "AS_K8SNodes" {
  #Module source

  #source = "./Modules/13 AvailabilitySet"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//13 AvailabilitySet"

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
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//12-2 NICWithoutPIPWithCount"

  #Module variables

  NICcount            = "2"
  NICName             = "NIC_K8SNode"
  NICLocation         = "${var.AzureRegion}"
  RGName              = "${module.ResourceGroup.Name}"
  SubnetId            = "${module.FE_Subnet.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
  IsLoadBalanced      = "1"
  LBBackEndPoolid     = ["${module.K8SLBBE.Id}","${module.K8SLBBE.Id}"]
}


#Datadisk creation

module "DataDisks_K8SNodes" {
  #Module source

  #source = "./Modules/06 ManagedDiskswithcount"
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//11 ManagedDiskswithcount"

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

  VMCount             = "2"
  VMName              = "K8SNode"
  VMLocation          = "${var.AzureRegion}"
  VMRG                = "${module.ResourceGroup.Name}"
  VMNICid             = ["${module.NICs_K8SNodes.LBIds}"]
  VMSize              = "${lookup(var.VMSize, 1)}"
  ASID                = "${module.AS_K8SNodes.Id}"
  VMStorageTier       = "${lookup(var.Manageddiskstoragetier, 0)}"
  VMAdminName         = "${var.VMAdminName}"
  VMAdminPassword     = "${var.VMAdminPassword}"
  DataDiskId          = ["${module.DataDisks_K8SNodes.Ids}"]
  DataDiskName        = ["${module.DataDisks_K8SNodes.Names}"]
  DataDiskSize        = ["${module.DataDisks_K8SNodes.Sizes}"]
  VMPublisherName     = "${lookup(var.PublisherName, 2)}"
  VMOffer             = "${lookup(var.Offer, 2)}"
  VMsku               = "${lookup(var.sku, 2)}"
  DiagnosticDiskURI   = "${module.DiagStorageAccount.PrimaryBlobEP}"
  CloudinitscriptPath = "./Scripts/Kubadminit.sh"
  PublicSSHKey        = "${var.AzurePublicSSHKey}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}