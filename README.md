# Krishna DevOps - Multi-Service Production-Ready Application

## 📋 Overview

This is a complete microservices application built with modern DevOps best practices. It includes:

- **Backend**: Spring Boot 3.2 REST API with PostgreSQL
- **Frontend**: React 18 with TypeScript and Tailwind CSS
- **Database**: PostgreSQL 15
- **Infrastructure**: Docker, Docker Compose, Kubernetes, Jenkins CI/CD

## 🏗️ Architecture

```
┌─────────────────────────────────────────────────────┐
│                   Load Balancer / Ingress            │
└──────────────────┬──────────────────────────────────┘
                   │
        ┌──────────┴──────────┐
        │                     │
    ┌───▼──────┐      ┌──────▼────┐
    │ Frontend  │      │  Backend   │
    │ (React)   │      │  (Spring)  │
    │ x3 pods   │      │  x3 pods   │
    └─────┬─────┘      └──────┬─────┘
          │                   │
          └───────────┬───────┘
                      │
              ┌───────▼────────┐
              │  PostgreSQL DB │
              │   (1 replica)  │
              └────────────────┘
```

## 📁 Project Structure

```
.
├── backend/                    # Java Spring Boot API
│   ├── src/
│   │   ├── main/java/
│   │   │   └── com/example/
│   │   │       ├── BackendApplication.java
│   │   │       ├── controller/       # REST endpoints
│   │   │       ├── service/          # Business logic
│   │   │       ├── repository/       # Data access
│   │   │       ├── model/            # Entity classes
│   │   │       └── exception/        # Exception handling
│   │   ├── main/resources/
│   │   │   ├── application.yml       # Dev config
│   │   │   └── application-prod.yml  # Prod config
│   │   └── test/
│   ├── pom.xml
│   ├── Dockerfile
│   └── README.md
│
├── frontend/                   # React Web Application
│   ├── src/
│   │   ├── App.tsx            # Main component
│   │   └── index.tsx          # Entry point
│   ├── public/
│   ├── package.json
│   ├── Dockerfile
│   ├── nginx.conf             # Nginx config
│   └── README.md
│
├── database/                   # Database setup
│   ├── init.sql               # Schema & seed data
│   └── README.md
│
├── k8s/                        # Kubernetes manifests
│   ├── 01-namespace.yml
│   ├── 02-configmap.yml
│   ├── 03-secrets.yml
│   ├── 04-postgres-pvc.yml
│   ├── 05-postgres-deployment.yml
│   ├── 06-init-script-configmap.yml
│   ├── 07-backend-deployment.yml
│   ├── 08-frontend-deployment.yml
│   ├── 09-ingress.yml
│   ├── 10-hpa.yml             # Horizontal Pod Autoscaler
│   ├── 11-pdb.yml             # Pod Disruption Budget
│   └── 12-monitoring.yml      # Prometheus config
│
├── scripts/                    # Automation scripts
│   ├── start-dev.sh           # Start individual services
│   ├── build-docker.sh        # Build Docker images
│   ├── deploy-k8s.sh          # Deploy to Kubernetes
│   ├── cleanup-k8s.sh         # Remove from Kubernetes
│   └── K8S_GUIDE.txt          # Kubernetes guide
│
├── Jenkinsfile               # Main CI/CD reference
├── .dockerignore
├── .gitignore
└── README.md                 # This file
```

## 🚀 Quick Start

### Backend Service Only

```bash
cd backend
mvn spring-boot:run
# Backend API: http://localhost:8080
# API Swagger: http://localhost:8080/swagger-ui.html
```

### Frontend Service Only

```bash
cd frontend
npm install
npm start
# Frontend: http://localhost:3000
```

### Full Stack (All Services)

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
cd backend
mvn spring-boot:run
```

**Terminal 3 - Start Frontend:**
```bash
cd frontend
npm install
npm start
```

## 📦 Features

### Backend Service

- ✅ RESTful API with CRUD operations
- ✅ PostgreSQL database integration
- ✅ JPA/Hibernate ORM
- ✅ API documentation (Swagger/OpenAPI)
- ✅ Health checks and metrics (Actuator)
- ✅ Comprehensive logging with SLF4J
- ✅ Input validation with error handling
- ✅ Connection pooling (HikariCP)
- ✅ Transaction management

### Frontend Service

- ✅ Modern React 18 UI
- ✅ TypeScript for type safety
- ✅ Tailwind CSS styling
- ✅ Form handling and validation
- ✅ API integration with Axios
- ✅ Responsive design
- ✅ Error handling
- ✅ Nginx reverse proxy

### Infrastructure

- ✅ Multi-stage Docker builds
- ✅ Docker Compose for local development
- ✅ Kubernetes manifests (12 files)
- ✅ Horizontal Pod Autoscaler
- ✅ Pod Disruption Budgets
- ✅ Persistent volumes
- ✅ ConfigMaps and Secrets
- ✅ Ingress configuration
- ✅ Prometheus monitoring

### CI/CD

- ✅ Jenkins pipeline
- ✅ Multi-stage builds
- ✅ Automated testing
- ✅ Docker image scanning (Trivy)
- ✅ SonarQube analysis
- ✅ Automated Kubernetes deployment
- ✅ Health checks and rollback

## 🔌 API Endpoints

### User Management
- `POST /api/v1/users` - Create user
- `GET /api/v1/users/{id}` - Get user by ID
- `GET /api/v1/users/email/{email}` - Get user by email
- `GET /api/v1/users?page=0&size=10` - Get all users (paginated)
- `PUT /api/v1/users/{id}` - Update user
- `DELETE /api/v1/users/{id}` - Delete user

### Health & Info
- `GET /api/v1/health` - Application health
- `GET /api/v1/info` - Application info
- `GET /actuator/health` - Spring health check
- `GET /actuator/metrics` - Application metrics
- `GET /actuator/prometheus` - Prometheus metrics
- `GET /swagger-ui.html` - API documentation

## 📊 Kubernetes Details

### Services
- **Namespace**: krishna-devops
- **Replicas**: 
  - Backend: 3 (min) - 10 (max) with HPA
  - Frontend: 3 (min) - 10 (max) with HPA
  - PostgreSQL: 1 replica

### Storage
- Persistent Volume: 10Gi for PostgreSQL
- Storage Class: standard (configurable)

### Security
- Pod Security Context (non-root user)
- Read-only root filesystem
- Network policies ready
- Secret-based credentials

### High Availability
- Pod Anti-affinity rules
- Pod Disruption Budgets
- Health checks (liveness & readiness)
- Graceful shutdown

## 🔒 Security Features

- ✅ Non-root container execution
- ✅ Read-only root filesystem
- ✅ Resource limits and requests
- ✅ Network segmentation
- ✅ Secret management
- ✅ Image scanning with Trivy
- ✅ HTTPS/TLS ready (Ingress)
- ✅ Security headers (Nginx)

## 📈 Monitoring & Logging

### Metrics
- Prometheus metrics at `/actuator/prometheus`
- CPU and memory tracking
- Request latency monitoring
- Database connection metrics

### Logging
- Structured logging with SLF4J
- Logback configuration
- Log files in containers
- Centralized logging ready

### Health Checks
- Liveness probes
- Readiness probes
- Health actuator endpoints

## 🔄 CI/CD Pipeline (Jenkins)

The project uses **INDEPENDENT pipeline files** for each service:

### Backend Pipeline
- **File**: `backend/Jenkinsfile`
- **Triggers**: Changes in `backend/**` or tags `v*`
- **Stages**: Build → Test → SonarQube → Docker Build → Security Scan → Push → Deploy Staging → Integration Tests → Deploy Production
- **Registry**: krishna-backend

### Frontend Pipeline
- **File**: `frontend/Jenkinsfile`
- **Triggers**: Changes in `frontend/**` or tags `v*`
- **Stages**: Build → Test → Lint → Docker Build → Security Scan → Push → Deploy Staging → E2E Tests → Deploy Production
- **Registry**: krishna-frontend

### Jenkins Setup

1. Create two Jenkins Pipeline jobs:
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

2. Configure Jenkins Credentials:
   - `docker-registry-url` - Docker registry URL
   - `docker-registry-username` - Docker username
   - `docker-registry-password` - Docker password
   - `sonar-host-url` - SonarQube server URL (optional)
   - `sonar-token` - SonarQube token (optional)

3. Configure GitHub Webhooks (optional):
   - Each service pipeline triggers independently
   - Backend pipeline: Changes in `backend/`, `pom.xml`
   - Frontend pipeline: Changes in `frontend/`, `package.json`

### Pipeline Features

✅ Service-specific builds  
✅ Independent testing & quality checks  
✅ Parallel execution capability  
✅ Service-specific credentials  
✅ Independent scaling & deployment  
✅ Easier debugging & maintenance  
✅ Flexible update schedules

## 🛠️ Environment Variables

### Backend
- `DB_HOST` - Database host
- `DB_PORT` - Database port
- `DB_NAME` - Database name
- `DB_USER` - Database user
- `DB_PASSWORD` - Database password
- `DB_POOL_SIZE` - Connection pool size
- `SERVER_PORT` - Server port
- `SPRING_PROFILES_ACTIVE` - Active profile (dev, docker, kubernetes)

### Frontend
- `REACT_APP_API_URL` - Backend API URL

### Database
- `POSTGRES_DB` - Database name
- `POSTGRES_USER` - PostgreSQL user
- `POSTGRES_PASSWORD` - PostgreSQL password

## 📋 Requirements

### For Local Development
- Docker 20.10+
- Docker Compose 2.0+
- Node.js 18+ (for frontend development)
- Java 17+ (for backend development)
- Maven 3.8+ (for backend)

### For Kubernetes
- Kubernetes 1.24+
- kubectl configured
- NGINX Ingress Controller (optional)
- 3+ nodes recommended

## 🧪 Testing

### Backend
```bash
cd backend
mvn test
```

### Frontend
```bash
cd frontend
npm test
```

## 📚 Documentation

- [Backend README](backend/README.md) - Backend service details
- [Frontend README](frontend/README.md) - Frontend service details
- [Database README](database/README.md) - Database schema
- [Kubernetes Guide](scripts/K8S_GUIDE.txt) - Kubernetes deployment

## 🚨 Troubleshooting

### Backend Issues
```bash
# View backend logs
cd backend && mvn spring-boot:run

# Check if port 8080 is in use
lsof -i :8080

# Kill process using port
kill -9 <PID>
```

### Frontend Issues
```bash
# View frontend logs
cd frontend && npm start

# Check if port 3000 is in use
lsof -i :3000

# Clear cache and reinstall
rm -rf node_modules package-lock.json
npm install
```

### Database Issues
```bash
# Check if PostgreSQL is running
docker ps | grep krishna-postgres

# View PostgreSQL logs
docker logs krishna-postgres

# Stop database
docker stop krishna-postgres
```

### Kubernetes Issues
```bash
# Check pod status
kubectl get pods -n krishna-devops

# View pod logs
kubectl logs -f deployment/backend -n krishna-devops

# Describe pod for events
kubectl describe pod <pod-name> -n krishna-devops

# Port forward for debugging
kubectl port-forward svc/backend 8080:8080 -n krishna-devops
```

## 🤝 Contributing

1. Clone the repository
2. Create a feature branch
3. Make changes
4. Submit a pull request

## 📄 License

This project is part of Krishna DevOps Training material.

## 📞 Support

For questions or issues, reach out to:
- GitHub: https://github.com/krishnadevopstraining-tech

---

**Last Updated**: May 2024
**Version**: 1.0.0
**Status**: Production Ready ✅

## Building the JAR

To build a deployable JAR file:

```bash
mvn clean package
```

The JAR file will be created in the `target/` directory as `krishna-devops-training-0.0.1-SNAPSHOT.jar`.

## Deploying the JAR

To run the JAR file:

```bash
java -jar target/krishna-devops-training-0.0.1-SNAPSHOT.jar
```

The application will start on port 8080 by default.

## Troubleshooting

- Ensure Java and Maven are installed and in your PATH.
- If port 8080 is in use, you can change it in `src/main/resources/application.properties` by adding `server.port=8081` or another port.
