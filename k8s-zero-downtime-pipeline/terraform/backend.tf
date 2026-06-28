terraform {
  backend "s3" {
    bucket         = "new1-2134-90-freelancing"
    key            = "eks/terraform.tfstate"
    region         = "ap-south-1"
    dynamodb_table = "terraform-locks"
  }
}