variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "ap-south-1"
}

variable "vpc_name" {
    description = "The Name of the VPC"
    type = string
    default = "minfy-training-uzaif-vpc"
}

variable "vpc_cidr" {
  description = "The CIDR block for the VPC."
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "The EC2 instance type."
  type        = string
  default     = "t2.micro"
}

variable "profile"{
    description = "Profile Name"
    type = string
    default = "Uzaif"
}
