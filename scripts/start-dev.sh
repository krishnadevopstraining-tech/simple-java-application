#!/bin/bash

# Local development startup script - Build services individually

set -e

echo "🚀 Krishna DevOps Multi-Service Application - Local Development Setup"
echo ""
echo "📋 Services to build and run individually:"
echo "   1. Backend (Spring Boot) - mvn spring-boot:run"
echo "   2. Frontend (React) - npm start"
echo "   3. Database (PostgreSQL) - Docker container"
echo ""
echo "🐳 Starting PostgreSQL database..."
docker run -d \
  --name krishna-postgres \
  -e POSTGRES_DB=krishna_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres:15-alpine

echo ""
echo "✅ PostgreSQL started!"
echo ""
echo "📚 Next steps:"
echo ""
echo "1️⃣  Terminal 1 - Start Backend:"
echo "   cd backend"
echo "   mvn spring-boot:run"
echo ""
echo "2️⃣  Terminal 2 - Start Frontend:"
echo "   cd frontend"
echo "   npm install"
echo "   npm start"
echo ""
echo "3️⃣  Access services:"
echo "   - Frontend:    http://localhost:3000"
echo "   - Backend:     http://localhost:8080"
echo "   - API Docs:    http://localhost:8080/swagger-ui.html"
echo "   - Health:      http://localhost:8080/actuator/health"
echo "   - Database:    localhost:5432 (postgres:postgres)"
echo ""
echo "💾 Stop PostgreSQL:"
echo "   docker stop krishna-postgres"
echo "   docker rm krishna-postgres"

