#!/bin/bash

# Friend Lines App - Render Cloud Deployment Script
echo "☁️  Deploying Friend Lines App to Render Cloud..."

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "❌ Git is not installed. Please install git first."
    exit 1
fi

# Check if we're in a git repository
if ! git rev-parse --git-dir > /dev/null 2>&1; then
    echo "❌ Not in a git repository. Please run this from your project directory."
    exit 1
fi

# Check if render.yaml exists
if [ ! -f "render.yaml" ]; then
    echo "❌ render.yaml not found. Creating it now..."
    cat > render.yaml << EOF
services:
  - type: web
    name: friend-lines-app
    env: node
    plan: free
    buildCommand: npm install
    startCommand: npm start
    envVars:
      - key: NODE_ENV
        value: production
      - key: PORT
        value: 3005
    healthCheckPath: /health
    autoDeploy: true
    branch: main
EOF
    echo "✅ render.yaml created!"
fi

# Check git status
echo "🔍 Checking git status..."
if [ -n "$(git status --porcelain)" ]; then
    echo "⚠️  You have uncommitted changes. Committing them now..."
    git add .
    git commit -m "Auto-commit before Render deployment"
fi

# Push to remote if not already pushed
echo "📤 Pushing to remote repository..."
if git push origin main; then
    echo "✅ Code pushed to GitHub successfully!"
else
    echo "❌ Failed to push to GitHub. Please check your remote configuration."
    exit 1
fi

echo ""
echo "🎉 Deployment to Render initiated!"
echo ""
echo "📋 Next Steps:"
echo "1. Go to [render.com](https://render.com) and sign up/login"
echo "2. Click 'New +' → 'Web Service'"
echo "3. Connect your GitHub repository"
echo "4. Select 'friend-lines-app' repository"
echo "5. Render will auto-detect settings from render.yaml"
echo "6. Click 'Create Web Service'"
echo ""
echo "🌐 Your app will be available at:"
echo "   https://friend-lines-app.onrender.com"
echo ""
echo "⏱️  First deployment takes 5-10 minutes"
echo "🔄 Auto-deploy on every git push to main branch"
echo ""
echo "📊 Monitor deployment at:"
echo "   https://dashboard.render.com"
