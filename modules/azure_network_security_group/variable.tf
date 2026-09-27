variable "network_security_groups" {
  description = "Network security groups and their approved SSH source CIDRs."
  type = map(object({
    name                      = string
    resource_group_name       = string
    ssh_source_address_prefix = string
  }))
}
