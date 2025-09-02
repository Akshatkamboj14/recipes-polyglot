#!/bin/bash
set -e

echo "🚀 Starting Kubernetes setup..."

# 1. DB
echo "📦 Applying DB manifests..."
kubectl apply -f ./db
sleep 5
# 2. Userdata
echo "👤 Applying Userdata manifests..."
kubectl apply -f ./userdata
sleep 5
# 3. Secrets
echo "🔑 Creating secrets..."
if [ -f "../.env" ]; then
  kubectl create secret generic aws-secrets --from-env-file=../.env
else
  echo "⚠️  .env file not found! Skipping secrets..."
fi
sleep 5
# 4. Suggest
echo "💡 Applying Suggest manifests..."
kubectl apply -f ./suggest
# extra api-gate
sleep 5
kubectl apply -f ./apigate
sleep 5
# 5. Frontend
echo "🌐 Applying Frontend manifests..."
kubectl apply -f ./frontend
sleep 5
# 6. HPA
echo "📊 Applying Metrics + HPA..."
kubectl apply -f ./hpa/metrics.yaml
sleep 15
kubectl apply -f ./hpa/hpa.yaml
sleep 15

# 7. Ingress
echo "🌍 Setting up Ingress..."
kubectl apply -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.0/deploy/static/provider/baremetal/deploy.yaml
sleep 15
kubectl apply -f ./ingress/ingress-nodeport.yaml
sleep 15
kubectl apply -f ./ingress/ingress.yaml
sleep 5
# 8. Network Policies
echo "🔒 Applying Network Policies..."
kubectl apply -f ./network-policies

echo "✅ All manifests applied successfully!"

