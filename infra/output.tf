output "vpc_id" {
  value = module.vpc.vpc_id
}

output "vpc_cidr" {
  value = module.vpc.vpc_cidr
}

output "public_subnet_ids" {
  value = module.vpc.public_subnet_ids
}

output "private_subnet_ids" {
  value = module.vpc.private_subnet_ids
}

output "eks_cluster_name" {
  value = module.eks.cluster_name
}

output "eks_cluster_endpoint" {
  value = module.eks.cluster_endpoint
}

output "eks_cluster_ca_certificate" {
  value     = module.eks.cluster_ca_cert
  sensitive = true
}

output "eks_cluster_security_group_id" {
  value = module.eks.cluster_security_group_id
}

output "eks_node_security_group_id" {
  value = module.eks.node_security_group_id
}

output "eks_oidc_issuer_url" {
  value = module.eks.oidc_issuer_url
}

output "eks_oidc_provider_arn" {
  value = module.eks.oidc_provider_arn
}

output "irsa_cert_manager_role_arn" {
  description = "cert-manager ServiceAccount: eks.amazonaws.com/role-arn"
  value       = try(module.cert_manager_irsa_role[0].iam_role_arn, null)
}

output "irsa_external_dns_role_arn" {
  description = "external-dns ServiceAccount: eks.amazonaws.com/role-arn"
  value       = try(module.external_dns_irsa_role[0].iam_role_arn, null)
}

output "helm_nginx_ingress_status" {
  value = module.helm.nginx_ingress_status
}

output "helm_cert_manager_status" {
  value = module.helm.cert_manager_status
}

output "helm_external_dns_status" {
  value = module.helm.external_dns_status
}

output "helm_argocd_status" {
  value = module.helm.argocd_status
}

output "helm_monitoring_status" {
  value = module.helm.monitoring_status
}
