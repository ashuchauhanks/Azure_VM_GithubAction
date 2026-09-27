variable "linux_virtual_machines" {
  description = "Linux virtual machines and their resource group/network interface names."
  type = map(object({
    name                   = string
    resource_group_name    = string
    network_interface_name = string
    size                   = string
    admin_username         = string
    tags                   = map(string)
  }))
}

variable "admin_password" {
  description = "Administrator password shared by the Linux VMs."
  type        = string
  sensitive   = true
}

variable "linux_image" {
  description = "Marketplace Linux image coordinates looked up in this child module."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}
