##################################################################################
# PROVIDERS
##################################################################################

provider "azurerm" {
  subscription_id = "${var.arm_subscription}"
  client_id       = "${var.arm_appId}"
  client_secret   = "${var.arm_password}"
  tenant_id       = "${var.arm_tenant}"
}

##################################################################################
# DATA
##################################################################################

##################################################################################
# RESOURCES
##################################################################################

resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_group}"
  location = "${var.arm_region}"
}

# NETWORKING #
module "vnet" {
  source              = "Azure/network/azurerm"
  resource_group_name = "${local.resource_group}"
  vnet_name           = "mms-${terraform.workspace}-vnet"
  location            = "${var.arm_region}"
  address_space       = "${var.arm_network_address_space}"
  subnet_prefixes     = ["${var.arm_subnet1_address_space}", "${var.arm_subnet2_address_space}"]
  subnet_names        = ["subnet1", "subnet2"]

  tags = {
    environment = "${terraform.workspace}"
  }
}
