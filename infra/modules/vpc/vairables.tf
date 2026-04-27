variable "region" {
  type = string
}

variable "public_subnet_cidrs" {
  type = list(any)
}

variable "private_subnet_cidrs" {
  type = list(any)
}

variable "availability_zones" {
  type = list(any)
}

variable "cluster_name" {
  description = "If set, tag subnets for EKS load balancers and cluster ownership"
  type        = string
  default     = ""
}