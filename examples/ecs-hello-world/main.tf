# main.tf in your project root

provider "aws" {
  region = "us-east-1"
}

module "ecs_hello_world" {
  source             = "../../modules/aws/ecs-hello-world"
  project_name       = "my-ecs-hello-world"
  region             = "us-east-1"
  vpc_cidr           = "10.0.0.0/16"
  availability_zones = ["us-east-1a", "us-east-1b"]
  container_image    = "nginxdemos/hello"
  desired_count      = 1
}

output "alb_dns" {
  description = "DNS of the ALB serving the ECS service"
  value       = module.ecs_hello_world.alb_dns_name
}
