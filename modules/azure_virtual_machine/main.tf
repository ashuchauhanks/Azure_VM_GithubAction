resource "azurerm_linux_virtual_machine" "vm" {
  for_each = var.linux_virtual_machines

  name                = each.value.name
  location            = data.azurerm_resource_group.rg[each.key].location
  resource_group_name = data.azurerm_resource_group.rg[each.key].name
  size                = each.value.size
  admin_username      = each.value.admin_username
  admin_password      = var.admin_password
  network_interface_ids = [
    data.azurerm_network_interface.nic[each.key].id
  ]

  disable_password_authentication = false

  os_disk {
    caching              = "ReadWrite"
    storage_account_type = "Standard_LRS"
  }

  source_image_reference {
    publisher = data.azurerm_platform_image.linux[each.key].publisher
    offer     = data.azurerm_platform_image.linux[each.key].offer
    sku       = data.azurerm_platform_image.linux[each.key].sku
    version   = data.azurerm_platform_image.linux[each.key].version
  }

  tags = each.value.tags
}
