# Azure Variables
variable "arm_region" {
  default = "eastus"
}

variable "arm_resource_group_name" {
  default = "mms2019-3demo"
}

variable "arm_subscription" {}
variable "arm_appId" {}
variable "arm_tenant" {}
variable "arm_password" {}

#Local variables
locals {
  resource_group = "${terraform.workspace}-${var.arm_resource_group_name}"
}