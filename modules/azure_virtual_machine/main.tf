resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.linux_virtual_machines

  name                = each.value.name
  location            = data.azurerm_resource_group.rg[each.key].location
  resource_group_name = data.azurerm_resource_group.rg[each.key].name
  size                = each.value.size
  admin_username      = each.value.admin_username
  admin_password      = var.admin_password
  delete_os_disk_on_deletion = true
  network_interface_ids = [
    data.azurerm_network_interface.nic[each.key].id
  ]

  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

source_image_reference {
  publisher = var.linux_image.publisher
  offer     = var.linux_image.offer
  sku       = var.linux_image.sku
  version   = var.linux_image.version
}
# custom_data = filebase64("${path.root}/../../script-azure/bootstrap.sh")
custom_data = filebase64("../../script-azure/bootstrap.sh")
  tags = each.value.tags
}
