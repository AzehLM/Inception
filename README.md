# Advanced Docker Concepts for 42 Inception Project

## Overview
This guide covers advanced Docker features that will significantly enhance your containerization skills and make your Inception project stand out. These concepts go beyond basic `docker run` and `docker-compose up` to provide production-ready, secure, and efficient solutions.

## 🔄 Docker Compose Watch Mode
**What it is**: Automatically rebuilds and restarts services when code changes are detected.

```yaml
# docker-compose.yml
services:
  web:
    build: .
    develop:
      watch:
        - action: rebuild
          path: ./src
        - action: sync
          path: ./static
          target: /app/static
```

**Usage**: `docker compose watch`
**Benefits**: Instant development feedback, no manual rebuilds needed.

## 🏥 Health Checks
**What it is**: Built-in monitoring to ensure containers are actually working, not just running.

```dockerfile
# In Dockerfile
HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:8080/health || exit 1
```

```yaml
# In docker-compose.yml
services:
  nginx:
    healthcheck:
      test: ["CMD", "curl", "-f", "http://localhost:80/"]
      interval: 30s
      timeout: 10s
      retries: 3
      start_period: 40s
```

**Benefits**: Automatic container restart on failure, better orchestration decisions.

## 🏗️ Multi-Stage Builds
**What it is**: Use multiple FROM statements to create optimized, smaller final images.

```dockerfile
# Build stage
FROM node:18-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN npm ci --only=production

# Production stage  
FROM node:18-alpine AS production
WORKDIR /app
COPY --from=builder /app/node_modules ./node_modules
COPY . .
EXPOSE 3000
CMD ["npm", "start"]
```

**Benefits**: Smaller images, better security (no build tools in production), faster deployments.

## 🚀 BuildKit Advanced Features
**What it is**: Modern build engine with advanced caching and parallel builds.

```dockerfile
# syntax=docker/dockerfile:1
FROM alpine

# Cache mount for package manager
RUN --mount=type=cache,target=/var/cache/apk \
    apk add --update git

# Secret mount (never stored in image)
RUN --mount=type=secret,id=api_key \
    curl -H "Authorization: $(cat /run/secrets/api_key)" api.example.com
```

**Enable with**: `DOCKER_BUILDKIT=1` or in daemon.json
**Benefits**: Faster builds, better caching, secrets handling, parallel execution.

## 🔒 Docker Secrets & Security
**What it is**: Secure way to handle sensitive data without embedding in images.

```yaml
# docker-compose.yml
services:
  db:
    image: postgres
    secrets:
      - db_password
    environment:
      POSTGRES_PASSWORD_FILE: /run/secrets/db_password

secrets:
  db_password:
    file: ./secrets/db_password.txt
```

**Security best practices**:
```dockerfile
# Run as non-root user
RUN addgroup -g 1001 -S nodejs
RUN adduser -S nextjs -u 1001
USER nextjs

# Use distroless images when possible
FROM gcr.io/distroless/nodejs18-debian11
```

## ⚡ Resource Constraints
**What it is**: Control CPU, memory, and I/O usage.

```yaml
services:
  web:
    deploy:
      resources:
        limits:
          cpus: '0.50'
          memory: 512M
        reservations:
          cpus: '0.25'
          memory: 256M
    ulimits:
      nofile: 65536
```

## 🔧 Init System in Containers
**What it is**: Proper signal handling and zombie process reaping.

```dockerfile
# Option 1: Use tini
RUN apk add --no-cache tini
ENTRYPOINT ["/sbin/tini", "--"]

# Option 2: Docker's built-in init
# docker run --init myimage
```

```yaml
# In compose
services:
  app:
    init: true
```

## 📊 Advanced Networking
**What it is**: Custom networks for service isolation and communication.

```yaml
services:
  frontend:
    networks:
      - web-tier
  
  backend:
    networks:
      - web-tier
      - database-tier
  
  database:
    networks:
      - database-tier

networks:
  web-tier:
    driver: bridge
  database-tier:
    internal: true  # No external access
```

## 💾 Volume Best Practices
**What it is**: Efficient data persistence and sharing strategies.

```yaml
services:
  app:
    volumes:
      # Named volume for data persistence
      - app_data:/var/lib/app
      # Bind mount for development (with consistency settings)
      - ./src:/app/src:cached
      # tmpfs for temporary files
      - type: tmpfs
        target: /tmp
        tmpfs:
          size: 100M

volumes:
  app_data:
    driver: local
    driver_opts:
      type: none
      o: bind
      device: /host/path/data
```

## 📱 Container Communication Patterns

```yaml
# Service dependencies with conditions
services:
  web:
    depends_on:
      db:
        condition: service_healthy
        restart: true
  
  db:
    healthcheck:
      test: ["CMD", "pg_isready", "-U", "postgres"]
```

## 🔍 Monitoring & Debugging

```bash
# Monitor resource usage
docker stats

# Stream container events
docker events --filter container=mycontainer

# Inspect container processes
docker exec container_name ps aux

# Export container filesystem changes
docker diff container_name
```

## 🛠️ Development Workflow Commands

```bash
# Build with build-time arguments
docker build --build-arg NODE_ENV=development .

# Override compose file for different environments
docker compose -f docker-compose.yml -f docker-compose.dev.yml up

# Scale services
docker compose up --scale web=3

# View service logs with timestamps
docker compose logs -f --timestamps web
```

## 🎯 Pro Tips for Your Inception Project

1. **Use `.dockerignore`** to exclude unnecessary files from build context
2. **Implement graceful shutdown** handling in your applications
3. **Use specific image tags** instead of `latest` for reproducibility
4. **Enable Docker content trust** for image verification in production
5. **Implement proper logging** strategies (stdout/stderr, log drivers)
6. **Use labels** for better container organization and metadata

```dockerfile
# Example of comprehensive Dockerfile
# syntax=docker/dockerfile:1
FROM node:18-alpine AS base
WORKDIR /app

# Install dependencies
FROM base AS deps
COPY package*.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci --only=production

# Build application
FROM base AS build
COPY package*.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm ci
COPY . .
RUN npm run build

# Production image
FROM node:18-alpine AS runner
RUN addgroup --system --gid 1001 nodejs
RUN adduser --system --uid 1001 nextjs

WORKDIR /app
COPY --from=deps --chown=nextjs:nodejs /app/node_modules ./node_modules
COPY --from=build --chown=nextjs:nodejs /app/dist ./dist

USER nextjs
EXPOSE 3000

HEALTHCHECK --interval=30s --timeout=3s --start-period=5s --retries=3 \
  CMD curl -f http://localhost:3000/health || exit 1

CMD ["npm", "start"]
```

## 🚀 Getting Started

1. Enable BuildKit: `export DOCKER_BUILDKIT=1`
2. Start with health checks for all your services
3. Implement watch mode for development
4. Use multi-stage builds for optimized images
5. Add proper resource constraints
6. Implement security best practices from day one

These advanced concepts will make your Inception project production-ready and demonstrate deep Docker expertise!
