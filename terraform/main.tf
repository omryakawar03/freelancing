provider "aws" {
  region = "ap-south-1"
}

data "aws_vpc" "default" {
  default = true
}

module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"
  cluster_name    = "zero-downtime-cluster"
  vpc_id     = data.aws_vpc.default.id
 
  eks_managed_node_groups = {
    default = {
      min_size       = 1
      max_size       = 2
      desired_size   = 1
      instance_types = ["c7i-flex.large"]
    }
  }
}