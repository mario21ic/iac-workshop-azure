provider "azurerm" {
  features {}
}

provider "consul" {
  address    = "http://localhost:8500"
  datacenter = "dc1"
}

variable "token" {}
provider "vault" {
  address = "http://localhost:8200"
  token   = var.token
}