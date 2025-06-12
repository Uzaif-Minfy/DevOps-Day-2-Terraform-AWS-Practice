variable "aws_region" {
  description = "The AWS region to create resources in."
  type        = string
  default     = "ap-south-1"
}

variable "s3_bucket_name" {
    description = "The Name of the S3 Bucket"
    type = string
    default = "minfy-training-uzaif-s3-2025"
}