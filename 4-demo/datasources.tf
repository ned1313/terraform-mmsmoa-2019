data "template_file" "arm_cidrsubnet" {
  count = "${var.arm_subnet_count}"

  template = "$${cidrsubnet(vpc_cidr,8,current_count)}"

  vars {
    vpc_cidr      = "${var.arm_network_address_space}"
    current_count = "${count.index}"
  }
}

data "template_file" "arm_cidrsubnet_names" {
  count = "${var.arm_subnet_count}"

  template = "subnet-$${current_count}"

  vars {
    current_count = "${count.index}"
  }
}