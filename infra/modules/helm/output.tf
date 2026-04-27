output "nginx_ingress_status" {
  value = helm_release.nginx_ingress.status
}

output "cert_manager_status" {
  value = helm_release.cert_manager.status
}

output "external_dns_status" {
  value = helm_release.external_dns.status
}

output "argocd_status" {
  value = try(helm_release.argocd[0].status, null)
}

output "monitoring_status" {
  value = try(helm_release.monitoring[0].status, null)
}
