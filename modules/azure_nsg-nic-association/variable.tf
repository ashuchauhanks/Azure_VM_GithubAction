variable "associations" {
  description = "Network interface and network security group pairs to associate."
  type = map(object({
    network_interface_name      = string
    network_security_group_name = string
    resource_group_name         = string
  }))
}
