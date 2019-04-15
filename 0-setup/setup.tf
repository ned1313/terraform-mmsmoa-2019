##################################################################################
# VARIABLES
##################################################################################

variable "arm_region" {
  default = "eastus"
}
variable "arm_resource_group_name" {
    default = "mms2019-setup"
}
variable "arm_subscription" {}
variable "arm_appId" {}
variable "arm_tenant" {}
variable "arm_password" {}
variable "arm_stroage_account_name" {
    default = "mms2019remotestate"
}
variable "arm_container_name" {
    default = "mms2019-remotestate-demos"
}

##################################################################################
# PROVIDERS
##################################################################################

provider "azurerm" {
  subscription_id = "${var.arm_subscription}"
  client_id = "${var.arm_appId}"
  client_secret     = "${var.arm_password}"
  tenant_id = "${var.arm_tenant}"
}

##################################################################################
# RESOURCES
##################################################################################
resource "azurerm_resource_group" "setup" {
  name = "${var.arm_resource_group_name}"
  location = "${var.arm_region}"
}

resource "azurerm_storage_account" "sa" {
  name = "${var.arm_stroage_account_name}"
  resource_group_name = "${var.arm_resource_group_name}"
  location = "${var.arm_region}"
  account_tier = "Standard"
  account_replication_type = "LRS"

  tags {
      environment = "setup"
  }
}

resource "azurerm_storage_container" "ct" {
  name = "${var.arm_container_name}"
  resource_group_name = "${var.arm_resource_group_name}"
  storage_account_name = "${azurerm_storage_account.sa.name}"

}

##################################################################################
# OUTPUT
##################################################################################