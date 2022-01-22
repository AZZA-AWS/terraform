provider "aws" {
  profile = "vamsi"
  region  = "us-east-2"
}


module "network_module" {
  source = "./network_module"
}


module "loadbalancer_module" {
  source       = "./load_balancer_module"
  public_sg_id = module.network_module.public_sg_id
}

module "autoscaling_module" {
  source        = "./autoscaling_module"
  public_sg_id = module.network_module.public_sg_id
  tg_arn        = module.loadbalancer_module.tg_arn
}
