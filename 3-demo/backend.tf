terraform {
  backend "azurerm" {
    storage_account_name = "mms2019remotestate"
    container_name       = "mms2019-remotestate-demos"
    key                  = "3-demo.state"

    resource_group_name = "mms2019-setup"
  }
}
