resource "aws_security_group" "ares" {

  name = "ares-sg"

  ingress {

    from_port = 22
    to_port   = 22

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port = 3000
    to_port   = 3000

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  ingress {

    from_port = 8000
    to_port   = 8000

    protocol = "tcp"

    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {

    from_port = 0
    to_port   = 0

    protocol = "-1"

    cidr_blocks = ["0.0.0.0/0"]

  }

}

resource "aws_instance" "ares" {

  ami = var.ami

  instance_type = var.instance_type

  key_name = var.key_name

  vpc_security_group_ids = [
    aws_security_group.ares.id
  ]

  user_data = file("${path.module}/userdata.sh")

  tags = {

    Name = "Terraform-Ares"

  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    host        = self.public_ip
    private_key = file(var.pem_file)
    timeout     = "5m"
  }

  provisioner "file" {
    source      = "../ares-app/"
    destination = "/home/ubuntu/"
  }


  provisioner "remote-exec" {

    inline = [

      "while [ ! -f /var/lib/cloud/instance/boot-finished ]; do sleep 5; done",

      "cd /home/ubuntu/backend",

      "python3 -m venv venv",

      "bash -c 'source venv/bin/activate && pip install -r requirements.txt'",

      "bash -c 'source venv/bin/activate && nohup python app.py > backend.log 2>&1 &'",

      "cd /home/ubuntu/frontend",

      "npm install",

      "export BACKEND_URL=http://localhost:8000/api",

      "pm2 start 'npm start' --name frontend"

    ]
  }

}
