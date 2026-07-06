#############################################
# ECS Cluster
#############################################

resource "aws_ecs_cluster" "ares" {

  name = "ares-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "ares-cluster"
  }
}

#############################################
# CloudWatch Log Group - Backend
#############################################

resource "aws_cloudwatch_log_group" "backend" {

  name              = "/ecs/ares-backend"
  retention_in_days = 7

  tags = {
    Name = "ares-backend-logs"
  }
}

#############################################
# CloudWatch Log Group - Frontend
#############################################

resource "aws_cloudwatch_log_group" "frontend" {

  name              = "/ecs/ares-frontend"
  retention_in_days = 7

  tags = {
    Name = "ares-frontend-logs"
  }
}


#############################################
# Backend Task Definition
#############################################

resource "aws_ecs_task_definition" "backend" {

  family                   = "ares-backend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "ares-backend"
      image     = "${aws_ecr_repository.backend.repository_url}:latest"
      essential = true

      portMappings = [
        {
          containerPort = 8000
          hostPort      = 8000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.backend.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

}


#############################################
# Frontend Task Definition
#############################################

resource "aws_ecs_task_definition" "frontend" {

  family                   = "ares-frontend"
  network_mode             = "awsvpc"
  requires_compatibilities = ["FARGATE"]

  cpu    = "256"
  memory = "512"

  execution_role_arn = aws_iam_role.ecs_task_execution_role.arn

  container_definitions = jsonencode([
    {
      name      = "ares-frontend"
      image     = "${aws_ecr_repository.frontend.repository_url}:latest"
      essential = true

      environment = [
        {
          name  = "BACKEND_URL"
          value = "http://${aws_lb.ares.dns_name}/api"
        }
      ]

      portMappings = [
        {
          containerPort = 3000
          hostPort      = 3000
          protocol      = "tcp"
        }
      ]

      logConfiguration = {
        logDriver = "awslogs"

        options = {
          awslogs-group         = aws_cloudwatch_log_group.frontend.name
          awslogs-region        = var.region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])

}


#############################################
# Backend ECS Service
#############################################

resource "aws_ecs_service" "backend" {

  name            = "ares-backend-service"
  cluster         = aws_ecs_cluster.ares.id
  task_definition = aws_ecs_task_definition.backend.arn

  desired_count = 1

  launch_type = "FARGATE"

  network_configuration {

    subnets = [
      aws_subnet.public1.id,
      aws_subnet.public2.id
    ]

    security_groups = [
      aws_security_group.backend.id
    ]

    assign_public_ip = true

  }

  load_balancer {

    target_group_arn = aws_lb_target_group.backend.arn

    container_name = "ares-backend"

    container_port = 8000

  }

  depends_on = [
    aws_lb_listener.http,
    aws_lb_listener_rule.backend
  ]

}


#############################################
# Frontend ECS Service
#############################################

resource "aws_ecs_service" "frontend" {

  name            = "ares-frontend-service"
  cluster         = aws_ecs_cluster.ares.id
  task_definition = aws_ecs_task_definition.frontend.arn

  desired_count = 1

  launch_type = "FARGATE"

  network_configuration {

    subnets = [
      aws_subnet.public1.id,
      aws_subnet.public2.id
    ]

    security_groups = [
      aws_security_group.frontend.id
    ]

    assign_public_ip = true

  }

  load_balancer {

    target_group_arn = aws_lb_target_group.frontend.arn

    container_name = "ares-frontend"

    container_port = 3000

  }

  depends_on = [
    aws_lb_listener.http
  ]

}

