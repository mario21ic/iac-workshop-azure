terraform {

  required_providers {
    consul = {
      source = "hashicorp/consul"
      version = "2.17.0"
    }

    azurerm = {
      source = "hashicorp/azurerm"
      version = "3.43.0"
    }
  }
}
