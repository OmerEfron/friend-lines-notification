# GCP Deployment Guide for Friend Lines App

This guide will help you deploy your Node.js server to Google Cloud Platform using the free tier and set up CI/CD.

## 🚀 Quick Start

### 1. Prerequisites
- Google Cloud account (free tier eligible)
- Google Cloud CLI installed
- GitHub repository with your code

### 2. Initial Setup

#### Install Google Cloud CLI
```bash
# macOS (using Homebrew)
brew install google-cloud-sdk

# Or download from: https://cloud.google.com/sdk/docs/install
```

#### Authenticate with GCP
```bash
gcloud auth login
gcloud auth application-default login
```

#### Create a new project (or use existing)
```bash
gcloud projects create friend-lines-app-$(date +%s) --name="Friend Lines App"
gcloud config set project YOUR_PROJECT_ID
```

#### Enable billing (required for Cloud Run)
- Go to [Google Cloud Console](https://console.cloud.google.com)
- Select your project
- Enable billing (free tier gives you $300 credit for 90 days)

#### Set up Cloud Build permissions (IMPORTANT!)
```bash
# Get your project ID
PROJECT_ID=$(gcloud config get-value project)

# Grant Cloud Build service account the necessary roles
gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$PROJECT_ID@cloudbuild.gserviceaccount.com" \
  --role="roles/storage.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$PROJECT_ID@cloudbuild.gserviceaccount.com" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding $PROJECT_ID \
  --member="serviceAccount:$PROJECT_ID@cloudbuild.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"
```

**Note**: These permissions are required for Cloud Build to access Google Cloud Storage and deploy to Cloud Run. Without them, you'll get permission errors during deployment.

### 3. Deploy Manually

#### Option A: Using the deployment script
```bash
# Make script executable
chmod +x gcp-deploy.sh

# Set environment variables
export GCP_PROJECT_ID="your-project-id"
export GCP_REGION="us-central1"

# Run deployment
./gcp-deploy.sh
```

#### Option B: Using gcloud commands directly
```bash
# Build and deploy
gcloud builds submit --tag gcr.io/YOUR_PROJECT_ID/friend-lines-app .
gcloud run deploy friend-lines-app \
  --image gcr.io/YOUR_PROJECT_ID/friend-lines-app \
  --platform managed \
  --region us-central1 \
  --allow-unauthenticated \
  --port 8080
```

### 4. Set up CI/CD with GitHub Actions

#### Create Service Account
```bash
# Create service account
gcloud iam service-accounts create github-actions \
  --display-name="GitHub Actions"

# Grant necessary roles
gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/run.admin"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/iam.serviceAccountUser"

gcloud projects add-iam-policy-binding YOUR_PROJECT_ID \
  --member="serviceAccount:github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com" \
  --role="roles/storage.admin"

# Create and download key
gcloud iam service-accounts keys create ~/github-actions-key.json \
  --iam-account=github-actions@YOUR_PROJECT_ID.iam.gserviceaccount.com
```

#### Add GitHub Secrets
1. Go to your GitHub repository
2. Navigate to Settings → Secrets and variables → Actions
3. Add the following secrets:
   - `GCP_PROJECT_ID`: Your GCP project ID
   - `GCP_SA_KEY`: The content of `~/github-actions-key.json`

### 5. Free Tier Benefits

- **Cloud Run**: 2 million requests per month
- **Cloud Build**: 120 build-minutes per day
- **Container Registry**: 0.5 GB storage
- **Cloud Logging**: 50 GB per month

### 6. Monitoring and Management

#### View logs
```bash
gcloud logs tail --service=friend-lines-app
```

#### Check service status
```bash
gcloud run services describe friend-lines-app --region=us-central1
```

#### Scale manually (if needed)
```bash
gcloud run services update friend-lines-app \
  --region=us-central1 \
  --min-instances=1 \
  --max-instances=5
```

### 7. Environment Variables

The app automatically uses these environment variables:
- `NODE_ENV`: Set to 'production' in Cloud Run
- `PORT`: Set to 8080 (Cloud Run requirement)

### 8. Troubleshooting

#### Common Issues:
1. **Permission denied**: Ensure service account has proper roles
2. **Storage access denied**: Run the Cloud Build permission setup commands above
3. **Build fails**: Check Dockerfile and dependencies
4. **Service won't start**: Check logs and environment variables
5. **Billing not enabled**: Required for Cloud Run

#### Useful Commands:
```bash
# Check project configuration
gcloud config list

# List all services
gcloud run services list --region=us-central1

# Delete service if needed
gcloud run services delete friend-lines-app --region=us-central1
```

## 🔄 CI/CD Workflow

The GitHub Actions workflow will:
1. Trigger on every push to main/master branch
2. Install dependencies and run tests
3. Authenticate with GCP
4. Build and deploy to Cloud Run
5. Provide deployment URL

## 📊 Cost Optimization

- **Min instances**: Set to 0 for free tier (cold starts)
- **Max instances**: Limited to 10 for cost control
- **Memory**: 512Mi is sufficient for most Node.js apps
- **CPU**: 1 vCPU provides good performance

## 🚨 Security Notes

- Service is publicly accessible (--allow-unauthenticated)
- Consider adding authentication for production use
- Service account keys should be kept secure
- Regularly rotate service account keys
