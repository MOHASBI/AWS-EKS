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