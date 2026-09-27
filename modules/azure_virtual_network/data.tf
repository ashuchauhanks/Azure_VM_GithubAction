data "azurerm_resource_group" "rg" {
  for_each = var.virtual_networks

  name = each.value.resource_group_name
}
