#!/bin/bash

# ============================================================================
# KRISHNA DEVOPS MULTI-SERVICE APPLICATION - EDUCATIONAL WALKTHROUGH
# ============================================================================
# This script provides a detailed line-by-line explanation of the project
# for students to understand the architecture, implementation, and deployment
#
# Usage: bash scripts/explain-project.sh
# ============================================================================

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
PURPLE='\033[0;35m'
CYAN='\033[0;36m'
NC='\033[0m' # No Color

# Functions for formatting
header() {
    echo -e "\n${BLUE}╔════════════════════════════════════════════════════════════════╗${NC}"
    echo -e "${BLUE}║${NC} $1"
    echo -e "${BLUE}╚════════════════════════════════════════════════════════════════╝${NC}\n"
}

section() {
    echo -e "\n${PURPLE}▶ $1${NC}"
    echo -e "${PURPLE}━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━${NC}"
}

explanation() {
    echo -e "${CYAN}📝 $1${NC}"
}

code_block() {
    echo -e "${YELLOW}$ $1${NC}"
}

important() {
    echo -e "${RED}⚠️  $1${NC}"
}

success() {
    echo -e "${GREEN}✅ $1${NC}"
}

# ============================================================================
# START OF EDUCATIONAL CONTENT
# ============================================================================

header "KRISHNA DEVOPS MULTI-SERVICE APPLICATION"

explanation "Welcome! This educational walkthrough will explain the entire project."
explanation "We'll cover: Architecture, Services, Dockerization, CI/CD, and Kubernetes"

# ============================================================================
# PART 1: PROJECT STRUCTURE
# ============================================================================

section "PART 1: PROJECT STRUCTURE & ORGANIZATION"

explanation "
Let's start by understanding the project structure. This follows industry best 
practices for microservices architecture.
"

code_block "tree -L 2 -a"
explanation "
This shows us the directory structure with two levels of depth.

KEY DIRECTORIES:
  • backend/    → Spring Boot REST API service
  • frontend/   → React user interface service
  • database/   → PostgreSQL database service
  • k8s/        → Kubernetes manifests for deployment
  • scripts/    → Automation scripts for development and deployment
"

# ============================================================================
# PART 2: BACKEND SERVICE
# ============================================================================

section "PART 2: BACKEND SERVICE (SPRING BOOT 3.2)"

explanation "
The backend is a REST API built with Spring Boot 3.2, providing user management
functionality with PostgreSQL integration.
"

code_block "cat backend/pom.xml | head -30"
explanation "
pom.xml is Maven's configuration file. Let's understand key components:

WHAT WE SEE:
  1. Project metadata: name, version (1.0.0), description
  2. Parent POM: spring-boot-starter-parent (3.2.0)
     - Provides Spring Boot defaults and dependency management
  3. Properties: java.version=17, project.build.sourceEncoding=UTF-8
  4. Dependencies (explained below)

IMPORTANT DEPENDENCIES:
  • spring-boot-starter-web
    → Includes: Tomcat, Spring Web MVC, Jackson
    → Provides: RESTful API capabilities
  
  • spring-boot-starter-data-jpa
    → Includes: Hibernate ORM, Spring Data
    → Provides: Database access with object-relational mapping
  
  • spring-boot-starter-validation
    → Provides: Input validation with @NotNull, @Email, etc.
  
  • springdoc-openapi
    → Provides: Swagger UI and OpenAPI documentation at /swagger-ui.html
  
  • spring-boot-starter-actuator
    → Provides: Monitoring endpoints at /actuator
    → Includes: /health, /metrics, /prometheus endpoints
  
  • micrometer-registry-prometheus
    → Provides: Prometheus metrics export for monitoring
  
  • postgresql
    → JDBC driver for PostgreSQL database connection
"

code_block "cat backend/src/main/java/com/example/BackendApplication.java"
explanation "
THE APPLICATION ENTRY POINT:

@SpringBootApplication
  → Enables auto-configuration, component scanning, and bean definition

@OpenAPIDefinition
  → Generates OpenAPI/Swagger documentation automatically
  → Provides API documentation at /swagger-ui.html

public static void main(String[] args)
  → The JVM entry point
  → Calls SpringApplication.run() to start the embedded Tomcat server
"

code_block "cat backend/src/main/java/com/example/model/User.java"
explanation "
THE DATA MODEL - JPA ENTITY:

@Entity
  → Marks this as a persistent entity (database table)
  → Creates 'users' table in PostgreSQL

@Id @GeneratedValue
  → Auto-incrementing primary key
  → Each user gets a unique ID starting from 1

@Column(unique = true)
  → Email must be unique across all users
  → Database enforces this constraint

@NotBlank, @Email
  → Validation annotations
  → Spring validates these before saving to database

@Temporal(TemporalType.TIMESTAMP)
  → Stores creation and update timestamps automatically
  
@CreationTimestamp, @UpdateTimestamp
  → Lombok annotations automatically set these timestamps

LIFECYCLE HOOKS:
  @PrePersist: Called before INSERT
  @PreUpdate: Called before UPDATE
"

code_block "cat backend/src/main/java/com/example/repository/UserRepository.java"
explanation "
THE DATA ACCESS LAYER - REPOSITORY PATTERN:

extends JpaRepository<User, Long>
  → Provides CRUD operations automatically
  → User = entity type, Long = primary key type

Custom Methods:
  findByEmail(String email)
    → Generated by Spring Data from method name
    → Executes: SELECT * FROM users WHERE email = ?
  
  existsByEmail(String email)
    → Checks if email already exists
    → Prevents duplicate registrations

NO SQL REQUIRED!
  → Spring Data generates SQL automatically
  → Type-safe queries
  → Protection against SQL injection
"

code_block "cat backend/src/main/java/com/example/controller/UserController.java"
explanation "
THE REST API ENDPOINTS:

@RestController
  → Returns JSON responses automatically
  → Combines @Controller + @ResponseBody

@RequestMapping(\"/api/v1/users\")
  → Base path for all endpoints
  → Versioning with /v1 prevents breaking changes

ENDPOINTS PROVIDED:
  
  1. POST /api/v1/users
     → Create new user
     → Input: User JSON { name, email, phone, message }
     → Output: Created user with ID
  
  2. GET /api/v1/users
     → List all users (paginated)
     → Query params: page, size, sort
     → Output: Page of users
  
  3. GET /api/v1/users/{id}
     → Get user by ID
     → Output: Single user or 404 error
  
  4. GET /api/v1/users/email/{email}
     → Get user by email
     → Output: Single user or 404 error
  
  5. PUT /api/v1/users/{id}
     → Update existing user
     → Input: Updated user data
     → Output: Updated user
  
  6. DELETE /api/v1/users/{id}
     → Delete user by ID
     → Output: 204 No Content or 404 error

ERROR HANDLING:
  → @ExceptionHandler catches errors automatically
  → Returns proper HTTP status codes
  → Sends JSON error responses
"

code_block "cat backend/src/main/resources/application.yml"
explanation "
APPLICATION CONFIGURATION:

spring.datasource
  → Database connection settings
  → url: jdbc:postgresql://localhost:5432/krishna_db
  → username/password: PostgreSQL credentials
  → hikari.maximum-pool-size: Connection pooling

spring.jpa.hibernate
  → ORM (Object-Relational Mapping) settings
  → ddl-auto: validate (don't modify schema on startup)
  → show-sql: false (don't log SQL in production)

management.endpoints
  → Actuator endpoints for monitoring
  → /health: Application health status
  → /metrics: Application metrics
  → /prometheus: Prometheus metrics export

springdoc.swagger-ui
  → Swagger UI configuration
  → Accessible at http://localhost:8080/swagger-ui.html
"

# ============================================================================
# PART 3: FRONTEND SERVICE
# ============================================================================

section "PART 3: FRONTEND SERVICE (REACT 18 + TYPESCRIPT)"

explanation "
The frontend is a modern React 18 application with TypeScript for type safety.
It provides a user interface to interact with the backend API.
"

code_block "cat frontend/package.json"
explanation "
DEPENDENCIES EXPLAINED:

react@18.2.0
  → Core React library for building UI components
  → Provides hooks: useState, useEffect, etc.

typescript@5.0.0
  → Adds type checking to JavaScript
  → Catches errors at compile time
  → Improves code quality and IDE support

react-router-dom
  → Client-side routing (URL-based navigation)
  → Provides: BrowserRouter, Routes, Route components

axios
  → HTTP client for making API calls
  → Replaces fetch API with better error handling
  → Intercept requests/responses

tailwindcss
  → Utility-first CSS framework
  → Rapidly build custom designs
  → No writing custom CSS

@tailwindcss/forms
  → Pre-styled form components
  → Consistent form appearance

postcss & autoprefixer
  → Transform CSS (Tailwind compilation)
  → Add vendor prefixes for browser compatibility

BUILD SCRIPTS:
  • npm start        → Development server with hot reload
  • npm run build    → Production build (minified)
  • npm test         → Run tests with Jest
"

code_block "cat frontend/src/App.tsx"
explanation "
THE MAIN APPLICATION COMPONENT:

useState(users, setUsers)
  → State hook to store users from API
  → Triggers re-render when users change

useEffect(fetchUsers, [])
  → Side effect hook runs after render
  → Empty dependency array = run once on mount
  → Fetches users from backend API

AXIOS API CALLS:

axios.get('/api/v1/users')
  → Fetch all users
  → Returns Promise with user data

axios.post('/api/v1/users', newUser)
  → Create new user
  → Sends user data to backend

axios.put(`/api/v1/users/\${id}`, updatedUser)
  → Update user
  → Uses template literal for user ID

axios.delete(`/api/v1/users/\${id}`)
  → Delete user
  → No response body expected

ERROR HANDLING:
  → catch(error) block handles API errors
  → Shows user-friendly error messages
  → Prevents application crash

UI COMPONENTS:

Form Section:
  → Input fields for creating/updating users
  → onSubmit handler sends data to backend

Users List:
  → Map through users array
  → Render each user with Edit/Delete buttons
  → Update local state on modification

Health Status:
  → Shows API connection status
  → Green = backend is running
  → Red = backend is down
"

code_block "cat frontend/tailwind.config.js"
explanation "
TAILWIND CSS CONFIGURATION:

content: ['./src/**/*.{js,jsx,ts,tsx}']
  → Tells Tailwind which files to scan for CSS classes
  → Only includes used classes in production (tree-shaking)

theme.extend
  → Customize Tailwind's default theme
  → Add custom colors, spacing, fonts, etc.

TAILWIND BENEFITS:
  • No custom CSS writing needed
  • Consistent design system
  • Smaller bundle size (only used styles included)
  • Dark mode support out of the box
  • Mobile-first responsive design
"

code_block "cat frontend/nginx.conf"
explanation "
NGINX CONFIGURATION FOR PRODUCTION:

server {
  listen 80;           → Listen on port 80 (HTTP)
  server_name _;       → Accept all hostnames
  
  root /usr/share/nginx/html;  → Static files location
}

location / {
  try_files \$uri \$uri/ /index.html;
}
  → Single Page Application (SPA) routing
  → All routes redirect to index.html
  → React Router handles routing in browser

location /api/ {
  proxy_pass http://backend:8080;  → Reverse proxy to backend
  proxy_set_header Host \$host;     → Pass original host header
  proxy_set_header X-Real-IP \$remote_addr;
}
  → Routes API calls to backend service
  → Allows frontend and backend to share same origin
  → Solves CORS issues in production

gzip on; gzip_types text/plain application/json;
  → Compress responses (smaller file sizes)
  → Faster load times

NGINX BENEFITS:
  • Reverse proxy to backend
  • Gzip compression
  • Static file caching
  • Security headers
"

# ============================================================================
# PART 4: DATABASE SERVICE
# ============================================================================

section "PART 4: DATABASE SERVICE (POSTGRESQL 15)"

explanation "
PostgreSQL is the persistent data layer. All user data is stored here.
"

code_block "cat database/init.sql"
explanation "
DATABASE SCHEMA INITIALIZATION:

CREATE TABLE users (
  id SERIAL PRIMARY KEY,
    → Auto-incrementing integer
    → Unique identifier for each user
  
  name VARCHAR(255) NOT NULL,
    → Text field, required
    → Maximum 255 characters
  
  email VARCHAR(255) NOT NULL UNIQUE,
    → Text field, required, must be unique
    → Database enforces uniqueness at data level
  
  phone VARCHAR(20),
    → Optional phone number
  
  message TEXT,
    → Long text field for message/notes
  
  created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    → Automatically set to current time on INSERT
  
  updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    → Updated to current time on INSERT or UPDATE
}

INDEXES:
  CREATE INDEX idx_email ON users(email);
    → Speed up email lookups
    → Useful for findByEmail queries

  CREATE INDEX idx_created_at ON users(created_at DESC);
    → Sort users by creation time efficiently
"

code_block "cat database/init.sql | tail -20"
explanation "
SAMPLE DATA:

INSERT INTO users (name, email, phone)
  → Pre-populate database with test data
  → Useful for development and testing
  → Demonstrates data format
"

# ============================================================================
# PART 5: DOCKERIZATION
# ============================================================================

section "PART 5: DOCKERIZATION - CONTAINER IMAGES"

explanation "
Docker packages each service into isolated containers. Each service has its
own Dockerfile for building images.
"

code_block "cat backend/Dockerfile"
explanation "
BACKEND DOCKERFILE - MULTI-STAGE BUILD:

FROM maven:3.9 as builder
  → First stage: Build stage using Maven image
  → 'as builder' labels this stage for reference

WORKDIR /app
  → Set working directory inside container

COPY pom.xml . && COPY src ./src
  → Copy source code into container

RUN mvn clean package
  → Build JAR file
  → Maven downloads dependencies
  → Compiles Java code
  → Runs tests
  → Creates target/app.jar

FROM eclipse-temurin:17-jre-alpine
  → Second stage: Runtime using JRE image
  → Alpine = minimal Linux (smaller image)
  → Only includes Java Runtime Environment (not tools)

WORKDIR /app
RUN addgroup -g 999 app && adduser -D -u 999 -G app app
  → Create non-root user 'app'
  → Security: Containers run as app user, not root

COPY --from=builder /app/target/app.jar .
  → Copy JAR from builder stage
  → Only copy final artifact (not source code)

HEALTHCHECK --interval=10s --timeout=5s
  → Check container health every 10 seconds
  → Timeout after 5 seconds
  → Kubernetes uses this for readiness probes

USER app
EXPOSE 8080
CMD [\"java\", \"-jar\", \"app.jar\"]
  → Run application on startup

MULTI-STAGE BUILD BENEFITS:
  • Smaller final image (no Maven, no source code)
  • Builder stage: 1.5GB (with Maven and JDK)
  • Runtime stage: ~400MB (only JRE and JAR)
  • Security: Only Java runtime included
"

code_block "cat frontend/Dockerfile"
explanation "
FRONTEND DOCKERFILE - MULTI-STAGE BUILD:

FROM node:20 as builder
  → Build stage: Node.js image

WORKDIR /app
COPY package*.json ./
RUN npm ci
  → npm ci = clean install (deterministic)
  → Installs exact versions from package-lock.json

COPY . .
RUN npm run build
  → Create optimized production build
  → Minifies JavaScript/CSS
  → Creates /app/build directory

FROM nginx:alpine
  → Runtime stage: Lightweight Nginx server

COPY --from=builder /app/build /usr/share/nginx/html
  → Copy built static files to Nginx

COPY nginx.conf /etc/nginx/conf.d/default.conf
  → Configure Nginx (reverse proxy, routing, etc.)

HEALTHCHECK --interval=10s
  → Check if Nginx is responding

EXPOSE 80
  → Listen on port 80

MULTI-STAGE BUILD BENEFITS:
  • Builder stage: 2GB (with Node.js)
  • Runtime stage: 40MB (only Nginx)
  • Fast delivery: Pre-built static files
  • Security: No source code in runtime image
"

code_block "cat database/Dockerfile"
explanation "
DATABASE DOCKERFILE:

FROM postgres:15-alpine
  → Use official PostgreSQL image
  → Alpine = minimal Linux (~200MB total)

COPY init.sql /docker-entrypoint-initdb.d/01-init.sql
  → Automatically runs init.sql on first startup
  → Creates schema and sample data

HEALTHCHECK --interval=10s
  → Check database connectivity
  → pg_isready command tests connection

EXPOSE 5432
  → Listen on PostgreSQL port

BENEFITS:
  • Automatically initializes schema
  • Health checks for Kubernetes
  • Persistent data with volumes
"

# ============================================================================
# PART 6: CI/CD PIPELINES
# ============================================================================

section "PART 6: CI/CD PIPELINES (JENKINS)"

explanation "
CI/CD (Continuous Integration/Continuous Delivery) automates:
  • Building code
  • Running tests
  • Scanning for vulnerabilities
  • Building Docker images
  • Pushing to registry
  • Deploying to Kubernetes

Each service has its own independent pipeline.
"

code_block "cat backend/Jenkinsfile | head -50"
explanation "
BACKEND JENKINS PIPELINE STAGES:

Stage 1: Checkout
  → git clone the repository
  → Ensures latest code

Stage 2: Build
  → mvn clean package
  → Compiles Java code
  → Downloads dependencies
  → Creates JAR file

Stage 3: Unit Tests
  → mvn test
  → Runs JUnit tests
  → Ensures code quality

Stage 4: Code Quality Analysis
  → sonar:sonar (SonarQube)
  → Static code analysis
  → Checks: bugs, code smells, duplicates
  → Generates quality report

Stage 5: Build Docker Image
  → docker build -f backend/Dockerfile
  → Creates container image
  → Tags with build number and commit hash

Stage 6: Security Scan
  → trivy image (vulnerability scanning)
  → Scans for known vulnerabilities
  → Fails if critical issues found

Stage 7: Push to Registry
  → docker push
  → Uploads image to Docker registry
  → Makes image available for deployment

Stage 8: Deploy Staging
  → kubectl set image
  → Updates staging namespace
  → Tests in production-like environment

PIPELINE BENEFITS:
  • Automated testing catches bugs early
  • Security scanning prevents vulnerabilities
  • Consistent deployment process
  • Fast feedback to developers
"

code_block "cat frontend/Jenkinsfile | head -50"
explanation "
FRONTEND JENKINS PIPELINE:

Similar stages to backend:
  1. Checkout
  2. Install Dependencies (npm ci)
  3. Lint & Format Check (eslint)
  4. Build (npm run build)
  5. Unit Tests (jest)
  6. Code Quality (SonarQube)
  7. Build Docker Image
  8. Security Scan (Trivy)
  9. Push to Registry
  10. Deploy Staging
  11. E2E Tests (end-to-end)
  12. Deploy Production (manual approval)

ADDITIONAL CHECKS FOR FRONTEND:
  • Linting checks code style
  • E2E tests verify user workflows
  • Visual regression testing (optional)
"

code_block "cat database/Jenkinsfile | head -50"
explanation "
DATABASE JENKINS PIPELINE:

Database-specific stages:
  1. Checkout
  2. Validate Schema
     → Checks SQL syntax in init.sql
     → Ensures valid table definitions
  
  3. Build Docker Image
     → Creates PostgreSQL container
  
  4. Test Database Image
     → Starts container
     → Tests schema initialization
     → Verifies connectivity
  
  5. Security Scan
     → Scans for vulnerabilities in base image
  
  6. Push to Registry
  
  7. Deploy Staging
  
  8. Health Check
     → Verifies database is running
     → Tests connectivity from pods
  
  9. Deploy Production
"

explanation "
INDEPENDENT PIPELINE BENEFITS:

  ✓ Services deploy independently
  ✓ Backend updates don't affect frontend
  ✓ Parallel execution (all 3 can build simultaneously)
  ✓ Service-specific secrets and credentials
  ✓ Different deployment schedules
  ✓ Easier debugging and troubleshooting
"

# ============================================================================
# PART 7: KUBERNETES DEPLOYMENT
# ============================================================================

section "PART 7: KUBERNETES ORCHESTRATION"

explanation "
Kubernetes manages containers at scale:
  • Scheduling pods on nodes
  • Managing networking
  • Handling storage
  • Auto-scaling
  • Self-healing
  • Rolling updates

The k8s/ directory contains 14 manifest files.
"

code_block "cat k8s/01-namespace.yml"
explanation "
NAMESPACE - Logical isolation within cluster

kind: Namespace
metadata:
  name: krishna-devops

BENEFITS:
  • Isolates resources from other teams
  • Can have separate quotas and policies
  • Enables multi-tenancy
  • Prevents accidental changes to other resources
"

code_block "cat k8s/02-configmap.yml"
explanation "
CONFIGMAP - Non-secret configuration data

kind: ConfigMap
  Store configuration as key-value pairs
  
DATABASE_HOST: postgres.krishna-devops.svc.cluster.local
  → Internal Kubernetes DNS name
  → postgres = service name
  → krishna-devops = namespace
  → svc.cluster.local = Kubernetes domain

BENEFITS:
  • Separate config from container image
  • Change config without rebuilding image
  • Support multiple environments (dev/staging/prod)
"

code_block "cat k8s/03-secrets.yml"
explanation "
SECRETS - Store sensitive data encrypted

kind: Secret
metadata:
  name: db-secret
type: Opaque
  Opaque = arbitrary data
  data is base64 encoded (not encrypted by default)

DATABASE_USERNAME: postgres
DATABASE_PASSWORD: postgres

IMPORTANT SECURITY NOTE:
  • Base64 is encoding, NOT encryption
  • For production, use proper secret encryption:
    - etcd encryption
    - External secret management (Vault, AWS Secrets Manager)
    - RBAC to limit access

BENEFITS:
  • Keeps secrets out of Git
  • Centralized secret management
  • Audit trail of access
"

code_block "cat k8s/04-postgres-pvc.yml"
explanation "
PERSISTENTVOLUMECLAIM - Request storage

kind: PersistentVolumeClaim
metadata:
  name: postgres-pvc
spec:
  accessModes:
    - ReadWriteOnce  → Single pod can read and write
  resources:
    requests:
      storage: 10Gi   → Request 10GB of storage
  storageClassName: fast-storage → Use fast-storage class

BENEFITS:
  • Pod can be restarted without losing data
  • Storage lives beyond pod lifecycle
  • Can grow storage size later
"

code_block "cat k8s/05-postgres-deployment.yml | head -40"
explanation "
DEPLOYMENT - Manages pod replicas

kind: Deployment
metadata:
  name: postgres
spec:
  replicas: 1  → Run 1 instance of PostgreSQL
  
  selector:
    matchLabels:
      app: postgres  → Select pods with this label
  
  template:
    metadata:
      labels:
        app: postgres  → Pod label
    spec:
      containers:
      - name: postgres
        image: postgres:15-alpine  → Container image
        env:
        - name: POSTGRES_DB
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: DATABASE_NAME
              → Get value from ConfigMap
        
        ports:
        - containerPort: 5432  → Container listens on 5432
        
        resources:
          requests:
            memory: \"1Gi\"
            cpu: \"500m\"
          limits:
            memory: \"2Gi\"
            cpu: \"1000m\"
        
        livenessProbe:  → Is container alive?
          exec:
            command: [\"pg_isready\", \"-U\", \"postgres\"]
          initialDelaySeconds: 10
          periodSeconds: 10
        
        readinessProbe:  → Is container ready for traffic?
          exec:
            command: [\"pg_isready\", \"-U\", \"postgres\"]
          initialDelaySeconds: 5
          periodSeconds: 5

HEALTH PROBES:
  • Liveness: Restarts container if fails
  • Readiness: Removes pod from service if fails
  • Both prevent serving traffic to unhealthy pods
"

code_block "cat k8s/07-backend-deployment.yml | head -40"
explanation "
BACKEND DEPLOYMENT:

kind: Deployment
metadata:
  name: backend
spec:
  replicas: 3  → Run 3 backend pods (for high availability)
  
  strategy:
    type: RollingUpdate
    rollingUpdate:
      maxSurge: 1        → Allow 1 extra pod during update
      maxUnavailable: 0  → Keep all pods available
      → Zero-downtime deployments
  
  template:
    metadata:
      labels:
        app: backend
    spec:
      containers:
      - name: backend
        image: krishna-backend:latest
        ports:
        - containerPort: 8080
        
        env:
        - name: DB_HOST
          valueFrom:
            configMapKeyRef:
              name: app-config
              key: DATABASE_HOST
        
        - name: DB_PASSWORD
          valueFrom:
            secretKeyRef:
              name: db-secret
              key: DATABASE_PASSWORD
              → Get from secret (not in image)
        
        resources:
          requests:
            memory: \"512Mi\"
            cpu: \"250m\"
          limits:
            memory: \"1Gi\"
            cpu: \"500m\"

ROLLING UPDATE BENEFITS:
  • Zero downtime deployments
  • Can rollback if issues occur
  • Gradual rollout (1 pod at a time)
"

code_block "cat k8s/09-ingress.yml"
explanation "
INGRESS - External HTTP(S) routing

kind: Ingress
metadata:
  name: app-ingress
spec:
  rules:
  - host: krishnadevops.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: frontend  → Route to frontend service
            port:
              number: 3000
  
  - host: api.krishnadevops.local
    http:
      paths:
      - path: /
        pathType: Prefix
        backend:
          service:
            name: backend   → Route to backend service
            port:
              number: 8080

INGRESS BENEFITS:
  • Single entry point for external traffic
  • Hostname-based routing
  • Path-based routing
  • SSL/TLS termination
  • Load balancing across pods
"

code_block "cat k8s/10-hpa.yml"
explanation "
HORIZONTAL POD AUTOSCALER - Auto-scaling

kind: HorizontalPodAutoscaler
metadata:
  name: backend-hpa
spec:
  scaleTargetRef:
    kind: Deployment
    name: backend
  
  minReplicas: 3    → Always keep at least 3 pods
  maxReplicas: 10   → Never exceed 10 pods
  
  metrics:
  - type: Resource
    resource:
      name: cpu
      target:
        type: Utilization
        averageUtilization: 70  → Add pod if CPU > 70%
  
  - type: Resource
    resource:
      name: memory
      target:
        type: Utilization
        averageUtilization: 80  → Add pod if Memory > 80%

AUTOSCALING BENEFITS:
  • Handles traffic spikes automatically
  • Saves costs by scaling down during low traffic
  • No manual intervention needed
  • Based on actual resource usage
"

code_block "cat k8s/11-pdb.yml"
explanation "
POD DISRUPTION BUDGET - Ensure availability

kind: PodDisruptionBudget
metadata:
  name: backend-pdb
spec:
  minAvailable: 2  → Always keep at least 2 backend pods running
  selector:
    matchLabels:
      app: backend

PROTECTS AGAINST:
  • Node maintenance
  • Cluster upgrades
  • Evictions due to resource pressure
  → Ensures high availability even during cluster changes
"

code_block "cat k8s/13-storage-classes.yml"
explanation "
STORAGE CLASSES - Dynamic storage provisioning

kind: StorageClass
metadata:
  name: fast-storage
spec:
  provisioner: kubernetes.io/aws-ebs
  parameters:
    type: gp3
    iops: 3000
  reclaimPolicy: Delete
  allowVolumeExpansion: true

BENEFITS:
  • Different storage types for different needs
  • Fast-storage for databases (high IOPS)
  • Slow-storage for logs (cost-optimized)
  • Can add more storage without downtime
"

# ============================================================================
# PART 8: ADVANCED SCHEDULING
# ============================================================================

section "PART 8: ADVANCED POD SCHEDULING"

explanation "
Kubernetes provides advanced scheduling features to control
where pods run and how they interact.
"

code_block "cat k8s/14-advanced-scheduling.yml | head -100"
explanation "
ADVANCED SCHEDULING CONCEPTS:

1. TAINTS & TOLERATIONS

Taints (applied to nodes):
  kubectl taint nodes node-1 gpu=true:NoSchedule
  → Only pods with matching tolerations can schedule here

Three effects:
  • NoSchedule: Don't schedule new pods
  • NoExecute: Evict existing pods
  • PreferNoSchedule: Try not to schedule (soft)

Tolerations (in pod spec):
  tolerations:
  - key: gpu
    operator: Equal
    value: \"true\"
    effect: NoSchedule
  → Pod will tolerate this taint

USE CASES:
  • Dedicated nodes for specific workloads
  • GPU nodes for machine learning
  • Database nodes with special hardware
  • Licensing restrictions
"

explanation "
2. NODE AFFINITY

Controls which nodes pods schedule on based on node labels.

Two types:

a) requiredDuringSchedulingIgnoredDuringExecution
   → Pod MUST match these labels
   → Hard constraint
   → Pod won't be scheduled if no matching nodes

b) preferredDuringSchedulingIgnoredDuringExecution
   → Pod SHOULD match these labels (weight-based)
   → Soft constraint
   → Pod can be scheduled elsewhere if needed

EXAMPLE:
  nodeAffinity:
    requiredDuringScheduling:
      nodeSelectorTerms:
      - matchExpressions:
        - key: tier
          operator: In
          values: [production]
  → Schedule only on production tier nodes
"

explanation "
3. POD AFFINITY

Attracts pods together on the same node (co-location).

USE CASES:
  • Frontend and backend on same node
  • Services that communicate frequently
  • Reduce network latency

EXAMPLE:
  podAffinity:
    requiredDuringScheduling:
      - labelSelector:
          matchLabels:
            app: backend
        topologyKey: kubernetes.io/hostname
  → Schedule on same node as backend pod
"

explanation "
4. POD ANTI-AFFINITY

Keeps pods apart on different nodes (distribution).

USE CASES:
  • High availability (multiple pods on different nodes)
  • Spread load across cluster
  • Prevent single point of failure

EXAMPLE:
  podAntiAffinity:
    requiredDuringScheduling:
      - labelSelector:
          matchLabels:
            app: backend
        topologyKey: kubernetes.io/hostname
  → Never schedule on same node as another backend pod

TOPOLOGY KEY:
  • kubernetes.io/hostname = different nodes
  • topology.kubernetes.io/zone = different zones
  • topology.kubernetes.io/region = different regions
"

# ============================================================================
# PART 9: COMPLETE WORKFLOW
# ============================================================================

section "PART 9: COMPLETE DEPLOYMENT WORKFLOW"

explanation "
Here's the complete journey from code to production:
"

cat << 'EOF'

┌─────────────────────────────────────────────────────────────────────────┐
│ WORKFLOW DIAGRAM                                                        │
├─────────────────────────────────────────────────────────────────────────┤

1. DEVELOPMENT PHASE
   ┌──────────────────┐
   │ Write Code       │
   └────────┬─────────┘
            │
   ┌────────▼─────────┐
   │ Commit to Git    │
   └────────┬─────────┘

2. CI/CD PHASE (Jenkins)
   ┌────────▼─────────┐
   │ Pipeline Trigger │
   └────────┬─────────┘
            │
   ┌────────▼─────────────┐      ┌─────────────────────┐
   │ Build & Test         │─────▶│ SonarQube Analysis  │
   └────────┬─────────────┘      └─────────────────────┘
            │
   ┌────────▼─────────────┐      ┌─────────────────────┐
   │ Build Docker Image   │─────▶│ Trivy Scan          │
   └────────┬─────────────┘      └─────────────────────┘
            │
   ┌────────▼──────────────────┐
   │ Push to Docker Registry   │
   └────────┬──────────────────┘

3. DEPLOYMENT PHASE (Kubernetes)
   ┌────────▼──────────────────┐
   │ Deploy to Staging         │
   └────────┬──────────────────┘
            │
   ┌────────▼──────────────────┐
   │ Manual Approval (optional)│
   └────────┬──────────────────┘
            │
   ┌────────▼──────────────────┐
   │ Deploy to Production      │
   └────────┬──────────────────┘
            │
   ┌────────▼──────────────────┐
   │ Rolling Update (3→4→3)    │
   │ Zero downtime deployment  │
   └────────┬──────────────────┘
            │
   ┌────────▼──────────────────┐
   │ Verify Health Checks      │
   │ Test API endpoints        │
   └──────────────────────────┘

4. OPERATIONS PHASE
   ┌────────────────────────────────────┐
   │ Auto-scaling (HPA)                 │
   │ - Monitors CPU/Memory usage        │
   │ - Scales between 3-10 replicas     │
   └────────┬───────────────────────────┘
            │
   ┌────────▼───────────────────────────┐
   │ Self-healing                       │
   │ - Restarts failed pods             │
   │ - Replaces lost nodes              │
   └────────┬───────────────────────────┘
            │
   ┌────────▼───────────────────────────┐
   │ Monitoring (Prometheus)            │
   │ - Metrics at /actuator/prometheus  │
   │ - Visualize in Grafana             │
   └────────────────────────────────────┘

EOF

# ============================================================================
# PART 10: KEY CONCEPTS SUMMARY
# ============================================================================

section "PART 10: KEY CONCEPTS & BEST PRACTICES"

explanation "
Let's review important concepts learned:
"

cat << 'EOF'

📚 MICROSERVICES ARCHITECTURE
   ✓ Three independent services: Backend, Frontend, Database
   ✓ Each service has its own team, deployment schedule
   ✓ Loose coupling, high cohesion
   ✓ Technology heterogeneity (different stacks)

🐳 CONTAINERIZATION
   ✓ Docker packages code, dependencies, configuration
   ✓ Multi-stage builds reduce image size
   ✓ Alpine base images = minimal overhead
   ✓ Health checks for monitoring

☸️  KUBERNETES ORCHESTRATION
   ✓ Scheduling: Taints, Tolerations, Node/Pod Affinity
   ✓ Networking: Services, Ingress
   ✓ Storage: PersistentVolumes, StorageClasses
   ✓ Auto-scaling: HPA based on metrics
   ✓ High Availability: Multiple replicas, PDB

🔄 CI/CD PIPELINES
   ✓ Automated testing catches bugs early
   ✓ Security scanning prevents vulnerabilities
   ✓ Independent pipelines for each service
   ✓ Staging environment for testing
   ✓ Manual approval for production

📊 MONITORING & OBSERVABILITY
   ✓ Health checks: Liveness & Readiness probes
   ✓ Metrics: Prometheus at /actuator/prometheus
   ✓ Logs: Centralized logging (ELK, Loki)
   ✓ Alerts: Notify on anomalies

🔐 SECURITY BEST PRACTICES
   ✓ Non-root users in containers
   ✓ Secrets management (not in code/image)
   ✓ RBAC (Role-based Access Control)
   ✓ Network policies
   ✓ Image scanning for vulnerabilities
   ✓ Least privilege principle

🎯 PERFORMANCE OPTIMIZATION
   ✓ Horizontal Pod Autoscaling
   ✓ Resource requests and limits
   ✓ Connection pooling (database)
   ✓ Caching strategies
   ✓ CDN for static files

EOF

# ============================================================================
# PART 11: HANDS-ON COMMANDS
# ============================================================================

section "PART 11: HANDS-ON COMMANDS FOR STUDENTS"

explanation "
Here are practical commands to interact with the system:
"

cat << 'EOF'

LOCAL DEVELOPMENT:

1. Start individual services:
   Backend:  cd backend && mvn spring-boot:run
   Frontend: cd frontend && npm install && npm start
   Database: docker run postgres:15-alpine

2. Test API:
   curl http://localhost:8080/api/v1/health
   curl http://localhost:8080/swagger-ui.html

3. Build Docker images:
   docker build -f backend/Dockerfile -t krishna-backend:v1.0 .
   docker build -f frontend/Dockerfile -t krishna-frontend:v1.0 .
   docker build -f database/Dockerfile -t krishna-database:v1.0 .

KUBERNETES COMMANDS:

4. Deploy to cluster:
   ./scripts/deploy-k8s.sh

5. Check deployments:
   kubectl get deployments -n krishna-devops
   kubectl get pods -n krishna-devops
   kubectl get svc -n krishna-devops

6. Scale services:
   kubectl scale deployment backend --replicas=5 -n krishna-devops

7. View logs:
   kubectl logs -f deployment/backend -n krishna-devops

8. Access services:
   kubectl port-forward svc/backend 8080:8080 -n krishna-devops
   kubectl port-forward svc/frontend 3000:3000 -n krishna-devops

9. Monitor resources:
   kubectl top nodes
   kubectl top pods -n krishna-devops

10. Troubleshooting:
    kubectl describe pod <pod-name> -n krishna-devops
    kubectl get events -n krishna-devops

SCHEDULING COMMANDS:

11. Apply taints to nodes:
    kubectl taint nodes node-1 gpu=true:NoSchedule
    kubectl taint nodes node-2 dedicated=backend:NoExecute

12. Label nodes:
    kubectl label nodes node-1 tier=production gpu=true
    kubectl label nodes node-2 database-node=true

13. View node labels and taints:
    kubectl get nodes --show-labels
    kubectl describe nodes | grep -A5 "Taints"

EOF

# ============================================================================
# CONCLUSION
# ============================================================================

section "CONCLUSION & NEXT STEPS"

success "You now understand the complete project!"

explanation "
WHAT YOU LEARNED:
  ✓ Microservices architecture (Backend, Frontend, Database)
  ✓ Containerization with Docker
  ✓ Kubernetes orchestration and advanced scheduling
  ✓ CI/CD pipelines with Jenkins
  ✓ Monitoring, scaling, and self-healing
  ✓ Best practices for production deployments

NEXT STEPS:
  1. Study each Dockerfile and understand multi-stage builds
  2. Review Jenkinsfile stages and understand CI/CD flow
  3. Examine Kubernetes manifests and see how they fit together
  4. Deploy to your own cluster and experiment
  5. Add new features to understand end-to-end deployment
  6. Set up monitoring and alerts
  7. Practice disaster recovery procedures

RESOURCES:
  • Official Documentation:
    - Spring Boot: https://spring.io/projects/spring-boot
    - React: https://react.dev/
    - PostgreSQL: https://www.postgresql.org/
    - Docker: https://docs.docker.com/
    - Kubernetes: https://kubernetes.io/docs/
    - Jenkins: https://www.jenkins.io/doc/

QUESTIONS TO THINK ABOUT:
  1. Why use multi-stage Docker builds?
  2. What's the difference between Taints and Node Affinity?
  3. How does Pod Anti-Affinity ensure high availability?
  4. Why do we need both Liveness and Readiness probes?
  5. How does HPA decide when to scale?

CHALLENGES:
  1. Add a cache layer (Redis) to the architecture
  2. Implement blue-green deployments
  3. Set up monitoring with Prometheus and Grafana
  4. Add API rate limiting to protect backends
  5. Implement database backups and recovery

"

header "THANK YOU FOR LEARNING!"

exit 0
