######################################################
# This file deploys the subnet and NSG for 
#Basic linux architecture Architecture
######################################################

######################################################################
# Subnet and NSG
######################################################################

######################################################################
# Bastion zone
######################################################################

#Bastion_Subnet NSG

module "NSG_Bastion_Subnet" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//07 NSG"

  #Module variable
  NSGName             = "NSG_${lookup(var.SubnetName, 2)}"
  RGName              = "${module.ResourceGroup.Name}"
  NSGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#Bastion_Subnet

module "Bastion_Subnet" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//06-1 Subnet"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 2)}"
  RGName              = "${module.ResourceGroup.Name}"
  vNetName            = "${module.VNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 2)}"
  NSGid               = "${module.NSG_Bastion_Subnet.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

######################################################################
# FE zone
######################################################################

#FE_Subnet NSG

module "NSG_FE_Subnet" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//07 NSG"

  #Module variable
  NSGName             = "NSG_${lookup(var.SubnetName, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  NSGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#FE_Subnet1

module "FE_Subnet" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//06-1 Subnet"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 0)}"
  RGName              = "${module.ResourceGroup.Name}"
  vNetName            = "${module.VNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 0)}"
  NSGid               = "${module.NSG_FE_Subnet.Id}"
  #RouteTableId        = "${module.RouteTable.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}



######################################################################
# BE zone
######################################################################

#BE_Subnet NSG

module "NSG_BE_Subnet" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//07 NSG"

  #Module variable
  NSGName             = "NSG_BE_Subnet"
  RGName              = "${module.ResourceGroup.Name}"
  NSGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#BE_Subnet1

module "BE_Subnet" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//06-1 Subnet"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 1)}"
  RGName              = "${module.ResourceGroup.Name}"
  vNetName            = "${module.VNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 1)}"
  NSGid               = "${module.NSG_BE_Subnet.Id}"
  #RouteTableId        = "${module.RouteTable.Id}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}



######################################################################
# GW Subnet zone
######################################################################

#FW_Subnet

module "GW_Subnet" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//06-2 SubnetWithoutNSG"

  #Module variable
  SubnetName          = "${lookup(var.SubnetName, 4)}"
  RGName              = "${module.ResourceGroup.Name}"
  vNetName            = "${module.VNet.Name}"
  Subnetaddressprefix = "${lookup(var.SubnetAddressRange, 4)}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}


/*
######################################################################
# Application Security Groups
######################################################################

#ASG for MSSQL Servers
module "ASG_DB" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//07-2 Application Security Group"

  #Module variables
  ASGName             = "ASG_DB"
  RGName              = "${module.ResourceGroup.Name}"
  ASGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}

#ASG for IIS Server

module "ASG_Web" {
  #Module location
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//07-2 Application Security Group"

  #Module variables
  ASGName             = "ASG_Web"
  RGName              = "${module.ResourceGroup.Name}"
  ASGLocation         = "${var.AzureRegion}"
  EnvironmentTag      = "${var.EnvironmentTag}"
  EnvironmentUsageTag = "${var.EnvironmentUsageTag}"
}
*/

#NSG Rules
/*
module "AllowHTTP-HTTPSFromInternetFEIn" {
  #Module source
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//08-1 NSGRule"

  #Module variable
  RGName                            = "${module.ResourceGroup.Name}"
  NSGReference                      = "${module.NSG_FE_Subnet.Name}"
  NSGRuleName                       = "AllowHTTP-HTTPSFromInternetFEIn"
  NSGRulePriority                   = 101
  NSGRuleDirection                  = "Inbound"
  NSGRuleAccess                     = "Allow"
  NSGRuleProtocol                   = "Tcp"
  NSGRuleDestinationPortRanges       = [80,443]
  NSGRuleSourceAddressPrefixes      = ["0.0.0.0/0"]
  NSGRuleDestinationAddressPrefixes = ["${lookup(var.SubnetAddressRange, 0)}"]
}

*/
module "AllowSSHromInternetBastionIn" {
  #Module source
  source = "github.com/dfrappart/Terra-AZModuletest//Modules//08-2 NSGRule with services tags"

  #Module variable
  RGName                          = "${module.ResourceGroup.Name}"
  NSGReference                    = "${module.NSG_Bastion_Subnet.Name}"
  NSGRuleName                     = "AllowRDPromInternetBastionIn"
  NSGRulePriority                 = 101
  NSGRuleDirection                = "Inbound"
  NSGRuleAccess                   = "Allow"
  NSGRuleProtocol                 = "Tcp"
  NSGRuleSourcePortRange          = "*"
  NSGRuleDestinationPortRange     = 22
  NSGRuleSourceAddressPrefix      = "Internet"
  NSGRuleDestinationAddressPrefix = "${lookup(var.SubnetAddressRange, 2)}"
}