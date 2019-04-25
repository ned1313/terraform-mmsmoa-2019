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

data "terraform_remote_state" "2-demo" {
    backend = "azurerm"
    config {
        storage_account_name  = "mms2019remotestate"
        container_name        = "mms2019-remotestate-demos"
        key                   = "2-demo.state"
        resource_group_name = "mms2019-setup"
        arm_client_id = "${var.arm_appId}"
        arm_client_secret = "${var.arm_password}"
    }
}

##################################################################################
# RESOURCES
##################################################################################

resource "azurerm_resource_group" "rg" {
  name     = "${local.resource_group}"
  location = "${var.arm_region}"
}

module "loadbalancer" {
  source              = "Azure/loadbalancer/azurerm"
  resource_group_name = "${local.resource_group}"
  location            = "${var.arm_region}"
  prefix              = "mms2019"

  "remote_port" {
    ssh = ["Tcp", "22"]
  }

  "lb_port" {
    http = ["80", "Tcp", "80"]
  }
}

module "vmss" {
    source              = "Azure/vmss-cloudinit/azurerm"
    resource_group_name = "${local.resource_group}"
    location            = "${var.arm_region}"
    cloudconfig_file    = "${path.root}/cloudconfig.tpl"
    vm_size             = "Standard_DS2_v2"
    admin_username      = "azureuser"
    admin_password      = "ComplexPassword"
    ssh_key             = "~/.ssh/nbellavancePublic.pem"
    nb_instance         = 2
    vm_os_simple        = "UbuntuServer"
    vnet_subnet_id      = "${data.terraform_remote_state.2-demo.subnet_1}"
    load_balancer_backend_address_pool_ids = "${module.loadbalancer.azurerm_lb_backend_address_pool_id}"
    tags                = {
                            environment = "dev"
                            costcenter  = "it"
                          }
}


