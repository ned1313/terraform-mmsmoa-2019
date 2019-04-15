##################################################################################
# OUTPUT
##################################################################################

output "vnet_name" {
  value = "${module.vnet.vnet_name}"
}

output "vnet_id" {
  value = "${module.vnet.vnet_id}"
}

output "subnet_1" {
  value = "${module.vnet.vnet_subnets[0]}"
}

