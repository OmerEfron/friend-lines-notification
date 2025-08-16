#!/bin/bash

# Friend Lines App - Docker Deployment Script
echo "🚀 Deploying Friend Lines App with Docker..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Build the Docker image
echo "🔨 Building Docker image..."
docker build -t friend-lines-app:latest .

if [ $? -ne 0 ]; then
    echo "❌ Docker build failed!"
    exit 1
fi

echo "✅ Docker image built successfully!"

# Stop existing container if running
echo "🛑 Stopping existing container..."
docker stop friend-lines-server 2>/dev/null || true
docker rm friend-lines-server 2>/dev/null || true

# Run the new container
echo "🚀 Starting new container..."
docker run -d \
    --name friend-lines-server \
    -p 3005:3005 \
    -e NODE_ENV=production \
    -e PORT=3005 \
    --restart unless-stopped \
    friend-lines-app:latest

if [ $? -eq 0 ]; then
    echo "✅ Container started successfully!"
    echo "🌐 Server is running at: http://localhost:3005"
    echo "📍 Health check: http://localhost:3005/health"
    echo ""
    echo "📋 Container status:"
    docker ps | grep friend-lines-server
    echo ""
    echo "📝 View logs: docker logs -f friend-lines-server"
    echo "🛑 Stop server: docker stop friend-lines-server"
else
    echo "❌ Failed to start container!"
    exit 1
fi
