variable "cluster_name" {
  description = "EKS cluster name (used for IAM, SGs, and subnet tags in the VPC module)"
  type        = string
}

variable "cluster_version" {
  description = "Kubernetes version (e.g. 1.31)"
  type        = string
  default     = "1.31"
}

variable "vpc_id" {
  description = "VPC ID for the cluster and nodes"
  type        = string
}

variable "vpc_cidr_block" {
  description = "VPC CIDR for node SG rules (HTTP/HTTPS and NodePort range from inside the VPC)"
  type        = string
}

variable "private_subnet_ids" {
  description = "Private subnets for the control plane and managed node group"
  type        = list(string)
}

variable "public_access_cidrs" {
  description = "CIDRs allowed to reach the public Kubernetes API endpoint"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "cluster_authentication_mode" {
  type    = string
  default = "API"
}

variable "node_instance_types" {
  type    = list(string)
  default = ["t3.medium"]
}

variable "node_capacity_type" {
  type    = string
  default = "ON_DEMAND"
}

variable "node_ami_type" {
  description = "EKS AL2023 x86_64 for modern Kubernetes versions"
  type        = string
  default     = "AL2023_x86_64_STANDARD"
}

variable "node_desired_size" {
  type    = number
  default = 2
}

variable "node_min_size" {
  type    = number
  default = 1
}

variable "node_max_size" {
  type    = number
  default = 2
}

variable "node_disk_size" {
  description = "Root volume size (GiB) for worker nodes"
  type        = number
  default     = 50
}

variable "node_ssh_key_name" {
  description = "EC2 key pair name for SSM-less SSH (leave empty to disable remote_access)"
  type        = string
  default     = ""
}

variable "node_remote_access_security_group_ids" {
  description = "Security groups allowed to SSH to nodes when node_ssh_key_name is set"
  type        = list(string)
  default     = []

  validation {
    condition = (
      var.node_ssh_key_name == "" ||
      length(var.node_remote_access_security_group_ids) > 0
    )
    error_message = "When node_ssh_key_name is set, node_remote_access_security_group_ids must include at least one security group."
  }
}

variable "enable_irsa" {
  description = "Create IAM OIDC provider for service account IAM roles (ExternalDNS, cert-manager, etc.)"
  type        = bool
  default     = true
}

variable "tags" {
  description = "Tags applied to supported resources"
  type        = map(string)
  default     = {}
}
