module "nsg" {
  source = "./modules/nsg"
}

module "vnet" {
  source = "./modules/vnet"
}

module "vm" {
  source = "./modules/vm"
  subnet_id = module.vnet.subnet_id
  nsg_id = module.nsg.nsg_id
}
