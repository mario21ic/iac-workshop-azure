output "vnet_name" {
  value = azurerm_virtual_network.my_terraform_network.name
  # value = module.myvnet.vnet_name
}

output "vm_id" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.id
}
output "vm_name" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.name
}

output "public_ip_address" {
  value = azurerm_public_ip.my_terraform_public_ip.ip_address
}
