data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amzn2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "${var.name}-lt-"
  image_id      = data.aws_ami.ecs_optimized.id
  instance_type = var.instance_type
  key_name      = aws_key_pair.ec2_key.key_name

  network_interfaces {
    associate_public_ip_address = false
    security_groups             = [var.ecs_sg_id]
  }

  user_data = base64encode(<<-EOF
    #!/bin/bash
    echo ECS_CLUSTER=${var.ecs_cluster_name} >> /etc/ecs/ecs.config
  EOF
  )

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_autoscaling_group" "ondemand_asg" {
  name = "${var.name}-od"
  launch_template {
    id      = aws_launch_template.ecs_lt.id
    version = "$Latest"
  }
  min_size                  = var.ondemand_min
  max_size                  = var.ondemand_max
  desired_capacity          = var.ondemand_desired
  vpc_zone_identifier       = var.private_subnets
  health_check_type         = "EC2"
  health_check_grace_period = 300

  tag {
    key                 = "Name"
    value               = "${var.name}-od"
    propagate_at_launch = false
  }
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}


resource "aws_autoscaling_group" "spot_asg" {
  name = "${var.name}-spot"

  min_size                  = var.spot_min
  max_size                  = var.spot_max
  desired_capacity          = var.spot_desired
  vpc_zone_identifier       = var.private_subnets
  health_check_type         = "EC2"
  health_check_grace_period = 300

  mixed_instances_policy {
    instances_distribution {
      on_demand_base_capacity                  = 0
      on_demand_percentage_above_base_capacity = 0
      spot_allocation_strategy                 = "lowest-price"
      spot_instance_pools                      = 2
    }
    launch_template {
      launch_template_specification {
        launch_template_id = aws_launch_template.ecs_lt.id
        version            = "$Latest"
      }
      # Overrides let you specify alternative instance types and their weighted capacities.
      override {
        instance_type     = "r4.large"
        weighted_capacity = "1"
      }
      override {
        instance_type     = "m4.xlarge"
        weighted_capacity = "2" # Each m4.xlarge instance counts as 2 units of capacity
      }
      override {
        instance_type     = "c4.large"
        weighted_capacity = "1"
      }
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-spot"
    propagate_at_launch = false
  }
  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}
