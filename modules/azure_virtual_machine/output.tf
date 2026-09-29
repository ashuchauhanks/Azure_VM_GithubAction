output "linux_vm_ids" {
  value = {
    for key, vm in azurerm_linux_virtual_machine.vm :
    key => vm.id
  }
}

output "linux_vm_names" {
  value = {
    for key, vm in azurerm_linux_virtual_machine.vm :
    key => vm.name
  }
}