#!/bin/bash
set -e

echo "=== Step 0: Setting working directory ==="
cd "$(dirname "$0")"

echo "=== Step 1: Deploy Metrics Server ==="
# Download metrics-server YAML
METRICS_URL="https://github.com/kubernetes-sigs/metrics-server/releases/latest/download/components.yaml"
curl -Lo metrics-server.yaml $METRICS_URL
kubectl apply -f metrics-server.yaml

echo "Waiting for metrics-server to be ready..."
kubectl wait --for=condition=available --timeout=120s deployment metrics-server -n kube-system

echo "=== Step 2: Deploy Ingress Controller ==="
# Download ingress-nginx YAML
INGRESS_URL="https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.8.0/deploy/static/provider/cloud/deploy.yaml"
curl -Lo ingress-nginx.yaml $INGRESS_URL
kubectl apply -f ingress-nginx.yaml

echo "Waiting for ingress controller to be ready..."
kubectl wait --for=condition=available --timeout=180s deployment ingress-nginx-controller -n ingress-nginx

echo "=== Step 3: Deploy Database ==="
kubectl apply -f db/

echo "=== Step 4: Deploy Backend Services ==="
kubectl apply -f apigate/
kubectl apply -f suggest/
kubectl apply -f userdata/

echo "=== Step 5: Deploy Frontend ==="
kubectl apply -f frontend/

echo "=== Step 6: Deploy Application Ingress ==="
kubectl apply -f ingress/ingress.yaml

echo "=== Step 7: Apply Network Policies ==="
kubectl apply -f network-policies/

echo "=== Step 8: Apply Horizontal Pod Autoscalers ==="
kubectl apply -f hpa/

echo "=== All resources deployed successfully! ==="
kubectl get all
kubectl get hpa

