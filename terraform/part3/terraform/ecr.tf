##############################################
# Backend ECR Repository
##############################################

resource "aws_ecr_repository" "backend" {

  name         = "ares-backend"
  force_delete = true

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

##############################################
# Frontend ECR Repository
##############################################

resource "aws_ecr_repository" "frontend" {

  name         = "ares-frontend"
  force_delete = true

  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}