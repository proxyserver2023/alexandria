resource "aws_vpc" "git_runner" {
  cidr_block                       = var.vpc_cidr
  instance_tenancy                 = "default"
  enable_dns_hostnames             = true
  enable_dns_support               = true
  assign_generated_ipv6_cidr_block = false

  tags = {
    Name  = "github-selfhostedrunner-vpc-${var.stage}"
    Stage = var.stage
  }
}

resource "aws_internet_gateway" "git_runner" {
  vpc_id = aws_vpc.git_runner.id

  tags = {
    Name  = "github-selfhostedrunner-igw-${var.stage}"
    Stage = var.stage
  }
}

resource "aws_route_table" "public" {
  vpc_id = aws_vpc.git_runner.id
  tags = {
    Name  = "github-selfhostedrunner-rt-pub-${var.stage}"
    Stage = var.stage
  }
}

resource "aws_route" "public_internet_gateway" {
  route_table_id         = aws_route_table.public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.git_runner.id
}

resource "aws_subnet" "git_runner" {
  count             = 4
  vpc_id            = aws_vpc.git_runner.id
  cidr_block        = var.cidr_blocks[count.index]
  availability_zone = var.availability_zones[count.index]
  tags = {
    Name  = "github-selfhostedrunner-subnet-${count.index}-${var.stage}"
    Stage = var.stage
  }
}

resource "aws_route_table_association" "git_runner" {
  count          = length(aws_subnet.git_runner.*.id)
  subnet_id      = aws_subnet.git_runner[count.index].id
  route_table_id = aws_route_table.public.id
}

resource "aws_security_group" "git_runner" {
  name        = "github-selfhostedrunner-sg-${var.stage}"
  description = "github-selfhostedrunner-${var.stage} container security group"
  vpc_id      = aws_vpc.git_runner.id

  tags = {
    Name  = "github-selfhostedrunner-sg-${var.stage}"
    Stage = var.stage
  }
}

resource "aws_security_group_rule" "git_runner_egress" {
  description       = "Allow all outbound"
  security_group_id = aws_security_group.git_runner.id

  type        = "egress"
  from_port   = 0
  to_port     = 0
  protocol    = "-1"
  cidr_blocks = ["0.0.0.0/0"]
}

resource "aws_security_group_rule" "git_runner_ingress" {
  description       = "Allow all ingress between resources within this security group"
  type              = "ingress"
  to_port           = -1
  from_port         = -1
  protocol          = "all"
  security_group_id = aws_security_group.git_runner.id
  self              = true
}
