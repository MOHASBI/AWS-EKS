provider "aws" {
  region = var.aws_region
}

module "vpc" {
  source = "./modules/vpc"

  region               = var.aws_region
  availability_zones   = var.availability_zones
  public_subnet_cidrs  = var.public_subnet_cidrs
  private_subnet_cidrs = var.private_subnet_cidrs
  cluster_name         = var.cluster_name
}

module "eks" {
  source = "./modules/EKS"

  cluster_name       = var.cluster_name
  cluster_version    = var.cluster_version
  vpc_id             = module.vpc.vpc_id
  vpc_cidr_block     = module.vpc.vpc_cidr
  private_subnet_ids = module.vpc.private_subnet_ids

  cluster_authentication_mode = var.eks_cluster_authentication_mode

  node_instance_types = var.eks_node_instance_types
  node_desired_size   = var.eks_node_desired_size
  node_min_size       = var.eks_node_min_size
  node_max_size       = var.eks_node_max_size
  node_disk_size      = var.eks_node_disk_size

  enable_irsa = var.eks_enable_irsa

  tags = var.common_tags
}
