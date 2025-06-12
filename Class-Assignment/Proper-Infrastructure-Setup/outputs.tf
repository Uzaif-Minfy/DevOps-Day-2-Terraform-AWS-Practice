output "instance_public_ip" {
  description = "The public IP address of our EC2 instance."
  value       = aws_instance.ec2_web_server.public_ip
}

output "instance_private_ip" {
  description = "The private IP address of our EC2 instance."
  value       = aws_instance.ec2_web_server.private_ip
}
