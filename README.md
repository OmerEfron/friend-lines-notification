# Friend Lines App Server

A simple Express.js server with a health endpoint, following Express.js best practices.

## Features

- ✅ Express.js server with proper middleware order
- ✅ Health endpoint for monitoring
- ✅ Notification creation endpoint
- ✅ Modular route structure with controllers
- ✅ Request logging middleware
- ✅ Centralized error handling
- ✅ 404 route handling
- ✅ Environment-based configuration
- ✅ Docker support with multi-stage builds

## Installation

### Local Development
```bash
npm install
```

### Docker Deployment
```bash
# Build and run with Docker Compose (Recommended)
docker-compose up -d

# Or build and run manually
docker build -t friend-lines-app .
docker run -p 3005:3005 friend-lines-app
```

## Usage

### Local Development
```bash
# Start the server
npm start

# Development mode (with auto-restart)
npm run dev
```

### Docker Commands
```bash
# Build Docker image
npm run docker:build

# Run container
npm run docker:run

# Start with Docker Compose
npm run docker:compose:up

# Stop Docker Compose
npm run docker:compose:down

# View logs
npm run docker:compose:logs
```

## Endpoints

### Health Check
- **GET** `/health` - Server health status
- Returns server status, timestamp, uptime, and environment

### Root
- **GET** `/` - Server information
- Returns server details and available endpoints

### Notification
- **POST** `/notification/create-new-notification` - Create a new notification
- **Body**: `{"content": "string"}`
- **Returns**: `{"message": "new content received: <content>", "timestamp": "..."}`

## Configuration

- **Port**: 3005 (configurable via `PORT` environment variable)
- **Environment**: Development (configurable via `NODE_ENV`)

## Server Details

- **Port**: 3005
- **Health Check**: http://localhost:3005/health
- **Server**: http://localhost:3005

## Docker Deployment

### Quick Start
```bash
# Clone and deploy in one command
git clone <your-repo>
cd friend-lines-app
docker-compose up -d
```

### Docker Features
- **Multi-stage build** for optimized production images
- **Alpine Linux** base for smaller image size
- **Non-root user** for security
- **Health checks** for container monitoring
- **Environment variables** support
- **Port mapping** (3005:3005)

### Production Deployment
```bash
# Build production image
docker build -t friend-lines-app:latest .

# Run with environment variables
docker run -d \
  --name friend-lines-server \
  -p 3005:3005 \
  -e NODE_ENV=production \
  -e PORT=3005 \
  --restart unless-stopped \
  friend-lines-app:latest
```

### Docker Compose
```bash
# Start services
docker-compose up -d

# View logs
docker-compose logs -f

# Stop services
docker-compose down

# Rebuild and restart
docker-compose up -d --build
```

## Project Structure

```
friend-lines-app/
├── server.js                    # Main server file
├── package.json                 # Dependencies and scripts
├── Dockerfile                   # Docker image configuration
├── docker-compose.yml           # Docker Compose configuration
├── .dockerignore               # Docker build exclusions
├── routes/                      # Route modules
│   ├── index.js                # Routes registry
│   └── notificationRoutes.js   # Notification routes
├── controllers/                 # Business logic controllers
│   └── notificationController.js # Notification controller
└── README.md                   # This file
```

## Express.js Best Practices Implemented

- Proper middleware order (body parsers → custom middleware → routes → error handlers)
- Centralized error handling middleware
- Request logging
- Appropriate HTTP status codes
- Environment-based error messages
- Modular route structure with Express Router
- Separation of concerns (routes, controllers, business logic)
- Input validation for notification content
- Docker containerization with security best practices
