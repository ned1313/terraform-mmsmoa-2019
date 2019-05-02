##################################################################################
# VARIABLES
##################################################################################
# Azure Variables
variable "arm_region" {
  default = "eastus"
}
variable "arm_resource_group_name" {
    default = "mms2019-1demo"
}
variable "arm_subscription" {}
variable "arm_appId" {}
variable "arm_tenant" {}
variable "arm_password" {}

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
# DATA
##################################################################################


##################################################################################
# RESOURCES
##################################################################################

resource "azurerm_resource_group" "demo" {
  name     = "${var.arm_resource_group_name}"
  location = "${var.arm_region}"

  tags {
    environment = "1-demo"
  }
}

resource "azurerm_container_group" "acg" {
  name                = "1-demo"
  location            = "${azurerm_resource_group.demo.location}"
  resource_group_name = "${azurerm_resource_group.demo.name}"
  ip_address_type     = "public"
  dns_name_label = "${var.arm_resource_group_name}"
  os_type             = "linux"


  container {
    name   = "hw"
    image  = "microsoft/aci-helloworld"
    cpu    = ".5"
    memory = "1.5"
    port   = "80"


    environment_variables {
      "NODE_ENV" = "testing"
    }
    commands = ["/bin/sh","-c","sed -i 's/Azure Container Instances/MMS MOA 2019/g' /usr/src/app/index.html && node /usr/src/app/index.js"]
  }

  tags {
    environment = "1-demo"
  }
}


##################################################################################
# OUTPUT
##################################################################################

output "aci-fqdn" {
  value = "http://${azurerm_container_group.acg.fqdn}"
}

