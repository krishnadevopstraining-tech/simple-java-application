#!/bin/bash

# Build Docker images and push to registry

set -e

REGISTRY=${REGISTRY:-krishnadevopstraining}
VERSION=${VERSION:-latest}

echo "🐳 Building Docker images..."

# Build backend
echo "🔨 Building backend image..."
docker build -f backend/Dockerfile -t $REGISTRY/krishna-backend:$VERSION .

# Build frontend
echo "🔨 Building frontend image..."
docker build -f frontend/Dockerfile -t $REGISTRY/krishna-frontend:$VERSION .

# Push images
if [ "$PUSH" = "true" ]; then
    echo "📤 Pushing images to registry..."
    docker push $REGISTRY/krishna-backend:$VERSION
    docker push $REGISTRY/krishna-frontend:$VERSION
    echo "✅ Images pushed successfully!"
else
    echo "ℹ️  Skipping push. To push images, set PUSH=true"
fi

echo ""
echo "✅ Build complete!"
echo "Images:"
echo "  - $REGISTRY/krishna-backend:$VERSION"
echo "  - $REGISTRY/krishna-frontend:$VERSION"
