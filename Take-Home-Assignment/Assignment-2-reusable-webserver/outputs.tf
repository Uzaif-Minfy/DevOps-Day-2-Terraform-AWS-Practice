output "ec2_instance_public_ip" {
  description = "Public IP of the EC2 instance created by the module."
  value       = module.minfy-training-uzaif-ec2-instance.public_ip
}
