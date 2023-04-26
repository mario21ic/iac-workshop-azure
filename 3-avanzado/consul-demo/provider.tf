provider "azurerm" {
  features {}
}

provider "consul" {
  address    = "http://localhost:8500"
  datacenter = "dc1"
}
