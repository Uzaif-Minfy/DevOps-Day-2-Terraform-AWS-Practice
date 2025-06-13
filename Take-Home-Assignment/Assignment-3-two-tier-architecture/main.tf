terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region  = var.aws_region
  profile = var.profile
}

resource "aws_instance" "minfy_training_uzaif_web_server" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.minfy_training_uzaif_public_subnet.id
  vpc_security_group_ids = [aws_security_group.minfy_training_uzaif_web_sg.id]
  key_name               = var.key_name

  user_data = <<-EOF
              #!/bin/bash              
              yum update -y
              yum install -y httpd
              systemctl start httpd
              systemctl enable httpd
              echo "<h1>Hello World from Terraform!</h1>" > /var/www/html/index.html
              EOF

  tags = {
    Name = "minfy-training-uzaif-web-server"
  }
}

resource "aws_db_instance" "minfy_training_uzaif_database" {
  identifier             = "minfy-training-uzaif-database"
  allocated_storage      = 20
  max_allocated_storage  = 100
  storage_type           = "gp2"
  engine                 = "mysql"
  engine_version         = "8.0"
  instance_class         = "db.t3.micro"
  
  db_name  = var.db_name
  username = var.db_username
  password = var.db_password
  
  vpc_security_group_ids = [aws_security_group.minfy_training_uzaif_db_sg.id]
  db_subnet_group_name   = aws_db_subnet_group.minfy_training_uzaif_db_subnet_group.name
  
  skip_final_snapshot = true
  
  backup_retention_period = 7
  backup_window          = "03:00-04:00"
  maintenance_window     = "sun:04:00-sun:05:00"
  
  delete_automated_backups = true

  performance_insights_enabled = true

  tags = {
    Name = "minfy-training-uzaif-database"
  }
}
