variable "network_interfaces" {
  description = "Network interfaces and the names of their subnet and public IP."
  type = map(object({
    name                 = string
    resource_group_name  = string
    subnet_name          = string
    virtual_network_name = string
    public_ip_name       = string
  }))
}
