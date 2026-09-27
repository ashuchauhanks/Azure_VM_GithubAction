variable "virtual_networks" {
  description = "Virtual networks to create."
  type = map(object({
    name                = string
    address_space       = list(string)
    resource_group_name = string
  }))
}
