module "azure_rg" {
  source          = "../../modules/azure_resource_group"
  resource_groups = var.resource_groups
}

module "azure_vnet" {
  source           = "../../modules/azure_virtual_network"
  virtual_networks = var.virtual_networks

  depends_on = [module.azure_rg]
}

module "azure_subnet" {
  source  = "../../modules/azure_subnet"
  subnets = var.subnets

  depends_on = [module.azure_vnet]
}

module "azure_public_ip" {
  source     = "../../modules/azure_public_ip"
  public_ips = var.public_ips

  depends_on = [module.azure_rg]
}

module "azure_nsg" {
  source                  = "../../modules/azure_network_security_group"
  network_security_groups = var.network_security_groups

  depends_on = [module.azure_rg]
}

module "azure_nic" {
  source             = "../../modules/azure_network_interface"
  network_interfaces = var.network_interfaces

  depends_on = [
    module.azure_subnet,
    module.azure_public_ip,
  ]
}

module "azure_nsg_nic_association" {
  source       = "../../modules/azure_nsg-nic-association"
  associations = var.associations

  depends_on = [
    module.azure_nic,
    module.azure_nsg,
  ]
}

module "azure_linux_vm" {
  source                 = "../../modules/azure_virtual_machine"
  linux_virtual_machines = var.linux_virtual_machines
  admin_password         = var.admin_password
  linux_image            = var.linux_image

  depends_on = [module.azure_nsg_nic_association]
}
