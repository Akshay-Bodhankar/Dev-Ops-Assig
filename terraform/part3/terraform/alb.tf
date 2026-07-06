#############################################
# Application Load Balancer
#############################################

resource "aws_lb" "ares" {

  name               = "ares-alb"
  internal           = false
  load_balancer_type = "application"

  security_groups = [
    aws_security_group.alb.id
  ]

  subnets = [
    aws_subnet.public1.id,
    aws_subnet.public2.id
  ]

  tags = {
    Name = "ares-alb"
  }
}

#############################################
# Backend Target Group
#############################################

resource "aws_lb_target_group" "backend" {

  name = "ares-backend"

  port     = 8000
  protocol = "HTTP"

  vpc_id = aws_vpc.ares.id

  target_type = "ip"

  health_check {

    path = "/api"

    protocol = "HTTP"

    matcher = "200"

  }

}

#############################################
# Frontend Target Group
#############################################

resource "aws_lb_target_group" "frontend" {

  name = "ares-frontend"

  port     = 3000
  protocol = "HTTP"

  vpc_id = aws_vpc.ares.id

  target_type = "ip"

  health_check {

    path = "/"

    protocol = "HTTP"

    matcher = "200"

  }

}

#############################################
# Listener
#############################################

resource "aws_lb_listener" "http" {

  load_balancer_arn = aws_lb.ares.arn

  port = 80

  protocol = "HTTP"

  default_action {

    type = "forward"

    target_group_arn = aws_lb_target_group.frontend.arn

  }

}

#############################################
# Backend Listener Rule
#############################################

resource "aws_lb_listener_rule" "backend" {

  listener_arn = aws_lb_listener.http.arn

  priority = 100

  action {

    type = "forward"

    target_group_arn = aws_lb_target_group.backend.arn

  }

  condition {

    path_pattern {

      values = ["/api*"]

    }

  }

}