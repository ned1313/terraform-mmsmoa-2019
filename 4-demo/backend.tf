terraform {
  backend "azurerm" {
    storage_account_name = "mms2019remotestate"
    container_name       = "mms2019-remotestate-demos"
    key                  = "4-demo.state"
  }
}