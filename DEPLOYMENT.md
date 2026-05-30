# Deployment Guide

Complete guide for deploying the Krishna DevOps multi-service application.

## Table of Contents

1. [Local Development](#local-development)
2. [Docker & Kubernetes](#docker--kubernetes)
3. [Kubernetes Deployment](#kubernetes-deployment)
4. [CI/CD Pipeline](#cicd-pipeline)
5. [Production Deployment](#production-deployment)

## Local Development

### Prerequisites
- Java 17+
- Maven 3.8+
- Node.js 18+
- npm or yarn
- Docker (for database only)

### Running Individually

**Backend:**
```bash
cd backend
mvn spring-boot:run
```

**Frontend (in new terminal):**
```bash
cd frontend
npm install
npm start
```

**Database (in new terminal):**
```bash
docker run -d \
  --name krishna-postgres \
  -e POSTGRES_DB=krishna_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres:15-alpine
```

### Access Points
- Frontend: http://localhost:3000
- Backend API: http://localhost:8080
- API Swagger: http://localhost:8080/swagger-ui.html
- Database: localhost:5432

## Docker & Kubernetes

### Building Docker Images

Each service has its own Dockerfile for independent containerization:

```bash
# Build backend image
docker build -f backend/Dockerfile -t myregistry/krishna-backend:v1.0 .

# Build frontend image
docker build -f frontend/Dockerfile -t myregistry/krishna-frontend:v1.0 .
```

### Pushing to Registry

```bash
# Push backend
docker push myregistry/krishna-backend:v1.0

# Push frontend
docker push myregistry/krishna-frontend:v1.0
```

## Kubernetes Deployment

### Prerequisites
- Kubernetes 1.24+ cluster
- kubectl configured with cluster access
- Container registry access (Docker Hub, ECR, etc.)
- NGINX Ingress Controller (for ingress support)

### Preparation

1. **Build and push images to registry:**
```bash
docker build -f backend/Dockerfile -t myregistry/krishna-backend:latest .
docker push myregistry/krishna-backend:latest

docker build -f frontend/Dockerfile -t myregistry/krishna-frontend:latest .
docker push myregistry/krishna-frontend:latest
```

2. **Update image references in k8s manifests** (if using custom registry):
```bash
# Edit k8s/07-backend-deployment.yml
# Edit k8s/08-frontend-deployment.yml
# Change image references to your registry
```

3. **Update secrets:**
```bash
# Edit k8s/03-secrets.yml
# Update database credentials if needed
```

### Deployment Steps

```bash
# 1. Make scripts executable
chmod +x scripts/*.sh

# 2. Deploy all resources
./scripts/deploy-k8s.sh

# 3. Verify deployment
kubectl get pods -n krishna-devops
kubectl get svc -n krishna-devops
kubectl get ingress -n krishna-devops

# 4. Check deployment status
kubectl rollout status deployment/backend -n krishna-devops
kubectl rollout status deployment/frontend -n krishna-devops
```

### Accessing Services

#### Port Forwarding
```bash
# Frontend
kubectl port-forward -n krishna-devops svc/frontend 3000:3000

# Backend
kubectl port-forward -n krishna-devops svc/backend 8080:8080

# Database
kubectl port-forward -n krishna-devops svc/postgres 5432:5432
```

#### Through Ingress
Update your `/etc/hosts` file:
```
127.0.0.1  krishnadevops.local api.krishnadevops.local
```

Then access:
- Frontend: http://krishnadevops.local
- API: http://api.krishnadevops.local or http://krishnadevops.local/api

### Kubernetes Manifest Details

| File | Purpose |
|------|---------|
| 01-namespace.yml | Create isolated namespace |
| 02-configmap.yml | Configuration settings |
| 03-secrets.yml | Database credentials |
| 04-postgres-pvc.yml | Persistent storage for database |
| 05-postgres-deployment.yml | PostgreSQL database |
| 06-init-script-configmap.yml | Database initialization script |
| 07-backend-deployment.yml | Backend service (3 replicas) |
| 08-frontend-deployment.yml | Frontend service (3 replicas) |
| 09-ingress.yml | Ingress routing |
| 10-hpa.yml | Auto-scaling policies |
| 11-pdb.yml | Pod disruption budgets |
| 12-monitoring.yml | Prometheus config |

### Scaling

```bash
# Manual scaling
kubectl scale deployment backend --replicas=5 -n krishna-devops
kubectl scale deployment frontend --replicas=5 -n krishna-devops

# Check HPA status
kubectl get hpa -n krishna-devops
```

### Cleanup

```bash
# Remove all resources
./scripts/cleanup-k8s.sh

# Or manually
kubectl delete namespace krishna-devops
```

## CI/CD Pipeline

### Jenkins Prerequisites
- Jenkins 2.300+
- Docker plugin
- Kubernetes plugin
- Pipeline plugin
- SonarQube (optional)
- Trivy (optional)

### Jenkins Configuration

1. **Create two Pipeline jobs:**
   ```
   Job 1: krishna-backend-pipeline
     Pipeline Definition: Pipeline script from SCM
     SCM: git (this repo)
     Script Path: backend/Jenkinsfile
   
   Job 2: krishna-frontend-pipeline
     Pipeline Definition: Pipeline script from SCM
     SCM: git (this repo)
     Script Path: frontend/Jenkinsfile
   ```

2. **Configure Jenkins Credentials:**
   - `docker-registry-url` - Docker registry URL
   - `docker-registry-username` - Docker username
   - `docker-registry-password` - Docker password
   - `sonar-host-url` - SonarQube server URL (optional)
   - `sonar-token` - SonarQube token (optional)

3. **Trigger Configuration:**
   - GitHub webhooks (optional)
   - Backend pipeline: Changes in `backend/` or tags `v*`
   - Frontend pipeline: Changes in `frontend/` or tags `v*`

### Running Pipeline

Each service has its own independent pipeline:

**Backend Pipeline (`backend/Jenkinsfile`):**
1. Checkout → Build → Test → SonarQube → Docker Build → Security Scan → Push → Deploy

**Frontend Pipeline (`frontend/Jenkinsfile`):**
1. Checkout → Build → Test → Lint → Docker Build → Security Scan → Push → Deploy

## Production Deployment

### Pre-Deployment Checklist

- [ ] Database backups configured
- [ ] DNS configured
- [ ] SSL/TLS certificates obtained
- [ ] Monitoring and alerting setup
- [ ] Logging system configured
- [ ] Secrets properly managed
- [ ] Resource limits set
- [ ] Health checks verified
- [ ] Rollback plan prepared
- [ ] Load testing completed

### Deployment Process

1. **Blue-Green Deployment:**
```bash
# Keep current version (blue) running
# Deploy new version (green)
# Switch traffic after verification
# Rollback by switching back if needed
```

2. **Canary Deployment:**
```bash
# Deploy new version to subset of replicas
# Monitor metrics
# Gradually increase traffic
# Rollback if issues detected
```

3. **Rolling Update (Default):**
```bash
# Kubernetes handles rolling updates
# Configured in deployments
# Gradual pod replacement with health checks
```

### Production Environment

```yaml
Resources:
  CPU: 4 cores
  Memory: 16GB
  Storage: 100GB+

High Availability:
  Backend: 3+ replicas
  Frontend: 3+ replicas
  Database: 1+ replicas (with backups)
  
Networking:
  Load Balancer: External
  Ingress: NGINX or Cloud Provider
  CDN: Recommended for static assets

Monitoring:
  Prometheus: Metrics collection
  Grafana: Visualization
  ELK Stack: Log aggregation
  
Backup:
  Database: Daily snapshots
  Code: Version control
  Configuration: Encrypted storage
```

### Production Commands

```bash
# Deploy production version
./scripts/deploy-k8s.sh

# Verify health
kubectl get pods -n krishna-devops
kubectl logs -f deployment/backend -n krishna-devops

# Monitor resources
kubectl top nodes
kubectl top pods -n krishna-devops

# Check metrics
kubectl get hpa -n krishna-devops -w

# Rollback if needed
kubectl rollout undo deployment/backend -n krishna-devops
```

## Troubleshooting

### Common Issues

**Pods not starting:**
```bash
kubectl describe pod <pod-name> -n krishna-devops
kubectl logs <pod-name> -n krishna-devops
```

**Database connection issues:**
```bash
# Check database pod
kubectl get pod -n krishna-devops -l component=database
kubectl logs -f deployment/postgres -n krishna-devops

# Test connection
kubectl exec -it <backend-pod> -n krishna-devops -- \
  nc -zv postgres 5432
```

**Ingress not working:**
```bash
# Check ingress
kubectl describe ingress krishna-devops-ingress -n krishna-devops

# Check NGINX controller
kubectl get pods -n ingress-nginx
```

**High resource usage:**
```bash
# Check current usage
kubectl top pods -n krishna-devops

# Adjust resource limits
# Edit deployment files and reapply
kubectl apply -f k8s/07-backend-deployment.yml
```

## Best Practices

1. **Always use specific image tags (not latest)**
2. **Test in staging before production**
3. **Monitor logs and metrics continuously**
4. **Plan rollback strategy**
5. **Regular backups of database**
6. **Keep dependencies updated**
7. **Use namespaces for isolation**
8. **Implement rate limiting**
9. **Use network policies**
10. **Regular security audits**

## References

- [Kubernetes Documentation](https://kubernetes.io/docs/)
- [Docker Documentation](https://docs.docker.com/)
- [Jenkins Pipeline](https://www.jenkins.io/doc/book/pipeline/)
- [Spring Boot Reference](https://spring.io/projects/spring-boot)
- [React Documentation](https://react.dev/)
