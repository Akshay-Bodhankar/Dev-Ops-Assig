output "backend_repository_url" {

  value = aws_ecr_repository.backend.repository_url

}

output "frontend_repository_url" {

  value = aws_ecr_repository.frontend.repository_url

}

#############################################
# ALB DNS
#############################################

output "alb_dns_name" {

  value = aws_lb.ares.dns_name

}

#############################################
# ECS Cluster
#############################################

output "ecs_cluster" {

  value = aws_ecs_cluster.ares.name

}

#############################################
# Backend ECR
#############################################

output "backend_repository" {

  value = aws_ecr_repository.backend.repository_url

}

#############################################
# Frontend ECR
#############################################

output "frontend_repository" {

  value = aws_ecr_repository.frontend.repository_url

}