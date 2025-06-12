terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider aws {
    region = var.aws_region
    profile = var.profile
}

resource "aws_vpc" "uzaif_vpc" {
  cidr_block = var.vpc_cidr
  tags = {
    Name = var.vpc_name
  }
}

resource "aws_internet_gateway" "ig" {
  vpc_id = aws_vpc.uzaif_vpc.id 
  tags = {
    Name = "minfy-training-uzaif-ig"
  }
}

resource "aws_subnet" "public_subnet" {
  vpc_id                  = aws_vpc.uzaif_vpc.id
  cidr_block              = "10.0.1.0/24"
  map_public_ip_on_launch = true # Instances in this subnet get a public IP
  availability_zone       = "ap-south-1a"
  tags = {
    Name = "minfy-training-uzaif-public-subnet"
  }
}

resource "aws_route_table" "public_rt" {
  vpc_id = aws_vpc.uzaif_vpc.id
  route {
    cidr_block = "0.0.0.0/0" 
    gateway_id = aws_internet_gateway.ig.id
  }
  tags = {
    Name = "minfy-training-uzaif-public-rt"
  }
}

resource "aws_route_table_association" "associate_rt" {
  subnet_id      = aws_subnet.public_subnet.id
  route_table_id = aws_route_table.public_rt.id
}


resource "aws_security_group" "sg" {
  name        = "minfy-training-uzaif-sg"
  description = "Allow HTTP and SSH inbound traffic"
  vpc_id      = aws_vpc.uzaif_vpc.id

  # inbound 
  # HTTP traffic from anywhere
  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # SSH traffic from anywhere 
  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  # outbound 
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_instance" "ec2_web_server" {
  ami           = "ami-0b09627181c8d5778"
  instance_type = var.instance_type
  subnet_id = aws_subnet.public_subnet.id
  vpc_security_group_ids = [aws_security_group.sg.id]
  key_name               = "minfy-training-uzaif-key-pair"

  user_data = <<-EOF
              #!/bin/bash              
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from Terraform!</h1>" > /var/www/html/index.html
              EOF  
  tags = {
    Name = "minfy-training-uzaif-ec2-instance"
  }
}

