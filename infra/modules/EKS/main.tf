terraform {
  required_version = ">= 1.6.0, < 2.0.0"

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 6.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "~> 4.0"
    }
  }
}

resource "aws_eks_cluster" "main" {
  name     = var.cluster_name
  version  = var.cluster_version
  role_arn = aws_iam_role.cluster.arn

  access_config {
    authentication_mode                         = var.cluster_authentication_mode
    bootstrap_cluster_creator_admin_permissions = true
  }

  vpc_config {
    subnet_ids              = var.private_subnet_ids
    endpoint_private_access = true
    endpoint_public_access  = true
    security_group_ids      = [aws_security_group.cluster.id]
  }

  depends_on = [
    aws_iam_role_policy_attachment.cluster_AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.cluster_AmazonEKSVPCResourceController,
  ]

  tags = var.tags
}

resource "aws_iam_role" "cluster" {
  name = "${var.cluster_name}-cluster-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "eks.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSClusterPolicy" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSClusterPolicy"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role_policy_attachment" "cluster_AmazonEKSVPCResourceController" {
  policy_arn = "arn:aws:iam::aws:policy/AmazonEKSVPCResourceController"
  role       = aws_iam_role.cluster.name
}

resource "aws_iam_role" "node" {
  name = "${var.cluster_name}-node-role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = { Service = "ec2.amazonaws.com" }
      Action    = "sts:AssumeRole"
    }]
  })

  tags = var.tags
}

resource "aws_iam_role_policy_attachment" "node_policies" {
  for_each = toset([
    "arn:aws:iam::aws:policy/AmazonEKSWorkerNodePolicy",
    "arn:aws:iam::aws:policy/AmazonEKS_CNI_Policy",
    "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly",
  ])

  policy_arn = each.value
  role       = aws_iam_role.node.name
}

resource "aws_security_group" "cluster" {
  name        = "${var.cluster_name}-cluster-sg"
  description = "EKS control plane to node communication"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group" "node" {
  name        = "${var.cluster_name}-node-sg"
  description = "EKS worker nodes"
  vpc_id      = var.vpc_id

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


}

resource "aws_security_group_rule" "cluster_to_node_443" {
  type                     = "ingress"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.cluster.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  description              = "Cluster API to nodes"
}

resource "aws_security_group_rule" "cluster_to_node_kubelet" {
  type                     = "ingress"
  security_group_id        = aws_security_group.node.id
  source_security_group_id = aws_security_group.cluster.id
  from_port                = 10250
  to_port                  = 10250
  protocol                 = "tcp"
  description              = "Cluster to kubelet"
}

resource "aws_security_group_rule" "node_to_node_all" {
  type              = "ingress"
  security_group_id = aws_security_group.node.id
  self              = true
  from_port         = 0
  to_port           = 65535
  protocol          = "tcp"
  description       = "Node to node (pod traffic paths)"
}

resource "aws_security_group_rule" "node_from_vpc_web" {
  type              = "ingress"
  security_group_id = aws_security_group.node.id
  cidr_blocks       = [var.vpc_cidr_block]
  from_port         = 80
  to_port           = 443
  protocol          = "tcp"
  description       = "HTTP(S) from VPC (ingress / internal ALB paths)"
}

resource "aws_security_group_rule" "node_from_vpc_nodeports" {
  type              = "ingress"
  security_group_id = aws_security_group.node.id
  cidr_blocks       = [var.vpc_cidr_block]
  from_port         = 30000
  to_port           = 32767
  protocol          = "tcp"
  description       = "NodePort range from VPC (NLB/legacy patterns)"
}

resource "aws_security_group_rule" "node_to_cluster_443" {
  type                     = "ingress"
  security_group_id        = aws_security_group.cluster.id
  source_security_group_id = aws_security_group.node.id
  from_port                = 443
  to_port                  = 443
  protocol                 = "tcp"
  description              = "Nodes to cluster API"
}


resource "aws_eks_node_group" "main" {
  cluster_name    = aws_eks_cluster.main.name
  node_group_name = "${var.cluster_name}-nodes"
  node_role_arn   = aws_iam_role.node.arn
  subnet_ids      = var.private_subnet_ids

  capacity_type  = var.node_capacity_type
  ami_type       = var.node_ami_type
  instance_types = var.node_instance_types

  scaling_config {
    desired_size = var.node_desired_size
    max_size     = var.node_max_size
    min_size     = var.node_min_size
  }

  update_config {
    max_unavailable_percentage = 1
  }

  depends_on = [
    aws_iam_role_policy_attachment.node_policies,
  ]

  tags = var.tags
}

data "tls_certificate" "eks_oidc" {
  count = var.enable_irsa ? 1 : 0
  url   = aws_eks_cluster.main.identity[0].oidc[0].issuer
}

resource "aws_iam_openid_connect_provider" "eks" {
  count = var.enable_irsa ? 1 : 0

  client_id_list  = ["sts.amazonaws.com"]
  thumbprint_list = [data.tls_certificate.eks_oidc[0].certificates[0].sha1_fingerprint]
  url             = aws_eks_cluster.main.identity[0].oidc[0].issuer

  tags = merge(var.tags, { Name = "${var.cluster_name}-eks-irsa" })
}

