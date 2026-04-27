# Helm Install Order

Run these after Terraform has applied and `kubectl` can reach the cluster.

## 1. Configure kubeconfig

```bash
aws eks update-kubeconfig --region eu-west-2 --name eks-2048
kubectl get nodes
```

## 2. Install NGINX Ingress

```bash
helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
helm repo update
helm upgrade --install ingress-nginx ingress-nginx/ingress-nginx \
  --namespace ingress-nginx \
  --create-namespace \
  --values helm/nginx-ingress/values.yaml
```

## 3. Install cert-manager

Replace the role ARN placeholder in `helm/cert-manager/values.yaml` with:

```bash
terraform -chdir=infra output -raw irsa_cert_manager_role_arn
```

Then install:

```bash
helm repo add jetstack https://charts.jetstack.io
helm repo update
helm upgrade --install cert-manager jetstack/cert-manager \
  --namespace cert-manager \
  --create-namespace \
  --values helm/cert-manager/values.yaml
```

Update `k8s/cert-manager/cluster-issuer.yaml` with your email, then:

```bash
kubectl apply -f k8s/cert-manager/cluster-issuer.yaml
```

## 4. Install ExternalDNS

Replace the role ARN placeholder in `helm/external-dns/values.yaml` with:

```bash
terraform -chdir=infra output -raw irsa_external_dns_role_arn
```

Then install:

```bash
helm repo add external-dns https://kubernetes-sigs.github.io/external-dns/
helm repo update
helm upgrade --install external-dns external-dns/external-dns \
  --namespace external-dns \
  --create-namespace \
  --values helm/external-dns/values.yaml
```

## 5. Deploy the app

```bash
kubectl apply -f k8s/app/
```

## 6. Optional: Argo CD and Monitoring

```bash
helm repo add argo https://argoproj.github.io/argo-helm
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update

helm upgrade --install argocd argo/argo-cd \
  --namespace argocd \
  --create-namespace \
  --values helm/argocd/values.yaml

helm upgrade --install kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --namespace monitoring \
  --create-namespace \
  --values helm/monitoring/values.yaml
```

