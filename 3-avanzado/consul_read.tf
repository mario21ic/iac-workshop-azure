data "consul_keys" "resource_group_name" {
  key {
    name = "resource_group_name"
    path  = "infra/${terraform.workspace}/base/resource_group_name"
    # default = "sinrg"
  }
}

data "consul_keys" "resource_group_location" {
  key {
    name = "resource_group_location"
    path  = "infra/${terraform.workspace}/base/resource_group_location"
    # default = ""
  }
}
