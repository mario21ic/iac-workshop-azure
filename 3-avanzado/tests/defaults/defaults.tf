terraform {
  required_providers {
    test = {
      source = "terraform.io/builtin/test"
    }

    http = {
      source = "hashicorp/http"
    }
  }
}

module "main" {
  source = "../../"

}

resource "test_assertions" "myVnetName" {
  component = "my_terraform_network"

  equal "vnet_name" {
    description = "Default name is None"
    got         = module.main.vnet_name # output value
    # want        = "mivnet" # error
    want        = "myVnet" # expected
  }
}

resource "test_assertions" "myVmName" {
  component = "my_terraform_vm"

  equal "vnet_name" {
    description = "Default name is None"
    got         = module.main.vm_name # output value
    # want        = "mivm" # error
    want        = "myLinuxVM" # expected
  }
}


