# Database Service

PostgreSQL 15 database with production-ready configuration.

## Features

- **PostgreSQL 15**: Latest stable PostgreSQL
- **Health Checks**: Integrated health monitoring
- **Persistent Storage**: Named volumes for data persistence
- **Initialization Scripts**: Automatic schema setup
- **Connection Pooling**: Optimized for microservices

## Running

**Local Development:**
```bash
docker run -d \
  --name krishna-postgres \
  -e POSTGRES_DB=krishna_db \
  -e POSTGRES_USER=postgres \
  -e POSTGRES_PASSWORD=postgres \
  -p 5432:5432 \
  postgres:15-alpine
```

**Kubernetes:**
Database is managed through `k8s/05-postgres-deployment.yml`

## Connection Details

- **Host**: localhost (local) or postgres (Kubernetes)
- **Port**: 5432
- **Database**: krishna_db
- **User**: postgres
- **Password**: postgres (or via Secret in K8s)

## Accessing Database

**From Local Machine:**
```bash
psql -h localhost -U postgres -d krishna_db
```

**From Docker Container:**
```bash
docker exec -it krishna-postgres psql -U postgres -d krishna_db
```

**From Kubernetes:**
```bash
kubectl exec -it pod/<postgres-pod> -n krishna-devops -- \
  psql -U postgres -d krishna_db
```

## Schema

### Users Table

```sql
CREATE TABLE users (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    email VARCHAR(255) NOT NULL UNIQUE,
    phone VARCHAR(20) NOT NULL,
    message TEXT,
    created_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
    updated_at TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
);
```
