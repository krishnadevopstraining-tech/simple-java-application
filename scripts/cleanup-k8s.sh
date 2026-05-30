#!/bin/bash

# Clean up all Kubernetes resources

set -e

NAMESPACE="krishna-devops"

echo "🗑️  Removing Krishna DevOps application from Kubernetes..."

# Delete all resources in namespace
kubectl delete namespace $NAMESPACE --ignore-not-found=true

echo "✅ Cleanup complete!"
echo "Note: PersistentVolumes may need to be manually cleaned depending on storage class"
