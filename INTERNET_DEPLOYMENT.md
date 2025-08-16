# 🌐 Internet Deployment Guide

This guide explains how to make your Friend Lines App accessible from the internet.

## 🚀 **Quick Start Options**

### 1. **Router Port Forwarding (Home/Office)**
### 2. **Cloud Deployment (AWS, GCP, Azure)**
### 3. **Reverse Proxy with Domain**
### 4. **Tunnel Services (ngrok, Cloudflare Tunnel)**

---

## 🔧 **Option 1: Router Port Forwarding**

### **Step 1: Deploy with Internet Ports**
```bash
# Use the internet deployment script
./deploy-internet.sh

# Or manually with docker-compose
docker-compose -f docker-compose.prod.yml up -d
```

### **Step 2: Configure Router**
1. **Access your router** (usually `192.168.1.1` or `192.168.0.1`)
2. **Find Port Forwarding section**
3. **Add these rules:**
   - **Port 80** → Your machine's local IP (e.g., `192.168.1.100`)
   - **Port 443** → Your machine's local IP
   - **Port 3005** → Your machine's local IP

### **Step 3: Find Your Public IP**
```bash
# Check your public IP
curl ifconfig.me
# or visit: whatismyipaddress.com
```

### **Step 4: Access Your App**
- **HTTP**: `http://YOUR_PUBLIC_IP:80`
- **HTTPS**: `https://YOUR_PUBLIC_IP:443`
- **Direct**: `http://YOUR_PUBLIC_IP:3005`

---

## ☁️ **Option 2: Cloud Deployment**

### **AWS EC2 (Recommended for beginners)**
```bash
# 1. Launch EC2 instance (Ubuntu 22.04 LTS)
# 2. Install Docker
sudo apt update
sudo apt install docker.io docker-compose

# 3. Clone your repo
git clone <your-repo>
cd friend-lines-app

# 4. Deploy
./deploy-internet.sh

# 5. Configure Security Group
# - Allow HTTP (80)
# - Allow HTTPS (443)
# - Allow SSH (22)
```

### **Google Cloud Run (Serverless)**
```bash
# 1. Install gcloud CLI
# 2. Build and deploy
gcloud run deploy friend-lines-app \
  --source . \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated
```

---

## 🌍 **Option 3: Reverse Proxy with Domain**

### **Step 1: Get a Domain**
- **Free**: Freenom, Dot.tk
- **Paid**: Namecheap, GoDaddy, Google Domains

### **Step 2: Set up Nginx**
```bash
# Install nginx
sudo apt install nginx

# Copy configuration
sudo cp nginx-reverse-proxy.conf /etc/nginx/sites-available/friend-lines-app

# Edit configuration with your domain
sudo nano /etc/nginx/sites-available/friend-lines-app

# Enable site
sudo ln -s /etc/nginx/sites-available/friend-lines-app /etc/nginx/sites-enabled/

# Test configuration
sudo nginx -t

# Restart nginx
sudo systemctl restart nginx
```

### **Step 3: SSL Certificate (Let's Encrypt)**
```bash
# Install certbot
sudo apt install certbot python3-certbot-nginx

# Get certificate
sudo certbot --nginx -d your-domain.com -d www.your-domain.com

# Auto-renewal
sudo crontab -e
# Add: 0 12 * * * /usr/bin/certbot renew --quiet
```

---

## 🚇 **Option 4: Tunnel Services**

### **ngrok (Quick Testing)**
```bash
# Install ngrok
brew install ngrok  # macOS
# or download from ngrok.com

# Start your Docker app
./deploy.sh

# Create tunnel
ngrok http 3005

# Your app is now accessible via ngrok URL
```

### **Cloudflare Tunnel (Production)**
```bash
# Install cloudflared
# Create tunnel in Cloudflare dashboard
# Configure tunnel to point to localhost:3005
```

---

## 🔒 **Security Considerations**

### **Firewall Configuration**
```bash
# Ubuntu/Debian
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 3005/tcp
sudo ufw enable

# CentOS/RHEL
sudo firewall-cmd --permanent --add-port=80/tcp
sudo firewall-cmd --permanent --add-port=443/tcp
sudo firewall-cmd --permanent --add-port=3005/tcp
sudo firewall-cmd --reload
```

### **Environment Variables**
```bash
# Create .env file
NODE_ENV=production
PORT=3005
HOST=0.0.0.0
# Add any API keys or secrets
```

### **Rate Limiting**
Consider adding rate limiting middleware to your Express app for production use.

---

## 📱 **Testing Your Deployment**

### **Local Testing**
```bash
# Test health endpoint
curl http://localhost:3005/health

# Test notification endpoint
curl -X POST http://localhost:3005/notification/create-new-notification \
  -H "Content-Type: application/json" \
  -d '{"content": "Hello Internet!"}'
```

### **Internet Testing**
```bash
# Test from another network or use online tools
curl http://YOUR_PUBLIC_IP:80/health
curl http://YOUR_PUBLIC_IP:3005/health
```

---

## 🚨 **Troubleshooting**

### **Port Already in Use**
```bash
# Check what's using the port
sudo lsof -i :80
sudo lsof -i :443

# Stop conflicting services
sudo systemctl stop apache2  # if Apache is running
sudo systemctl stop nginx     # if nginx is running
```

### **Container Won't Start**
```bash
# Check logs
docker logs friend-lines-server-prod

# Check container status
docker ps -a

# Restart container
docker restart friend-lines-server-prod
```

### **Can't Access from Internet**
1. **Check router port forwarding**
2. **Verify firewall settings**
3. **Test with different ports**
4. **Check ISP restrictions**

---

## 📚 **Additional Resources**

- [Docker Networking](https://docs.docker.com/network/)
- [Nginx Configuration](https://nginx.org/en/docs/)
- [Let's Encrypt](https://letsencrypt.org/docs/)
- [Cloudflare Tunnel](https://developers.cloudflare.com/cloudflare-one/connections/connect-apps/)
- [ngrok Documentation](https://ngrok.com/docs)
