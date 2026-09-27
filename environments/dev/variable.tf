variable "resource_groups" {
  description = "Resource groups to create."
  type = map(object({
    name     = string
    location = string
  }))
}

variable "virtual_networks" {
  description = "Virtual networks and their resource group names."
  type = map(object({
    name                = string
    address_space       = list(string)
    resource_group_name = string
  }))
}

variable "subnets" {
  description = "Subnets and the names of their parent virtual networks and resource groups."
  type = map(object({
    name                 = string
    resource_group_name  = string
    virtual_network_name = string
    address_prefixes     = list(string)
  }))
}

variable "public_ips" {
  description = "Public IPs and their resource group names."
  type = map(object({
    name                = string
    resource_group_name = string
  }))
}

variable "network_security_groups" {
  description = "Network security groups and their approved SSH source CIDRs."
  type = map(object({
    name                      = string
    resource_group_name       = string
    ssh_source_address_prefix = string
  }))
}

variable "network_interfaces" {
  description = "Network interfaces and the names of their subnet, VNet, public IP, and resource group."
  type = map(object({
    name                 = string
    resource_group_name  = string
    subnet_name          = string
    virtual_network_name = string
    public_ip_name       = string
  }))
}

variable "associations" {
  description = "Network interface and security group pairs to associate."
  type = map(object({
    network_interface_name      = string
    network_security_group_name = string
    resource_group_name         = string
  }))
}

variable "linux_virtual_machines" {
  description = "Linux VMs and the names of their resource groups and network interfaces."
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
  description = "Administrator password for Linux VMs. Supply through TF_VAR_admin_password."
  type        = string
  sensitive   = true
}

variable "linux_image" {
  description = "Marketplace Linux image coordinates looked up in the VM child module."
  type = object({
    publisher = string
    offer     = string
    sku       = string
    version   = string
  })
}
