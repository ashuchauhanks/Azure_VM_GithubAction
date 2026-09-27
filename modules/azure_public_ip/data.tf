data "azurerm_resource_group" "rg" {
  for_each = var.public_ips

  name = each.value.resource_group_name
}
