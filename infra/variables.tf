variable "ecr_repository_name" {
  description = "ECR repository name for application container images"
  type        = string
  default     = "eks-2048"
}

variable "github_repo" {
  description = "GitHub repository (owner/repo)"
  type        = string
  default     = "MOHASBI/AWS-EKS"
}

variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "eu-west-2"
}

variable "availability_zones" {
  description = "Availability zones"
  type        = list(string)
  default     = ["eu-west-2a", "eu-west-2b"]
}

variable "public_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  type    = list(any)
  default = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "cluster_name" {
  type    = string
  default = "eks-2048"
}

variable "cluster_version" {
  type    = string
  default = "1.31"
}

variable "common_tags" {
  description = "Tags applied to VPC and EKS resources"
  type        = map(string)
  default = {
    Project = "cloud-native-eks"
  }
}

variable "eks_cluster_authentication_mode" {
  description = "EKS access config: API or API_AND_CONFIG_MAP (see aws_eks_cluster.access_config)"
  type        = string
  default     = "API"
}

variable "eks_enable_irsa" {
  description = "Create IAM OIDC provider for the cluster (required for IRSA on service accounts)"
  type        = bool
  default     = true
}

variable "route53_hosted_zone_arns" {
  description = "Route53 hosted zone ARNs for cert-manager + external-dns IRSA; empty skips those modules"
  type        = list(string)
  default     = []
}

variable "external_dns_namespace" {
  type    = string
  default = "external-dns"
}

variable "external_dns_service_account" {
  type    = string
  default = "external-dns"
}

variable "cert_manager_namespace" {
  type    = string
  default = "cert-manager"
}

variable "cert_manager_service_account" {
  type    = string
  default = "cert-manager"
}

variable "eks_node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "eks_node_desired_size" {
  type    = number
  default = 2
}

variable "eks_node_min_size" {
  type    = number
  default = 1
}

variable "eks_node_max_size" {
  type    = number
  default = 4
}

variable "eks_node_disk_size" {
  type    = number
  default = 50
}