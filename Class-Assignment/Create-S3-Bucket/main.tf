terraform {
    required_providers {
        aws = {
            source = "hashicorp/aws"
            version = "~> 5.0"
        }
    }
}

provider aws {
    region = "ap-south-1"
    profile = "Uzaif"
}

resource "aws_s3_bucket" "class_assignmnet_s3" {
    bucket = "minfy-training-uzaif-s3-2025"  
}