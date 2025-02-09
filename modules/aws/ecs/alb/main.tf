resource "aws_lb" "app_alb" {
  name               = "${var.name}-alb"
  load_balancer_type = "application"
  subnets            = var.public_subnets
  security_groups    = [var.alb_sg_id]

  tags = {
    Name = "${var.name}-alb"
  }
}

resource "aws_lb_target_group" "app_tg" {
  name     = "${var.name}-tg"
  port     = var.target_port
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    path                = "/"
    protocol            = "HTTP"
    interval            = 30
    timeout             = 5
    healthy_threshold   = 3
    unhealthy_threshold = 3
  }

  tags = {
    Name = "${var.name}-tg"
  }
}

resource "aws_lb_listener" "http_listener" {
  load_balancer_arn = aws_lb.app_alb.arn
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.app_tg.arn
  }
}
