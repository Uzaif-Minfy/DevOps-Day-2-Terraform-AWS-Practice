# Web Server 
output "web_server_public_ip" {
  description = "Public IP address of the web server"
  value       = aws_instance.minfy_training_uzaif_web_server.public_ip
}

output "web_server_public_dns" {
  description = "Public DNS name of the web server"
  value       = aws_instance.minfy_training_uzaif_web_server.public_dns
}

output "web_server_private_ip" {
  description = "Private IP address of the web server"
  value       = aws_instance.minfy_training_uzaif_web_server.private_ip
}






# Database 
output "database_endpoint" {
  description = "RDS database endpoint"
  value       = aws_db_instance.minfy_training_uzaif_database.address
}

output "database_port" {
  description = "RDS database port"
  value       = aws_db_instance.minfy_training_uzaif_database.port
}

output "database_name" {
  description = "Database name"
  value       = aws_db_instance.minfy_training_uzaif_database.db_name
}

# Network Outputs
output "vpc_id" {
  description = "VPC id"
  value       = aws_vpc.minfy_training_uzaif_vpc.id
}

output "public_subnet_id" {
  description = "public subnet id"
  value       = aws_subnet.minfy_training_uzaif_public_subnet.id
}

output "private_subnet_id" {
  description = "private subnet id"
  value       = aws_subnet.minfy_training_uzaif_private_subnet.id
}







# Security Group 
output "web_security_group_id" {
  description = "web server security group id"
  value       = aws_security_group.minfy_training_uzaif_web_sg.id
}

output "database_security_group_id" {
  description = "database security group id"
  value       = aws_security_group.minfy_training_uzaif_db_sg.id
}











output "web_server_url" {
  description = "URL to access the web server"
  value       = "http://${aws_instance.minfy_training_uzaif_web_server.public_ip}"
}

output "ssh_connection" {
  description = "SSH command to connect to web server"
  value       = "ssh -i ${var.key_name}.pem ec2-user@${aws_instance.minfy_training_uzaif_web_server.public_ip}"
}

output "database_connection_from_web_server" {
  description = "MySQL connection command from web server"
  value       = "mysql -h ${aws_db_instance.minfy_training_uzaif_database.address} -u ${var.db_username} -p ${aws_db_instance.minfy_training_uzaif_database.db_name}"
  sensitive   = false
}