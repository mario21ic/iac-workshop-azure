data "azurerm_resource_group" "rg" {
  # name     = "mirecursorg"
  # name     = var.resource_group_name == "midevrg" ? "truerg" : "falserg"
  name     = var.resource_group_name
}
