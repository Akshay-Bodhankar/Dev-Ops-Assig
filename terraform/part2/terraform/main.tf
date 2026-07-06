##############################################
# VPC
##############################################

resource "aws_vpc" "ares" {

  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ares-vpc"
  }
}

##############################################
# Internet Gateway
##############################################

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.ares.id
}

##############################################
# Public Subnet
##############################################

resource "aws_subnet" "public" {

  vpc_id                  = aws_vpc.ares.id
  cidr_block              = "10.0.1.0/24"
  availability_zone       = "ap-south-1a"
  map_public_ip_on_launch = true

}

##############################################
# Route Table
##############################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.ares.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }

}

resource "aws_route_table_association" "public" {

  subnet_id      = aws_subnet.public.id
  route_table_id = aws_route_table.public.id

}

##############################################
# Backend Security Group
##############################################

resource "aws_security_group" "backend" {

  name   = "backend-sg"
  vpc_id = aws_vpc.ares.id

  ingress {

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port = 8000
    to_port   = 8000
    protocol  = "tcp"

    security_groups = [
      aws_security_group.frontend.id
    ]

  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}

##############################################
# Frontend Security Group
##############################################

resource "aws_security_group" "frontend" {

  name   = "frontend-sg"
  vpc_id = aws_vpc.ares.id

  ingress {

    from_port = 22
    to_port   = 22
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port = 3000
    to_port   = 3000
    protocol  = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0
    to_port   = 0
    protocol  = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}

##############################################
# Backend EC2
##############################################

resource "aws_instance" "backend" {

  ami           = var.ami
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  key_name = var.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.backend.id
  ]

  user_data = file("${path.module}/backend-userdata.sh")

  tags = {
    Name = "Backend"
  }

  connection {

    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.pem_file)
    timeout     = "5m"

  }

  provisioner "file" {

    source      = "../../ares-app/"
    destination = "/home/ubuntu/"

  }

  provisioner "remote-exec" {

    inline = [

      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 5; done",

      "cd /home/ubuntu/backend",

      "pip3 install --break-system-packages -r requirements.txt",

      "setsid python3 app.py > /home/ubuntu/backend/backend.log 2>&1 < /dev/null &",

      "sleep 5",

      "ps -ef | grep app.py || true"

    ]

  }

}

##############################################
# Frontend EC2
##############################################

resource "aws_instance" "frontend" {

  ami           = var.ami
  instance_type = var.instance_type

  subnet_id = aws_subnet.public.id

  key_name = var.key_name

  associate_public_ip_address = true

  vpc_security_group_ids = [
    aws_security_group.frontend.id
  ]

  user_data = templatefile("${path.module}/frontend-userdata.sh", {
    backend_ip = aws_instance.backend.private_ip
  })

  depends_on = [
    aws_instance.backend
  ]

  tags = {
    Name = "Frontend"
  }

  connection {

    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.pem_file)
    timeout     = "5m"

  }

  provisioner "file" {

    source      = "../../ares-app/"
    destination = "/home/ubuntu/"

  }

  provisioner "remote-exec" {

    inline = [

      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 5; done",

      "cd /home/ubuntu/frontend",

      "npm install",

      "export BACKEND_URL=http://${aws_instance.backend.private_ip}:8000/api",

      "pm2 start 'npm start' --name frontend"

    ]

  }

}
