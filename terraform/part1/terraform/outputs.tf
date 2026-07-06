output "public_ip" {
  value = aws_instance.ares.public_ip
}

output "frontend" {
  value = "http://${aws_instance.ares.public_ip}:3000"
}

output "backend" {
  value = "http://${aws_instance.ares.public_ip}:8000/api"
}