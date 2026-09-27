variable "public_ips" {
  description = "Public IPs to create."
  type = map(object({
    name                = string
    resource_group_name = string
  }))
}
