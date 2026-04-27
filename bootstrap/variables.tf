variable "ecr_repository_name" {
  type        = string
  default     = "eks-2048"
}

variable "github_repo" {
  description = "GitHub repository (owner/repo)"
  type        = string
  default     = "MOHASBI/AWS-EKS"
}