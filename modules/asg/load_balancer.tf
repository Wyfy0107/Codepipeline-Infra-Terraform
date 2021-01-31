resource "aws_lb" "demo" {
  name               = "${var.project}-${var.environment}"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.loadbalancer.id
  ]
  subnets = var.vpc_subnets_id

  tags = merge(
    local.common_tags,
    {
      Name = "loadbalancer"
    }
  )
}

resource "aws_lb_target_group" "demo" {
  name     = "${var.project}-${var.environment}"
  port     = 3000
  protocol = "HTTP"
  vpc_id   = var.vpc_id

  health_check {
    unhealthy_threshold = 6
  }
}

resource "aws_lb_listener" "demo" {
  load_balancer_arn = aws_lb.demo.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.demo.arn
  }
}

