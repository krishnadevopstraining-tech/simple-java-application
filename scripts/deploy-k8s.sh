#!/bin/bash

# Deploy all Kubernetes resources

set -e

echo "🚀 Deploying Krishna DevOps Multi-Service Application to Kubernetes..."

NAMESPACE="krishna-devops"
K8S_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Create namespace
echo "📦 Creating namespace..."
kubectl apply -f "$K8S_DIR/01-namespace.yml"

# Wait for namespace to be created
sleep 2

# Apply configurations
echo "⚙️  Applying configurations..."
kubectl apply -f "$K8S_DIR/02-configmap.yml"
kubectl apply -f "$K8S_DIR/03-secrets.yml"

# Apply database
echo "💾 Deploying database..."
kubectl apply -f "$K8S_DIR/04-postgres-pvc.yml"
kubectl apply -f "$K8S_DIR/06-init-script-configmap.yml"
kubectl apply -f "$K8S_DIR/05-postgres-deployment.yml"

# Wait for database to be ready
echo "⏳ Waiting for database to be ready..."
kubectl wait --for=condition=ready pod -l component=database -n $NAMESPACE --timeout=300s

# Apply backend
echo "🔧 Deploying backend service..."
kubectl apply -f "$K8S_DIR/07-backend-deployment.yml"

# Wait for backend to be ready
echo "⏳ Waiting for backend to be ready..."
kubectl wait --for=condition=ready pod -l component=backend -n $NAMESPACE --timeout=300s

# Apply frontend
echo "🎨 Deploying frontend service..."
kubectl apply -f "$K8S_DIR/08-frontend-deployment.yml"

# Wait for frontend to be ready
echo "⏳ Waiting for frontend to be ready..."
kubectl wait --for=condition=ready pod -l component=frontend -n $NAMESPACE --timeout=300s

# Apply scaling policies
echo "📊 Applying autoscaling policies..."
kubectl apply -f "$K8S_DIR/10-hpa.yml"
kubectl apply -f "$K8S_DIR/11-pdb.yml"

# Apply ingress
echo "🌐 Configuring ingress..."
kubectl apply -f "$K8S_DIR/09-ingress.yml"

# Apply monitoring
echo "📈 Applying monitoring configuration..."
kubectl apply -f "$K8S_DIR/12-monitoring.yml"

# Display deployment status
echo ""
echo "✅ Deployment complete!"
echo ""
echo "📊 Checking pod status..."
kubectl get pods -n $NAMESPACE -o wide

echo ""
echo "🔗 Services:"
kubectl get svc -n $NAMESPACE

echo ""
echo "🌐 Ingress:"
kubectl get ingress -n $NAMESPACE

echo ""
echo "💡 Tips:"
echo "  - Frontend: http://krishnadevops.local"
echo "  - API: http://api.krishnadevops.local or http://krishnadevops.local/api"
echo "  - View logs: kubectl logs -f deployment/backend -n $NAMESPACE"
echo "  - Port forward: kubectl port-forward -n $NAMESPACE svc/frontend 3000:3000"
