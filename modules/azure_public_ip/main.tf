resource "azurerm_public_ip" "pip" {
  for_each = var.public_ips

  name                = each.value.name
  location            = data.azurerm_resource_group.rg[each.key].location
  resource_group_name = data.azurerm_resource_group.rg[each.key].name
  allocation_method   = "Static"
  sku                 = "Standard"
}
