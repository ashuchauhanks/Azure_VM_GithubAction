data "azurerm_resource_group" "rg" {
  for_each = var.linux_virtual_machines

  name = each.value.resource_group_name
}

data "azurerm_network_interface" "nic" {
  for_each = var.linux_virtual_machines

  name                = each.value.network_interface_name
  resource_group_name = data.azurerm_resource_group.rg[each.key].name
}
