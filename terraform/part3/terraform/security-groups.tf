#############################################
# ALB Security Group
#############################################

resource "aws_security_group" "alb" {

  name        = "ares-alb-sg"
  description = "ALB Security Group"
  vpc_id      = aws_vpc.ares.id

  ingress {

    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "ares-alb-sg"
  }

}

#############################################
# Frontend ECS Security Group
#############################################

resource "aws_security_group" "frontend" {

  name        = "ares-frontend-sg"
  description = "Frontend ECS Security Group"
  vpc_id      = aws_vpc.ares.id

  ingress {

    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"

    security_groups = [
      aws_security_group.alb.id
    ]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

  tags = {
    Name = "ares-frontend-sg"
  }

}

#############################################
# Backend ECS Security Group
#############################################
resource "aws_security_group" "backend" {

  name        = "ares-backend-sg"
  description = "Backend ECS Security Group"
  vpc_id      = aws_vpc.ares.id

  ingress {

    from_port   = 8000
    to_port     = 8000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
    # security_groups = [
    #   aws_security_group.alb.id
    # ]

  }

  egress {

    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]

  }

}
