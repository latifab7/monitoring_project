
module "vpc" {      
  source = "./vpc"  
  vpc_cidr = "10.0.0.0/16"
  public_cidr = "10.0.1.0/24"
  monitor_cidr = "10.0.2.0/24"
}


module "web" {
  source = "./web"
  public_sg = module.security.public_sg
  monitor_sg = module.security.monitor_sg
  public_subnet = module.vpc.public_subnet   
  monitor_subnet = module.vpc.monitor_subnet
}

module "security" {
  source = "./security"    
  vpc_id = module.vpc.vpc_id
  trusted_ip = "0.0.0.0/0"
}

