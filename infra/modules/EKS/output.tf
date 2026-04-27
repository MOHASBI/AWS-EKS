output "cluster_name" {
  value = aws_eks_cluster.main.name
}

output "cluster_arn" {
  value = aws_eks_cluster.main.arn
}

output "cluster_endpoint" {
  value = aws_eks_cluster.main.endpoint
}

output "cluster_ca_cert" {
  value = aws_eks_cluster.main.certificate_authority[0].data
}

output "cluster_version" {
  value = aws_eks_cluster.main.version
}

output "cluster_security_group_id" {
  value = aws_security_group.cluster.id
}

output "node_security_group_id" {
  value = aws_security_group.node.id
}

output "node_group_name" {
  value = aws_eks_node_group.main.node_group_name
}

output "cluster_iam_role_arn" {
  value = aws_iam_role.cluster.arn
}

output "node_iam_role_arn" {
  value = aws_iam_role.node.arn
}
