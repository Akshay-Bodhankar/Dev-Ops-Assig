output "frontend" {

  value = aws_instance.frontend.public_ip

}

output "backend" {

  value = aws_instance.backend.public_ip

}