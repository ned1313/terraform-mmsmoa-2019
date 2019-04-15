##################################################################################
# VARIABLES
##################################################################################

# Azure Variables
variable "arm_region" {
  default = "eastus"
}

variable "arm_resource_group_name" {
    default = "mms2019-demo4"
}
variable "arm_network_address_space" {
  default = "10.2.0.0/16"
}
variable "arm_subnet1_address_space" {
  default = "10.2.0.0/24"
}
variable "arm_subnet2_address_space" {
  default = "10.2.1.0/24"
}

variable "arm_subnet_count" {
  default = "2"
}

#Local variables
locals {
  resource_group = "${terraform.workspace}-${var.arm_resource_group_name}"

  
}