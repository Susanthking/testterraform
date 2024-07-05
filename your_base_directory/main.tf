provider "aws" {
  region                = "us-east-1"
}

module "vpc" {
  source = "./modules/vpc"
}

module "subnets" {
  source = "./modules/subnets"
  vpc_id = module.vpc.vpc_id
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "nat_gateway" {
  source          = "./modules/nat_gateway"
  vpc_id          = module.vpc.vpc_id
  public_subnet_1 = module.subnets.public_subnet_1
  public_subnet_2 = module.subnets.public_subnet_2
}

module "ec2" {
  source            = "./modules/ec2"
  public_subnet_1   = module.subnets.public_subnet_1
  public_subnet_2   = module.subnets.public_subnet_2
  security_group_id = module.security_groups.ec2_sg_id
}

module "load_balancer" {
  source            = "./modules/load_balancer"
  vpc_id            = module.vpc.vpc_id
  public_subnet_1   = module.subnets.public_subnet_1
  public_subnet_2   = module.subnets.public_subnet_2
  security_group_id = module.security_groups.lb_sg_id
  instance_ids      = module.ec2.instance_ids
}

module "rds" {
  source            = "./modules/rds"
  private_subnet_1  = module.subnets.private_subnet_1
  private_subnet_2  = module.subnets.private_subnet_2
  security_group_id = module.security_groups.rds_sg_id
}

