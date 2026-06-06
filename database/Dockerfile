# PostgreSQL 15 Database Service
# Multi-stage build for production-ready database image

FROM postgres:15-alpine as base

# Install required tools
RUN apk add --no-cache \
    curl \
    wget \
    postgresql-client

# Copy initialization script
COPY init.sql /docker-entrypoint-initdb.d/01-init.sql

# Create non-root user
RUN addgroup -g 999 postgres && \
    adduser -D -u 999 -G postgres postgres

# Health check
HEALTHCHECK --interval=10s --timeout=5s --start-period=5s --retries=5 \
    CMD pg_isready -U postgres -d krishna_db || exit 1

# Expose PostgreSQL port
EXPOSE 5432

# Database data volume
VOLUME ["/var/lib/postgresql/data"]

# Default entrypoint
ENTRYPOINT ["docker-entrypoint.sh"]

# Default command
CMD ["postgres"]

# Metadata labels
LABEL maintainer="Krishna DevOps Team"
LABEL description="PostgreSQL 15 Database Service for Krishna DevOps Multi-Service Application"
LABEL version="1.0.0"
LABEL org.opencontainers.image.source="https://github.com/krishnadevopstraining-tech/simple-java-application"
