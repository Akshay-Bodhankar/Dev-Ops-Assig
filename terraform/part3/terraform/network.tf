#########################################
# VPC
#########################################

resource "aws_vpc" "ares" {

  cidr_block           = "10.0.0.0/16"
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "ares-vpc"
  }

}

#########################################
# Internet Gateway
#########################################

resource "aws_internet_gateway" "igw" {

  vpc_id = aws_vpc.ares.id

  tags = {
    Name = "ares-igw"
  }

}

#########################################
# Public Subnet 1
#########################################

resource "aws_subnet" "public1" {

  vpc_id = aws_vpc.ares.id

  cidr_block = "10.0.1.0/24"

  availability_zone = "ap-south-1a"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-1"
  }

}

#########################################
# Public Subnet 2
#########################################

resource "aws_subnet" "public2" {

  vpc_id = aws_vpc.ares.id

  cidr_block = "10.0.2.0/24"

  availability_zone = "ap-south-1b"

  map_public_ip_on_launch = true

  tags = {
    Name = "public-subnet-2"
  }

}

#########################################
# Route Table
#########################################

resource "aws_route_table" "public" {

  vpc_id = aws_vpc.ares.id

  route {

    cidr_block = "0.0.0.0/0"

    gateway_id = aws_internet_gateway.igw.id

  }

}

#########################################
# Route Table Association
#########################################

resource "aws_route_table_association" "public1" {

  subnet_id = aws_subnet.public1.id

  route_table_id = aws_route_table.public.id

}

resource "aws_route_table_association" "public2" {

  subnet_id = aws_subnet.public2.id

  route_table_id = aws_route_table.public.id

}