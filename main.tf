provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_cidr = var.vpc_cidr
  public_subnet_cidrs = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  availability_zones = var.availability_zones
}

module "security_groups" {
  source = "./modules/security_groups"
  vpc_id = module.vpc.vpc_id
}

module "alb" {
  source = "./modules/alb"
  vpc_id = module.vpc.vpc_id
  public_subnet_ids = module.vpc.public_subnet_ids
  alb_security_group_id = module.security_groups.alb_sg_id
  certificate_arn = module.certificate.arn
  ec2_instance_id = module.ec2.instance_id
  target_subnet_ids = []
}

module "ec2" {
  source = "./modules/ec2"
  ami_id = var.ami_id
  instance_type = var.instance_type
  subnet_id = element(module.vpc.private_subnet_ids, 0)  # Use a private subnet
  ec2_security_group_id = module.security_groups.ec2_sg_id
  key_name = var.key_name
}

module "certificate" {
  source = "./modules/certificate"
  domain_name = var.domain_name
  route53_zone_id = var.zone_id
}

module "route53" {
  source = "./modules/route53"
  domain_name = var.domain_name
  zone_id = var.zone_id
  alb_dns_name = module.alb.alb_dns_name
  alb_zone_id = module.alb.alb_zone_id
}

output "alb_dns_name" {
  value = module.alb.alb_dns_name
}

output "instance_private_ip" {
  value = module.ec2.private_ip
}

output "zone_id" {
  value = module.route53.zone_id
}
