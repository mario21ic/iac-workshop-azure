variable "resource_group_name" {
    type = string
    description = "Nombre del grupo de recursos"
    #default = "myResourceGroup"
    default = "minuevorg"
    # default = "new" # error en validacion
    validation {
      condition = length(var.resource_group_name) > 4 && substr(var.resource_group_name, 0, 2) == "mi"
      error_message = "El nombre del resource group debe tener prefix 'mi'"
    }
}
