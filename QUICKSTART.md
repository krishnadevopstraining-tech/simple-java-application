# Quick Start Guide

Get up and running with Krishna DevOps Multi-Service Application in minutes!

## 🏃 Quick Start - Individual Services

### Option 1: Backend Only (Spring Boot)

```bash
cd backend
mvn spring-boot:run
```
- Backend: http://localhost:8080
- API Docs: http://localhost:8080/swagger-ui.html
- Health: http://localhost:8080/actuator/health

### Option 2: Frontend Only (React)

```bash
cd frontend
npm install
npm start
```
- Frontend: http://localhost:3000

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
cd backend
mvn spring-boot:run
```

**Terminal 3 - Start Frontend:**
```bash
cd frontend
npm install
npm start
```

---

## 📋 Prerequisites

- Java 17+ (for backend)
- Maven 3.8+ (for backend)
- Node.js 18+ (for frontend)
- Docker (for database)
- kubectl (for Kubernetes deployment)

---

## 🎯 Common Tasks

### Stop PostgreSQL
```bash
docker stop krishna-postgres
docker rm krishna-postgres
```

### View Database
```bash
docker exec -it krishna-postgres psql -U postgres -d krishna_db
```

### Build Backend
```bash
cd backend
mvn clean package
```

### Build Frontend
```bash
cd frontend
npm run build
```

---

## 🐳 Docker Images

### Build Backend Image
```bash
docker build -f backend/Dockerfile -t krishna-backend:latest .
```

### Build Frontend Image
```bash
docker build -f frontend/Dockerfile -t krishna-frontend:latest .
```

### View Images
```bash
docker images | grep krishna
```

---

## ☸️ Kubernetes Deployment

### Deploy All Services
```bash
chmod +x scripts/*.sh
./scripts/deploy-k8s.sh
```

### Check Status
```bash
kubectl get pods -n krishna-devops
kubectl get svc -n krishna-devops
```

### View Logs
```bash
kubectl logs -f deployment/backend -n krishna-devops
kubectl logs -f deployment/frontend -n krishna-devops
```

### Port Forward
```bash
# Backend
kubectl port-forward -n krishna-devops svc/backend 8080:8080

# Frontend
kubectl port-forward -n krishna-devops svc/frontend 3000:3000
```

### Cleanup
```bash
./scripts/cleanup-k8s.sh
```

---

## 🔗 API Endpoints

### Users
```bash
# Create user
curl -X POST http://localhost:8080/api/v1/users \
  -H "Content-Type: application/json" \
  -d '{"name":"John","email":"john@example.com","phone":"+1-123-456-7890"}'

# Get all users
curl http://localhost:8080/api/v1/users

# Get user by ID
curl http://localhost:8080/api/v1/users/1

# Update user
curl -X PUT http://localhost:8080/api/v1/users/1 \
  -H "Content-Type: application/json" \
  -d '{"name":"John Updated"}'

# Delete user
curl -X DELETE http://localhost:8080/api/v1/users/1
```

### Health & Info
```bash
curl http://localhost:8080/api/v1/health
curl http://localhost:8080/api/v1/info
```

---

## 🔍 Access Services

### Frontend
- Local: http://localhost:3000
- K8s: http://krishnadevops.local (after port-forward)

### Backend API
- Local: http://localhost:8080
- API Docs: http://localhost:8080/swagger-ui.html
- K8s: http://api.krishnadevops.local (after port-forward)

### Database
- Host: localhost
- Port: 5432
- User: postgres
- Password: postgres
- Database: krishna_db

---

## 📊 Monitoring

### Backend Metrics
```bash
curl http://localhost:8080/actuator/prometheus
```

### K8s Metrics
```bash
kubectl top nodes
kubectl top pods -n krishna-devops
```

---

## 🛠️ CI/CD Setup

### Individual Jenkins Pipelines

**Backend Pipeline:**
- File: `backend/Jenkinsfile`
- Stages: Build → Test → Docker → Security Scan → Push → Deploy

**Frontend Pipeline:**
- File: `frontend/Jenkinsfile`
- Stages: Build → Test → Docker → Security Scan → Push → Deploy

### Configure Jenkins

1. Create two pipeline jobs:
   - "krishna-backend-pipeline" → Script Path: `backend/Jenkinsfile`
   - "krishna-frontend-pipeline" → Script Path: `frontend/Jenkinsfile`

2. Add credentials:
   - docker-registry-url
   - docker-registry-username
   - docker-registry-password
   - sonar-host-url (optional)
   - sonar-token (optional)

---

## 🐛 Troubleshooting

### Backend won't start?
```bash
# Check if port 8080 is in use
lsof -i :8080
kill -9 <PID>

# Or use different port
mvn spring-boot:run -Dspring-boot.run.arguments="--server.port=8081"
```

### Frontend won't start?
```bash
# Check if port 3000 is in use
lsof -i :3000
kill -9 <PID>

# Clear npm cache
npm cache clean --force
rm -rf node_modules package-lock.json
npm install
```

### Database connection error?
```bash
# Check if PostgreSQL is running
docker ps | grep krishna-postgres

# Test connection
psql -h localhost -U postgres -d krishna_db
```

### Kubernetes pod issues?
```bash
kubectl describe pod <pod-name> -n krishna-devops
kubectl get events -n krishna-devops
```

---

## 📁 File Structure

```
.
├── backend/              # Spring Boot
│   ├── src/
│   ├── pom.xml
│   ├── Dockerfile
│   └── Jenkinsfile
├── frontend/             # React
│   ├── src/
│   ├── package.json
│   ├── Dockerfile
│   └── Jenkinsfile
├── database/             # PostgreSQL setup
├── k8s/                  # Kubernetes manifests
├── scripts/              # Automation scripts
└── Jenkinsfile          # Main Jenkins reference
```

---

## 📚 Documentation

| Document | Purpose |
|----------|---------|
| [README.md](README.md) | Project overview |
| [DEPLOYMENT.md](DEPLOYMENT.md) | Deployment guide |
| [DELIVERABLES.md](DELIVERABLES.md) | Complete checklist |
| [backend/README.md](backend/README.md) | Backend details |
| [frontend/README.md](frontend/README.md) | Frontend details |

---

## ⚡ Performance Tips

**Development:**
- Start services individually for faster iteration
- Use host machine for database in dev

**Production:**
- Always use specific image tags (not `latest`)
- Enable all health checks
- Monitor resource usage

---

## 🚀 Next Steps

1. **Start Backend:** `cd backend && mvn spring-boot:run`
2. **Start Frontend:** `cd frontend && npm install && npm start`
3. **Start Database:** Use docker command above
4. **Test API:** http://localhost:8080/swagger-ui.html
5. **Deploy to K8s:** `./scripts/deploy-k8s.sh`

---

**Happy coding!** 🎉

