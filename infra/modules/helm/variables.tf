variable "nginx_ingress_values" {
  type        = string
  description = "YAML values for ingress-nginx"
}

variable "cert_manager_values" {
  type        = string
  description = "YAML values for cert-manager"
}

variable "external_dns_values" {
  type        = string
  description = "YAML values for external-dns"
}

variable "argocd_values" {
  type        = string
  description = "YAML values for Argo CD"
}

variable "monitoring_values" {
  type        = string
  description = "YAML values for kube-prometheus-stack"
}

variable "install_argocd" {
  type    = bool
  default = true
}

variable "install_monitoring" {
  type    = bool
  default = true
}

variable "nginx_ingress_chart_version" {
  type    = string
  default = null
}

variable "cert_manager_chart_version" {
  type    = string
  default = null
}

variable "external_dns_chart_version" {
  type    = string
  default = null
}

variable "argocd_chart_version" {
  type    = string
  default = null
}

variable "monitoring_chart_version" {
  type    = string
  default = null
}
