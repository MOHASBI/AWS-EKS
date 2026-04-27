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

module "helm" {
  source = "./modules/helm"

  nginx_ingress_values = file("${path.module}/../helm/nginx-ingress/values.yaml")
  cert_manager_values  = file("${path.module}/../helm/cert-manager/values.yaml")
  external_dns_values  = file("${path.module}/../helm/external-dns/values.yaml")
  argocd_values        = file("${path.module}/../helm/argocd/values.yaml")
  monitoring_values    = file("${path.module}/../helm/monitoring/values.yaml")

  depends_on = [
    module.eks,
    module.cert_manager_irsa_role,
    module.external_dns_irsa_role,
  ]
}
