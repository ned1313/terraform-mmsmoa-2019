##################################################################################
# OUTPUT
##################################################################################

output "vnet_name" {
  value = "${module.vnet.vnet_name}"
}

output "vnet_cidr" {
  value = "${module.vnet.vnet_address_space}"
}


