terraform {
  backend "s3" {
    bucket         = var.s3_bucket_name
    key            = "eks/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}