# Krishna DevOps Multi-Service Application

[![Build Status](https://img.shields.io/badge/status-production--ready-green)](https://github.com/krishnadevopstraining-tech/simple-java-application)
[![Version](https://img.shields.io/badge/version-1.0.0-blue)](https://github.com/krishnadevopstraining-tech/simple-java-application/releases)
[![License](https://img.shields.io/badge/license-MIT-green)](LICENSE)

## 🎯 Project Overview

A complete enterprise-grade microservices application demonstrating production-ready practices with:
- **Backend**: Spring Boot 3.2 REST API
- **Frontend**: React 18 with TypeScript
- **Database**: PostgreSQL 15
- **Containerization**: Independent Docker images for all services
- **Orchestration**: Kubernetes 1.24+
- **CI/CD**: Independent Jenkins pipelines for each service
- **Monitoring**: Prometheus & health checks

---

## 📋 Table of Contents

- [Quick Start](#-quick-start)
- [Architecture](#-architecture)
- [Services](#-services)
- [Installation](#-installation)
- [Development](#-development)
- [Docker & Images](#-docker--images)
- [Kubernetes Deployment](#-kubernetes-deployment)
- [CI/CD Pipeline](#-cicd-pipeline)
- [Troubleshooting](#-troubleshooting)

---

## 🚀 Quick Start

### Option 1: Backend Only (Spring Boot)
```bash
cd backend
mvn spring-boot:run
```
- API: http://localhost:8080
- Docs: http://localhost:8080/swagger-ui.html
- Health: http://localhost:8080/api/v1/health

### Option 2: Frontend Only (React)
```bash
cd frontend
npm install
npm start
```
- UI: http://localhost:3000

### Option 3: Full Stack (All Services)

**Terminal 1 - Start Database:**
```bash
docker run -d \
  --name krishna-postgres \
  -e POSTGRES_DB=krishna_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres:15-alpine
```

**Terminal 2 - Start Backend:**
```bash
cd backend && mvn spring-boot:run
```

**Terminal 3 - Start Frontend:**
```bash
cd frontend && npm install && npm start
```

---

## 🏗️ Architecture

### Service Diagram
```
┌─────────────────────────────────────────────────────────┐
│           Frontend (React 18, Port 3000)                │
│         User Management Web Interface                   │
└────────────────────────┬────────────────────────────────┘
                         │ HTTP/REST
┌────────────────────────┴────────────────────────────────┐
│          Nginx Reverse Proxy & Static Files             │
│     Caching, Compression, Security Headers              │
└────────────────────────┬────────────────────────────────┘
                         │ HTTP/REST
┌────────────────────────┴────────────────────────────────┐
│        Backend (Spring Boot 3.2, Port 8080)             │
│     RESTful API, Swagger UI, Health Checks              │
│     Prometheus Metrics, Actuator Endpoints              │
└────────────────────────┬────────────────────────────────┘
                         │ JDBC
┌────────────────────────┴────────────────────────────────┐
│      PostgreSQL 15 Database (Port 5432)                 │
│    Data Persistence, Connection Pooling, Health Checks  │
└─────────────────────────────────────────────────────────┘
```

### Independent Services
Each service operates independently with:
- ✅ **Separate Dockerfile** - Individual containerization
- ✅ **Dedicated Jenkinsfile** - Independent CI/CD pipeline
- ✅ **Own Kubernetes Deployment** - Isolated service management
- ✅ **Service-Specific Configuration** - Custom settings per service

---

## 📦 Services

### Backend Service (Spring Boot 3.2)
| Aspect | Details |
|--------|---------|
| **Language** | Java 17 |
| **Framework** | Spring Boot 3.2.0 |
| **Database** | PostgreSQL 15 (JPA/Hibernate) |
| **API** | REST with Swagger/OpenAPI |
| **Features** | Health Checks, Prometheus Metrics, Actuator |
| **Port** | 8080 |
| **Location** | `/backend` |
| **Dockerfile** | `backend/Dockerfile` |
| **Pipeline** | `backend/Jenkinsfile` |

### Frontend Service (React 18)
| Aspect | Details |
|--------|---------|
| **Language** | TypeScript 5.0 |
| **Framework** | React 18.2 |
| **Styling** | Tailwind CSS |
| **Features** | User Management UI, Form Validation |
| **Server** | Nginx (production) |
| **Port** | 3000 (dev) / 80 (nginx) |
| **Location** | `/frontend` |
| **Dockerfile** | `frontend/Dockerfile` |
| **Pipeline** | `frontend/Jenkinsfile` |

### Database Service (PostgreSQL 15)
| Aspect | Details |
|--------|---------|
| **DBMS** | PostgreSQL 15 |
| **Features** | Health Checks, Connection Pooling, Auto-init |
| **Storage** | Persistent Volumes (K8s) / Docker Volumes |
| **Port** | 5432 |
| **Location** | `/database` |
| **Dockerfile** | `database/Dockerfile` |
| **Pipeline** | `database/Jenkinsfile` |

---

## 🛠️ Installation

### Prerequisites

**System Requirements:**
- Docker 20.10+
- kubectl 1.24+ (for Kubernetes)
- Git 2.30+

**Backend Requirements:**
- Java 17+
- Maven 3.8+

**Frontend Requirements:**
- Node.js 18+
- npm 9+

### Clone Repository
```bash
git clone https://github.com/krishnadevopstraining-tech/simple-java-application.git
cd simple-java-application
```

### Verify Project Structure
```bash
tree -L 2
# or
ls -la
```

---

## 💻 Development

### Backend Development

```bash
cd backend

# Build the project
mvn clean install

# Run locally
mvn spring-boot:run

# Run tests
mvn test

# Code quality analysis
mvn sonar:sonar

# View API docs
curl http://localhost:8080/swagger-ui.html
```

### Frontend Development

```bash
cd frontend

# Install dependencies
npm install

# Start development server
npm start

# Run tests
npm test

# Build production bundle
npm run build

# Lint code
npm run lint
```

### Database Management

```bash
# Start PostgreSQL container
docker run -d \
  --name krishna-postgres \
  -e POSTGRES_DB=krishna_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres:15-alpine

# Access database
psql -h localhost -U postgres -d krishna_db

# Stop database
docker stop krishna-postgres
docker rm krishna-postgres
```

### API Endpoints

**User CRUD:**
```bash
# Create user
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John","email":"john@example.com","phone":"+1-123-456-7890"}'

# Get all users (paginated)
curl http://localhost:8080/api/v1/users?page=0&size=10

# Get user by ID
curl http://localhost:8080/api/v1/users/1

# Get by email
curl http://localhost:8080/api/v1/users/email/john@example.com

# Update user
curl -X PUT http://localhost:8080/api/v1/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"John Updated"}'

# Delete user
curl -X DELETE http://localhost:8080/api/v1/users/1
```

**Health & Info:**
```bash
curl http://localhost:8080/api/v1/health
curl http://localhost:8080/api/v1/info
curl http://localhost:8080/actuator/health
curl http://localhost:8080/actuator/prometheus
```

---

## 🐳 Docker & Images

### Building Docker Images

**Backend:**
```bash
docker build -f backend/Dockerfile -t krishna-backend:v1.0 .
```

**Frontend:**
```bash
docker build -f frontend/Dockerfile -t krishna-frontend:v1.0 .
```

**Database:**
```bash
docker build -f database/Dockerfile -t krishna-database:v1.0 .
```

### Build All Images
```bash
./scripts/build-docker.sh
```

### Pushing to Registry
```bash
# Set your registry URL
REGISTRY=myregistry.azurecr.io

# Push all images
docker tag krishna-backend:v1.0 $REGISTRY/krishna-backend:v1.0
docker tag krishna-frontend:v1.0 $REGISTRY/krishna-frontend:v1.0
docker tag krishna-database:v1.0 $REGISTRY/krishna-database:v1.0

docker push $REGISTRY/krishna-backend:v1.0
docker push $REGISTRY/krishna-frontend:v1.0
docker push $REGISTRY/krishna-database:v1.0
```

---

## ☸️ Kubernetes Deployment

### Prerequisites
- Kubernetes 1.24+ cluster
- kubectl configured
- NGINX Ingress Controller (optional)

### Deploy to Kubernetes

```bash
# Make scripts executable
chmod +x scripts/*.sh

# Deploy all services
./scripts/deploy-k8s.sh

# Verify deployment
kubectl get pods -n krishna-devops
kubectl get svc -n krishna-devops
```

### Advanced Kubernetes Concepts

This project includes 14 Kubernetes manifests demonstrating enterprise patterns:

**1. Storage Classes (k8s/13-storage-classes.yml)**
- Dynamic storage provisioning
- Fast storage for databases (gp3, 5000 IOPS)
- Slow storage for logs (st1, cost-optimized)
- Volume reclaim policies and expansion

**2. Advanced Scheduling (k8s/14-advanced-scheduling.yml)**
- **Taints & Tolerations**: Prevent pods from inappropriate nodes
- **Node Affinity**: Control pod-to-node scheduling (hard/soft rules)
- **Pod Affinity**: Co-locate related pods together
- **Pod Anti-Affinity**: Spread pods across nodes for HA
- **Topology Keys**: Zone and region based scheduling

See [KUBERNETES_ADVANCED.md](KUBERNETES_ADVANCED.md) for detailed explanations and hands-on exercises.

### Kubernetes Manifests Overview

```
k8s/
├── 01-namespace.yml              # Logical isolation
├── 02-configmap.yml              # Configuration data
├── 03-secrets.yml                # Sensitive data
├── 04-postgres-pvc.yml           # Storage claim
├── 05-postgres-deployment.yml    # Database
├── 06-init-script-configmap.yml  # Database initialization
├── 07-backend-deployment.yml     # Backend service
├── 08-frontend-deployment.yml    # Frontend service
├── 09-ingress.yml                # External routing
├── 10-hpa.yml                    # Auto-scaling (3-10 replicas)
├── 11-pdb.yml                    # Pod disruption budgets
├── 12-monitoring.yml             # Prometheus monitoring
├── 13-storage-classes.yml        # Dynamic storage provisioning
└── 14-advanced-scheduling.yml    # Taints, affinity, anti-affinity
```

### Access Services

**Via Port-Forward:**
```bash
# Backend API
kubectl port-forward -n krishna-devops svc/backend 8080:8080

# Frontend
kubectl port-forward -n krishna-devops svc/frontend 3000:3000

# Database
kubectl port-forward -n krishna-devops svc/postgres 5432:5432
```

**Via Ingress (after configuration):**
```bash
# Edit /etc/hosts:
127.0.0.1 krishnadevops.local
127.0.0.1 api.krishnadevops.local

# Access:
curl http://api.krishnadevops.local/api/v1/health
curl http://krishnadevops.local
```

### Scaling Services
```bash
# Manual scaling
kubectl scale deployment backend --replicas=5 -n krishna-devops
kubectl scale deployment frontend --replicas=5 -n krishna-devops

# Check HPA
kubectl get hpa -n krishna-devops
```

### Monitoring Kubernetes

```bash
# View pod logs
kubectl logs -f deployment/backend -n krishna-devops

# Pod resource usage
kubectl top pods -n krishna-devops

# View events
kubectl get events -n krishna-devops

# Pod details
kubectl describe pod <pod-name> -n krishna-devops
```

### Cleanup
```bash
./scripts/cleanup-k8s.sh
# or manually:
kubectl delete namespace krishna-devops
```

---

## 🔄 CI/CD Pipeline

### Independent Service Pipelines

Each service has its own dedicated pipeline:

#### Backend Pipeline (`backend/Jenkinsfile`)
**8 Stages:**
1. Checkout → 2. Build → 3. Unit Tests → 4. Code Quality (SonarQube)
5. Build Docker → 6. Security Scan (Trivy) → 7. Push Registry → 8. Deploy

#### Frontend Pipeline (`frontend/Jenkinsfile`)
**9 Stages:**
1. Checkout → 2. Dependencies → 3. Lint → 4. Build → 5. Unit Tests
6. Code Quality → 7. Build Docker → 8. Security Scan → 9. Deploy

#### Database Pipeline (`database/Jenkinsfile`)
**9 Stages:**
1. Checkout → 2. Validate Schema → 3. Build Docker → 4. Test Image
5. Security Scan → 6. Push Registry → 7. Deploy Staging → 8. Health Check → 9. Deploy Prod

### Jenkins Configuration

**Create Three Pipeline Jobs:**

1. **krishna-backend-pipeline**
   - Script Path: `backend/Jenkinsfile`

2. **krishna-frontend-pipeline**
   - Script Path: `frontend/Jenkinsfile`

3. **krishna-database-pipeline**
   - Script Path: `database/Jenkinsfile`

**Configure Credentials:**
- `docker-registry-url`
- `docker-registry-username`
- `docker-registry-password`
- `sonar-host-url` (optional)
- `sonar-token` (optional)

### Pipeline Triggers
- All pipelines: `main` branch or `v*` tags
- Independent execution
- Parallel capability

---

## 📁 Project Structure

```
.
├── backend/                      # Spring Boot API
│   ├── src/main/java/com/example/
│   │   ├── BackendApplication.java
│   │   ├── controller/           # REST endpoints
│   │   ├── model/                # JPA entities
│   │   ├── service/              # Business logic
│   │   ├── repository/           # Data access
│   │   └── exception/            # Error handling
│   ├── src/main/resources/
│   │   └── application.yml       # Configuration
│   ├── pom.xml                   # Maven config
│   ├── Dockerfile                # Backend image
│   ├── Jenkinsfile               # Backend pipeline
│   └── README.md
│
├── frontend/                     # React Application
│   ├── src/
│   │   ├── App.tsx               # Main component
│   │   ├── index.tsx             # Entry point
│   │   └── index.css             # Tailwind CSS
│   ├── public/
│   │   └── index.html
│   ├── package.json              # NPM config
│   ├── tailwind.config.js        # Tailwind config
│   ├── Dockerfile                # Frontend image
│   ├── nginx.conf                # Nginx config
│   ├── Jenkinsfile               # Frontend pipeline
│   └── README.md
│
├── database/                     # PostgreSQL Setup
│   ├── init.sql                  # Schema & seed data
│   ├── Dockerfile                # Database image
│   ├── Jenkinsfile               # Database pipeline
│   └── README.md
│
├── k8s/                          # Kubernetes Manifests
│   ├── 01-namespace.yml
│   ├── 02-configmap.yml
│   ├── 03-secrets.yml
│   ├── 04-postgres-pvc.yml
│   ├── 05-postgres-deployment.yml
│   ├── 06-init-script-configmap.yml
│   ├── 07-backend-deployment.yml
│   ├── 08-frontend-deployment.yml
│   ├── 09-ingress.yml
│   ├── 10-hpa.yml                # Auto-scaling
│   ├── 11-pdb.yml                # Pod disruption budget
│   └── 12-monitoring.yml         # Prometheus config
│
├── scripts/                      # Automation
│   ├── start-dev.sh              # Start services
│   ├── build-docker.sh           # Build images
│   ├── deploy-k8s.sh             # Deploy to K8s
│   └── cleanup-k8s.sh            # Cleanup
│
├── Jenkinsfile                   # Main pipeline reference
├── README.md                     # This file
├── QUICKSTART.md                 # Quick reference
├── DEPLOYMENT.md                 # Deployment guide
├── DELIVERABLES.md               # Project checklist
├── .gitignore
└── .dockerignore
```

---

## 🐛 Troubleshooting

### Backend Issues
```bash
# Port 8080 in use
lsof -i :8080
kill -9 <PID>

# Use different port
mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8081"

# View logs
cd backend && mvn spring-boot:run
```

### Frontend Issues
```bash
# Port 3000 in use
lsof -i :3000
kill -9 <PID>

# Clear cache
rm -rf node_modules package-lock.json
npm install
npm start
```

### Database Connection Error
```bash
# Check PostgreSQL container
docker ps | grep krishna-postgres

# View logs
docker logs krishna-postgres

# Test connection
psql -h localhost -U postgres -d krishna_db
```

### Kubernetes Pod Issues
```bash
# Pod status
kubectl get pods -n krishna-devops
kubectl describe pod <pod-name> -n krishna-devops
kubectl logs <pod-name> -n krishna-devops

# Recent events
kubectl get events -n krishna-devops --sort-by='.lastTimestamp'

# Delete and recreate
kubectl delete pod <pod-name> -n krishna-devops
```

---

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| [README.md](README.md) | Main documentation (this file) |
| [QUICKSTART.md](QUICKSTART.md) | Quick reference guide |
| [DEPLOYMENT.md](DEPLOYMENT.md) | Detailed deployment procedures |
| [DELIVERABLES.md](DELIVERABLES.md) | Project completeness checklist |
| [KUBERNETES_ADVANCED.md](KUBERNETES_ADVANCED.md) | **Advanced K8s scheduling & storage** |
| [backend/README.md](backend/README.md) | Backend service details |
| [frontend/README.md](frontend/README.md) | Frontend service details |
| [database/README.md](database/README.md) | Database documentation |

### 🎓 Educational Scripts

Run these to learn about the project:

```bash
# Line-by-line explanation of the entire project for students
bash scripts/explain-project.sh
```

This interactive script explains:
- Project structure and organization
- Backend service (Spring Boot)
- Frontend service (React)
- Database service (PostgreSQL)
- Docker containerization
- Jenkins CI/CD pipelines
- Kubernetes deployment
- Advanced scheduling concepts
- Complete deployment workflow
- Key concepts and best practices
- Hands-on commands


---

## 🔐 Security Features

✅ **Non-root Execution** - All containers run as non-root  
✅ **Health Checks** - Liveness & readiness probes  
✅ **Input Validation** - Request validation on all endpoints  
✅ **SQL Injection Protection** - Parameterized queries (JPA)  
✅ **Security Headers** - CORS and security headers  
✅ **Secret Management** - Kubernetes Secrets  
✅ **Image Scanning** - Trivy vulnerability scanning  
✅ **HTTPS Ready** - TLS/SSL configuration available  

---

## 📈 Performance & Scaling

### Auto-Scaling (HPA)
- **Backend**: 3-10 replicas (CPU 70-75%, Memory 80-85%)
- **Frontend**: 3-10 replicas (CPU 70-75%, Memory 80-85%)
- **Database**: 1 replica (stateful)

### Resource Limits
```
Backend:   Memory: 512Mi-1Gi,    CPU: 250m-500m
Frontend:  Memory: 256Mi-512Mi,  CPU: 100m-250m
Database:  Memory: 1Gi-2Gi,      CPU: 500m-1000m
```

---

## 🚀 Production Deployment Checklist

- [ ] Kubernetes cluster (1.24+) operational
- [ ] NGINX Ingress Controller installed
- [ ] Docker registry configured
- [ ] Jenkins environment setup
- [ ] CI/CD credentials configured
- [ ] DNS/Ingress records created
- [ ] Persistent storage provisioned
- [ ] Database backups configured
- [ ] Monitoring dashboard setup
- [ ] Alert rules configured
- [ ] SSL/TLS certificates obtained
- [ ] Load testing completed
- [ ] Security audit passed
- [ ] Disaster recovery documented

---

## 📞 Support & Contact

**GitHub:** [krishnadevopstraining-tech/simple-java-application](https://github.com/krishnadevopstraining-tech/simple-java-application)  
**Issues:** GitHub Issues  
**Documentation:** See links above  

---

## 📄 License

MIT License - see LICENSE file

---

## 🎯 Version

**v1.0.0** (Current)
- ✅ Backend Service (Spring Boot 3.2)
- ✅ Frontend Service (React 18)
- ✅ Database Service (PostgreSQL 15)
- ✅ Independent Docker Images
- ✅ Individual CI/CD Pipelines
- ✅ Kubernetes Manifests
- ✅ Complete Documentation

**Status:** Production Ready ✅

---

**Last Updated:** 2024  
**Environment:** Kubernetes 1.24+ | Docker 20.10+ | Java 17+ | Node.js 18+

---

## 🎉 Thank You!

Thank you for using Krishna DevOps Multi-Service Application. We hope this project helps you understand modern microservices architecture, containerization, orchestration, and CI/CD practices.

Happy coding! 🚀
