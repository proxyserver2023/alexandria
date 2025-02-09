data "aws_ami" "ecs_optimized" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["amazon2-ami-ecs-hvm-*-x86_64-ebs"]
  }
}

resource "aws_launch_template" "ecs_lt" {
  name_prefix   = "${var.name}-lt-"
  image_id      = data.aws_ami.ecs_optimized.id
  instance_type = var.instance_type
  key_name      = var.key_name

  network_interfaces {
    associate_public_ip_address = true
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


resource "aws_autoscaling_group" "asg" {
  name = "${var.name}-asg"

  min_size                  = var.min
  max_size                  = var.max
  desired_capacity          = var.desired
  vpc_zone_identifier       = var.public_subnets
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
        instance_type     = "m8g.large"
        weighted_capacity = "2" # Each m8g.large counts as 2 capacity unit, because this is double the size of m8g.medium
      }
      override {
        instance_type     = "t4g.medium"
        weighted_capacity = "1"
      }
      override {
        instance_type     = "m5.large"
        weighted_capacity = "2"
      }
    }
  }

  tag {
    key                 = "Name"
    value               = "${var.name}-asg"
    propagate_at_launch = true
  }
}
