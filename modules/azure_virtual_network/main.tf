resource "azurerm_virtual_network" "vnet" {
  for_each = var.virtual_networks

  name                = each.value.name
  address_space       = each.value.address_space
  location            = data.azurerm_resource_group.rg[each.key].location
  resource_group_name = data.azurerm_resource_group.rg[each.key].name
}
