resource "aws_vpc" "minfy_training_uzaif_vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_hostnames = true
  enable_dns_support   = true
  
  tags = {
    Name = "minfy-training-uzaif-vpc"
  }
}


resource "aws_internet_gateway" "minfy_training_uzaif_igw" {
  vpc_id = aws_vpc.minfy_training_uzaif_vpc.id
  
  tags = {
    Name = "minfy-training-uzaif-igw"
  }
}


resource "aws_subnet" "minfy_training_uzaif_public_subnet" {
  vpc_id                  = aws_vpc.minfy_training_uzaif_vpc.id
  cidr_block              = var.public_subnet_cidr
  availability_zone       = var.availability_zone_1
  map_public_ip_on_launch = true
  
  tags = {
    Name = "minfy-training-uzaif-public-subnet"
  }
}


resource "aws_subnet" "minfy_training_uzaif_private_subnet" {
  vpc_id            = aws_vpc.minfy_training_uzaif_vpc.id
  cidr_block        = var.private_subnet_cidr
  availability_zone = var.availability_zone_2
  
  tags = {
    Name = "minfy-training-uzaif-private-subnet"
  }
}


resource "aws_subnet" "minfy_training_uzaif_private_subnet_2" {
  vpc_id            = aws_vpc.minfy_training_uzaif_vpc.id
  cidr_block        = var.private_subnet_2_cidr
  availability_zone = var.availability_zone_3
  
  tags = {
    Name = "minfy-training-uzaif-private-subnet-2"
  }
}


resource "aws_eip" "minfy_training_uzaif_nat_eip" {
  domain = "vpc"
  
  tags = {
    Name = "minfy-training-uzaif-nat-eip"
  }
  
  depends_on = [aws_internet_gateway.minfy_training_uzaif_igw]
}


resource "aws_nat_gateway" "minfy_training_uzaif_nat_gw" {
  allocation_id = aws_eip.minfy_training_uzaif_nat_eip.id
  subnet_id     = aws_subnet.minfy_training_uzaif_public_subnet.id
  
  tags = {
    Name = "minfy-training-uzaif-nat-gw"
  }
  
  depends_on = [aws_internet_gateway.minfy_training_uzaif_igw]
}


resource "aws_route_table" "minfy_training_uzaif_public_rt" {
  vpc_id = aws_vpc.minfy_training_uzaif_vpc.id
  
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.minfy_training_uzaif_igw.id
  }
  
  tags = {
    Name = "minfy-training-uzaif-public-rt"
  }
}


resource "aws_route_table" "minfy_training_uzaif_private_rt" {
  vpc_id = aws_vpc.minfy_training_uzaif_vpc.id
  
  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.minfy_training_uzaif_nat_gw.id
  }
  
  tags = {
    Name = "minfy-training-uzaif-private-rt"
  }
}


resource "aws_route_table_association" "minfy_training_uzaif_public_rta" {
  subnet_id      = aws_subnet.minfy_training_uzaif_public_subnet.id
  route_table_id = aws_route_table.minfy_training_uzaif_public_rt.id
}


resource "aws_route_table_association" "minfy_training_uzaif_private_rta" {
  subnet_id      = aws_subnet.minfy_training_uzaif_private_subnet.id
  route_table_id = aws_route_table.minfy_training_uzaif_private_rt.id
}


resource "aws_route_table_association" "minfy_training_uzaif_private_rta_2" {
  subnet_id      = aws_subnet.minfy_training_uzaif_private_subnet_2.id
  route_table_id = aws_route_table.minfy_training_uzaif_private_rt.id
}


resource "aws_db_subnet_group" "minfy_training_uzaif_db_subnet_group" {
  name       = "minfy-training-uzaif-db-subnet-group"
  subnet_ids = [
    aws_subnet.minfy_training_uzaif_private_subnet.id,
    aws_subnet.minfy_training_uzaif_private_subnet_2.id
  ]
  
  tags = {
    Name = "minfy-training-uzaif-db-subnet-group"
  }
}