locals {
  irsa_dns_roles_enabled = var.eks_enable_irsa && length(var.route53_hosted_zone_arns) > 0
}

module "cert_manager_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "= 5.34.0"

  count = local.irsa_dns_roles_enabled ? 1 : 0

  role_name                     = "cert-manager"
  attach_cert_manager_policy    = true
  cert_manager_hosted_zone_arns = var.route53_hosted_zone_arns

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${var.cert_manager_namespace}:${var.cert_manager_service_account}"]
    }
  }

  tags = var.common_tags
}

module "external_dns_irsa_role" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "= 5.34.0"

  count = local.irsa_dns_roles_enabled ? 1 : 0

  role_name                     = "external-dns"
  attach_external_dns_policy    = true
  external_dns_hosted_zone_arns = var.route53_hosted_zone_arns

  oidc_providers = {
    eks = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["${var.external_dns_namespace}:${var.external_dns_service_account}"]
    }
  }

  tags = var.common_tags
}
