data "azurerm_resource_group" "rg" {
  for_each = var.network_security_groups

  name = each.value.resource_group_name
}
