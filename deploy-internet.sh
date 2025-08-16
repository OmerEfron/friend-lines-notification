#!/bin/bash

# Friend Lines App - Internet Deployment Script
echo "🌐 Deploying Friend Lines App for Internet Access..."

# Check if Docker is running
if ! docker info > /dev/null 2>&1; then
    echo "❌ Docker is not running. Please start Docker and try again."
    exit 1
fi

# Check if ports 80 and 443 are available
echo "🔍 Checking port availability..."
if lsof -Pi :80 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "⚠️  Port 80 is already in use. You may need to stop other services."
fi

if lsof -Pi :443 -sTCP:LISTEN -t >/dev/null 2>&1; then
    echo "⚠️  Port 443 is already in use. You may need to stop other services."
fi

# Build the Docker image
echo "🔨 Building Docker image..."
docker build -t friend-lines-app:internet .

if [ $? -ne 0 ]; then
    echo "❌ Docker build failed!"
    exit 1
fi

echo "✅ Docker image built successfully!"

# Stop existing container if running
echo "🛑 Stopping existing container..."
docker stop friend-lines-server-prod 2>/dev/null || true
docker rm friend-lines-server-prod 2>/dev/null || true

# Run the new container with internet exposure
echo "🚀 Starting container for internet access..."
docker run -d \
    --name friend-lines-server-prod \
    -p 80:3005 \
    -p 443:3005 \
    -p 3005:3005 \
    -e NODE_ENV=production \
    -e PORT=3005 \
    -e HOST=0.0.0.0 \
    --restart unless-stopped \
    friend-lines-app:internet

if [ $? -eq 0 ]; then
    echo "✅ Container started successfully!"
    echo ""
    echo "🌐 Internet Access URLs:"
    echo "   HTTP:  http://YOUR_PUBLIC_IP:80"
    echo "   HTTPS: https://YOUR_PUBLIC_IP:443"
    echo "   Direct: http://YOUR_PUBLIC_IP:3005"
    echo ""
    echo "📍 Local Health Check: http://localhost:3005/health"
    echo ""
    echo "📋 Container status:"
    docker ps | grep friend-lines-server-prod
    echo ""
    echo "🔧 Management Commands:"
    echo "   View logs: docker logs -f friend-lines-server-prod"
    echo "   Stop server: docker stop friend-lines-server-prod"
    echo "   Restart: docker restart friend-lines-server-prod"
    echo ""
    echo "⚠️  IMPORTANT: Make sure to:"
    echo "   1. Configure your router's port forwarding (80, 443, 3005 → your machine)"
    echo "   2. Set up firewall rules to allow incoming traffic"
    echo "   3. Consider using a reverse proxy (nginx) for production"
    echo "   4. Set up SSL/TLS certificates for HTTPS"
else
    echo "❌ Failed to start container!"
    exit 1
fi
