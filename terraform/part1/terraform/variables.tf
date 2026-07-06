variable "region" {
  description = "AWS Region"
  type        = string
  default     = "ap-south-1"
}

variable "instance_type" {
  description = "EC2 Instance Type"
  type        = string
  default     = "t3.micro"
}

variable "ami" {
  description = "Ubuntu AMI"
  type        = string
  default     = "ami-01a00762f46d584a1"
}

variable "key_name" {
  description = "Existing AWS Key Pair Name"
  type        = string
}

variable "pem_file" {
  description = "Path to PEM file"
  type        = string
}