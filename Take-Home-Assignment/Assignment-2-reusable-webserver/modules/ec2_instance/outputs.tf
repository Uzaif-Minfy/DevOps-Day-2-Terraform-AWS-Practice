output "id" {
    value = aws_instance.ec2_web_server.id
}

output "public_ip" {
    value = aws_instance.ec2_web_server.public_ip  
}