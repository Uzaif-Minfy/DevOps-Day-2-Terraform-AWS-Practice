terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 5.0"
    }
  }
}

provider "aws" {
    region = var.aws_region
    profile = "Uzaif"
}

resource "aws_s3_bucket" "uzaif_assignment_1_s3_bucket" {
    bucket = var.s3_bucket_name
}

resource "aws_s3_bucket_public_access_block" "bucket_public_access" {
    bucket = aws_s3_bucket.uzaif_assignment_1_s3_bucket.id
    block_public_acls = false
    block_public_policy = false
    ignore_public_acls = false
    restrict_public_buckets = false
}

resource "aws_s3_bucket_website_configuration" "bucket_website_configurataion" {
    bucket = aws_s3_bucket.uzaif_assignment_1_s3_bucket.id
    index_document {
      suffix = "index.html"
    }
}

data "aws_iam_policy_document" "bucket_public_read_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${aws_s3_bucket.uzaif_assignment_1_s3_bucket.arn}/*"]
    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

resource "aws_s3_bucket_policy" "bucket_policy" {
    bucket = aws_s3_bucket.uzaif_assignment_1_s3_bucket.id
    policy = data.aws_iam_policy_document.bucket_public_read_policy.json
  
}


resource "aws_s3_object" "index_html" {
  bucket       = aws_s3_bucket.uzaif_assignment_1_s3_bucket.id
  key          = "index.html"
  source       = "${path.module}/index.html"
  content_type = "text/html"
}