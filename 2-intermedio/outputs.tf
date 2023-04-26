output "vm_id" {
  value = azurerm_linux_virtual_machine.my_terraform_vm.id
}
output "public_ip_address_id" {
  value = azurerm_public_ip.my_terraform_public_ip.ip_address
}