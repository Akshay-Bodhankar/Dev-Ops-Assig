variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ami" {
  default = "ami-01a00762f46d584a1"
}

variable "key_name" {
  description = "Existing EC2 Key Pair"
}

variable "pem_file" {
  description = "Path of PEM file"
}