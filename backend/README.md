# Backend Service

Production-ready REST API built with Spring Boot 3.2, PostgreSQL, and comprehensive features.

## Features

- **REST API**: Complete CRUD operations for user management
- **Database**: PostgreSQL with JPA/Hibernate
- **API Documentation**: Swagger/OpenAPI UI at `/swagger-ui.html`
- **Health Checks**: Actuator endpoints for monitoring
- **Metrics**: Prometheus metrics support
- **Logging**: Structured logging with SLF4J and Logback
- **Validation**: Input validation with comprehensive error handling
- **Database Pooling**: HikariCP connection pooling

## Building

```bash
cd backend
mvn clean package
```

## Running Locally

```bash
# Development mode (uses H2 in-memory database)
mvn spring-boot:run

# Production mode (requires PostgreSQL)
mvn spring-boot:run -Dspring-boot.run.arguments="--spring.profiles.active=prod"
```

## API Endpoints

### User Management
- `POST /api/v1/users` - Create user
- `GET /api/v1/users/{id}` - Get user by ID
- `GET /api/v1/users/email/{email}` - Get user by email
- `GET /api/v1/users?page=0&size=10` - Get all users
- `PUT /api/v1/users/{id}` - Update user
- `DELETE /api/v1/users/{id}` - Delete user

### Health & Info
- `GET /api/v1/health` - Application health
- `GET /api/v1/info` - Application info
- `GET /actuator/health` - Spring Actuator health
- `GET /actuator/metrics` - Prometheus metrics

## Swagger Documentation

Accessible at `http://localhost:8080/swagger-ui.html`
