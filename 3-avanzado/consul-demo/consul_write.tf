resource "consul_keys" "resource_group_name" {
  key {
    path  = "infra/${terraform.workspace}/base/resource_group_name"
    value = azurerm_resource_group.rg.name
  }
}
resource "consul_keys" "resource_group_location" {
  key {
    path  = "infra/${terraform.workspace}/base/resource_group_location"
    value = azurerm_resource_group.rg.location
  }
}
