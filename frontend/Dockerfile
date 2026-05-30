# Stage 1: Build frontend
FROM node:20-alpine AS frontend-build
WORKDIR /app
COPY frontend/package*.json ./
RUN npm ci
COPY frontend/src ./src
COPY frontend/public ./public
COPY frontend/*.js ./
COPY frontend/*.json ./
RUN npm run build

# Stage 2: Serve frontend with Nginx
FROM nginx:alpine
COPY frontend/nginx.conf /etc/nginx/nginx.conf
COPY --from=frontend-build /app/build /usr/share/nginx/html

# Health check
HEALTHCHECK --interval=30s --timeout=10s --start-period=10s --retries=3 \
  CMD wget -q -O - http://localhost:3000 || exit 1

EXPOSE 3000
CMD ["nginx", "-g", "daemon off;"]
