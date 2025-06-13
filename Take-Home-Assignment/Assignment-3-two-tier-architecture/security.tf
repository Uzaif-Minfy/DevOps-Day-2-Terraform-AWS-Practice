# Web Server Security Group
resource "aws_security_group" "minfy_training_uzaif_web_sg" {
  name        = "minfy-training-uzaif-web-sg"
  description = "allow HTTP and SSH from inbound traffic"
  vpc_id      = aws_vpc.minfy_training_uzaif_vpc.id

  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minfy-training-uzaif-web-sg"
  }
}


resource "aws_security_group" "minfy_training_uzaif_db_sg" {
  name        = "minfy-training-uzaif-db-sg"
  description = "allow access only from web servers"
  vpc_id      = aws_vpc.minfy_training_uzaif_vpc.id

  
  ingress {
    description     = "MySQL/MariaDB"
    from_port       = 3306
    to_port         = 3306
    protocol        = "tcp"
    security_groups = [aws_security_group.minfy_training_uzaif_web_sg.id]
  }


  egress {
    description = "All outbound traffic"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "minfy-training-uzaif-db-sg"
  }
}