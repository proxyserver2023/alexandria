
##############################
# VPC and Networking
###############################
module "vpc" {
  source = "git::https://github.com/proxyserver2023/alexandria.git//modules/aws/vpc?ref=dev"
  # Module variables
  name                = "my-vpc"
  cidr_block          = "10.0.0.0/16"
  public_subnet_count = 2
  public_subnet_bits  = 8
  availability_zones  = ["us-east-1a", "us-east-1b"]
}

###############################
# Security Groups
###############################
module "security_groups" {
  source = "git::https://github.com/proxyserver2023/alexandria.git//modules/aws/security-group?ref=dev"
  name   = "ecommerce"
  vpc_id = module.vpc.vpc_id
}


###############################
# Application Load Balancer
###############################
module "alb" {
  source         = "git::https://github.com/proxyserver2023/alexandria.git//modules/aws/alb?ref=dev"
  name           = "ecommerce"
  vpc_id         = module.vpc.vpc_id
  public_subnets = module.vpc.public_subnets
  alb_sg_id      = module.security_groups.alb_sg_id
  target_port    = 80
}


###############################
# ECS Cluster
###############################
module "ecs_cluster" {
  source = "git::https://github.com/proxyserver2023/alexandria.git//modules/aws/ecs/cluster?ref=dev"
  name   = "ecommerce-cluster"
}


###############################
# EC2 Auto Scaling Groups for ECS Tasks
###############################
module "ec2_asg" {
  source           = "git::https://github.com/proxyserver2023/alexandria.git//modules/aws/ec2-asg?ref=dev"
  name             = "ecommerce-ec2"
  instance_type    = "m8g.large"
  key_name         = var.key_name
  ecs_cluster_name = module.ecs_cluster.ecs_cluster_id
  public_subnets   = module.vpc.public_subnets
  ecs_sg_id        = module.security_groups.ecs_sg_id
  ondemand_min     = 0
  ondemand_max     = 1
  ondemand_desired = 1
  spot_min         = 2
  spot_max         = 10
  spot_desired     = 2
}
