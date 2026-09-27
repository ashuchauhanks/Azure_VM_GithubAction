data "azurerm_network_interface" "nic" {
  for_each = var.associations

  name                = each.value.network_interface_name
  resource_group_name = each.value.resource_group_name
}

data "azurerm_network_security_group" "nsg" {
  for_each = var.associations

  name                = each.value.network_security_group_name
  resource_group_name = each.value.resource_group_name
}
