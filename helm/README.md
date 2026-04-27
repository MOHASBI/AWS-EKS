# Helm Install Order

Helm releases are managed by Terraform through `infra/modules/helm`.

## 1. Configure kubeconfig

```bash
aws eks update-kubeconfig --region eu-west-2 --name eks-2048
kubectl get nodes
```

## 2. Install the platform charts with Terraform

```bash
terraform -chdir=infra init -upgrade
terraform -chdir=infra apply
```

Terraform installs:

- NGINX Ingress Controller
- cert-manager
- ExternalDNS
- Argo CD
- kube-prometheus-stack

The chart values live in:

- `helm/nginx-ingress/values.yaml`
- `helm/cert-manager/values.yaml`
- `helm/external-dns/values.yaml`
- `helm/argocd/values.yaml`
- `helm/monitoring/values.yaml`

## 3. Apply the cert-manager ClusterIssuer

Terraform installs cert-manager itself, but the `ClusterIssuer` is still a Kubernetes manifest:

```bash
kubectl apply -f k8s/cert-manager/cluster-issuer.yaml
```

## 4. Deploy the app

```bash
kubectl apply -f k8s/app/
```

