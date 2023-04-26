terraform {
  required_providers {
    vault = {
      source = "hashicorp/vault"
      version = "3.15.0"
    }
  }
}

variable "token" {}
provider "vault" {
  address = "http://localhost:8200"
  token   = var.token
}

resource "vault_generic_secret" "basic" {
  path = "secret/miclave"
  data_json = jsonencode({
    "miclave" = "miclaveesuperpoderosa"
  })
}

resource "vault_generic_secret" "example" {
  path = "secret/foo"

  data_json = jsonencode(
    {
      "foo"   = "bar",
      "pizza" = "cheese"
    }
  )
}

# data "vault_generic_secret" "foo" {
#   path = "secret/foo"
# }

# output "demo" {
#   value = data.vault_generic_secret.foo.data["foo"]
#   sensitive = true
# }
