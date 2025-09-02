#!/bin/bash
set -e

echo "🧹 Cleaning up Kubernetes resources..."

# 1. Network Policies
echo "🔒 Deleting Network Policies..."
kubectl delete -f ./network-policies --ignore-not-found

# 2. Ingress
echo "🌍 Deleting Ingress..."
kubectl delete -f ./ingress/ingress.yaml --ignore-not-found
kubectl delete -f ./ingress/ingress-nodeport.yaml --ignore-not-found
kubectl delete -f https://raw.githubusercontent.com/kubernetes/ingress-nginx/controller-v1.9.0/deploy/static/provider/baremetal/deploy.yaml --ignore-not-found

# 3. HPA
echo "📊 Deleting HPA + Metrics..."
kubectl delete -f ./hpa/hpa.yaml --ignore-not-found
kubectl delete -f ./hpa/metrics.yaml --ignore-not-found

# 4. Frontend
echo "🌐 Deleting Frontend..."
kubectl delete -f ./frontend --ignore-not-found

# 5. Suggest
echo "💡 Deleting Suggest..."
kubectl delete -f ./suggest --ignore-not-found

# 6. Secrets
echo "🔑 Deleting Secrets..."
kubectl delete secret aws-secrets --ignore-not-found

kubectl delete -f ./apigate


# 7. Userdata
echo "👤 Deleting Userdata..."
kubectl delete -f ./userdata --ignore-not-found

# 8. DB
echo "📦 Deleting DB..."
kubectl delete -f ./db --ignore-not-found

echo "✅ Cleanup completed!"

