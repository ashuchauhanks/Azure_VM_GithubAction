resource_groups = {
  rg1 = {
    name     = "rg-terraform-dev"
    location = "centralindia"
  }
}

virtual_networks = {
  vnet1 = {
    name                = "vnet-terraform-dev"
    address_space       = ["10.10.0.0/16"]
    resource_group_name = "rg-terraform-dev"
  }
}

subnets = {
  subnet1 = {
    name                 = "subnet-vm"
    resource_group_name  = "rg-terraform-dev"
    virtual_network_name = "vnet-terraform-dev"
    address_prefixes     = ["10.10.1.0/24"]
  }
}

public_ips = {
  pip1 = {
    name                = "pip-linux-vm-dev"
    resource_group_name = "rg-terraform-dev"
  }
}

network_security_groups = {
  nsg1 = {
    name                      = "nsg-linux-vm-dev"
    resource_group_name       = "rg-terraform-dev"
    ssh_source_address_prefix = "203.0.113.10/32"
  }
}

network_interfaces = {
  nic1 = {
    name                 = "nic-linux-vm-dev"
    resource_group_name  = "rg-terraform-dev"
    subnet_name          = "subnet-vm"
    virtual_network_name = "vnet-terraform-dev"
    public_ip_name       = "pip-linux-vm-dev"
  }
}

associations = {
  nic1 = {
    network_interface_name      = "nic-linux-vm-dev"
    network_security_group_name = "nsg-linux-vm-dev"
    resource_group_name         = "rg-terraform-dev"
  }
}

linux_virtual_machines = {
  vm1 = {
    name                   = "vm-linux-dev"
    resource_group_name    = "rg-terraform-dev"
    network_interface_name = "nic-linux-vm-dev"
    size                   = "Standard_D2ads_v7"
    admin_username         = "azureuser"
    tags = {
      environment = "dev"
      managed_by  = "terraform"
    }
  }
}

linux_image = {
  publisher = "Canonical"
  offer     = "0001-com-ubuntu-server-jammy"
  sku       = "22_04-lts-gen2"
  version   = "latest"
}
