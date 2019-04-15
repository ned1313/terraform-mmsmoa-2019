##################################################################################
# PROVIDERS
##################################################################################

provider "azurerm" {
  use_msi = true
}

##################################################################################
# RESOURCES
##################################################################################

# NETWORKING #
resource "azurerm_resource_group" "rg" {
  name = "${local.resource_group}"
  location = "${var.arm_region}"
}


# NETWORKING #
module "vnet" {
    source              = "Azure/network/azurerm"
    resource_group_name = "${local.resource_group}"
    vnet_name = "mms-${terraform.workspace}-vnet"
    location            = "${var.arm_region}"
    address_space       = "${var.arm_network_address_space}"
    subnet_prefixes     = "${data.template_file.arm_cidrsubnet.*.rendered}"
    subnet_names        = "${data.template_file.arm_cidrsubnet_names.*.rendered}"

    tags                = {
                            environment = "${terraform.workspace}"
                          }
}
