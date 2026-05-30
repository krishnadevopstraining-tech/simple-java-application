# Krishna DevOps - Multi-Service CI/CD Setup
#
# This project uses INDEPENDENT pipelines for each service:
# 
# 📦 BACKEND SERVICE
#    Pipeline File: backend/Jenkinsfile
#    Triggers: Changes in /backend/** or tags matching v*
#    Stages: Build → Test → SonarQube → Docker Build → Security Scan → Push → Deploy
#
# 🎨 FRONTEND SERVICE  
#    Pipeline File: frontend/Jenkinsfile
#    Triggers: Changes in /frontend/** or tags matching v*
#    Stages: Build → Test → SonarQube → Docker Build → Security Scan → Push → Deploy
#
# SETUP INSTRUCTIONS:
#
# 1. Create two Jenkins Pipeline jobs:
#    - Job Name: "krishna-backend-pipeline"
#      Pipeline Definition: Pipeline script from SCM
#      SCM: git (this repo)
#      Script Path: backend/Jenkinsfile
#
#    - Job Name: "krishna-frontend-pipeline"
#      Pipeline Definition: Pipeline script from SCM
#      SCM: git (this repo)
#      Script Path: frontend/Jenkinsfile
#
# 2. Configure Credentials in Jenkins:
#    - docker-registry-url (Secret text): Your Docker registry URL
#    - docker-registry-username (Secret text): Docker username
#    - docker-registry-password (Secret text): Docker password
#    - sonar-host-url (Secret text): SonarQube server URL
#    - sonar-token (Secret text): SonarQube authentication token
#    - kubeconfig (Secret file): Kubernetes config for deployments
#
# 3. Configure GitHub Webhooks (optional):
#    Each service pipeline triggers independently based on file paths
#    - Backend pipeline triggers on: backend/**, pom.xml changes
#    - Frontend pipeline triggers on: frontend/**, package.json changes
#
# ENVIRONMENT VARIABLES:
#
# Backend Jenkinsfile uses:
#   - REGISTRY_URL
#   - REGISTRY_USERNAME
#   - REGISTRY_PASSWORD
#   - IMAGE_NAME: krishna-backend
#   - IMAGE_TAG: ${BUILD_NUMBER}
#   - SONAR_HOST_URL
#   - SONAR_TOKEN
#
# Frontend Jenkinsfile uses:
#   - REGISTRY_URL
#   - REGISTRY_USERNAME
#   - REGISTRY_PASSWORD
#   - IMAGE_NAME: krishna-frontend
#   - IMAGE_TAG: ${BUILD_NUMBER}
#   - SONAR_HOST_URL
#   - SONAR_TOKEN
#   - NODE_ENV: production
#
# KUBERNETES DEPLOYMENT:
#
# Both services deploy to:
#   - Staging: krishna-devops-staging namespace
#   - Production: krishna-devops namespace (manual approval required)
#
# INDIVIDUAL PIPELINE FEATURES:
#
# ✅ Service-specific builds
# ✅ Independent testing & quality checks
# ✅ Parallel execution capability
# ✅ Service-specific credentials
# ✅ Independent scaling & deployment
# ✅ Easier debugging & maintenance
# ✅ Flexible update schedules
#
# For detailed configuration, see:
#   - backend/README.md
#   - frontend/README.md
#   - DEPLOYMENT.md
