# React.js Application with Docker, Kubernetes, and CI/CD Pipeline

This project demonstrates a complete CI/CD pipeline for a React.js application using Docker, Kubernetes, and GitHub Actions. The application is deployed to UpCloud's Kubernetes cluster.

## Project Structure

```
.
├── .github/
│   └── workflows/
│       └── deploy-upcloud.yaml    # GitHub Actions workflow
├── deployment.yml                 # Kubernetes deployment configuration
├── service.yml                    # Kubernetes service configuration
├── Dockerfile                     # Docker build configuration
├── nginx.conf                     # Nginx configuration for serving React app
├── .dockerignore                 # Docker ignore file
└── README.md                     # Project documentation
```

## Prerequisites

- Docker Hub account
- UpCloud account with Kubernetes cluster
- GitHub account
- Node.js and npm installed locally

## Configuration

### 1. Docker Configuration

#### Dockerfile
The application uses a multi-stage Docker build:
```dockerfile
# Build stage
FROM node:18-alpine as build
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# Production stage
FROM nginx:alpine
COPY --from=build /app/build /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
```

#### .dockerignore
Excludes unnecessary files from the Docker build:
```
# Version control
.git
.gitignore

# Dependencies
node_modules
npm-debug.log

# Build outputs
build
dist

# Environment files
.env
.env.local

# IDE and editor files
.idea
.vscode

# UpCloud specific
upcloud/
.github/

# Docker files
Dockerfile
.dockerignore
```

### 2. Kubernetes Configuration

#### deployment.yml
```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: frontend
  namespace: default
spec:
  replicas: 2
  selector:
    matchLabels:
      app: frontend
  template:
    metadata:
      labels:
        app: frontend
    spec:
      imagePullSecrets:
      - name: dockerhub-secret
      containers:
      - name: frontend
        image: joelwembo/frontend_app_demo:latest
        imagePullPolicy: Always
        ports:
        - containerPort: 80
```

#### service.yml
```yaml
apiVersion: v1
kind: Service
metadata:
  name: frontend
  namespace: default
spec:
  type: LoadBalancer
  ports:
    - port: 80
      targetPort: 80
      protocol: TCP
      name: http
  selector:
    app: frontend
```

### 3. GitHub Actions Workflow

The workflow (`deploy-upcloud.yaml`) handles:
1. Building the React application
2. Building and pushing Docker image
3. Installing and configuring UpCloud CLI
4. Deploying to Kubernetes
5. Verifying deployment

## Setup Instructions

### 1. Local Development

1. Clone the repository:
```bash
git clone <repository-url>
cd cicd-upcloud-docker-kubernetes-reactjs
```

2. Install dependencies:
```bash
npm install
```

3. Run locally:
```bash
npm start
```

### 2. Docker Build

1. Build the Docker image:
```bash
docker build -t joelwembo/frontend_app_demo:latest .
```

2. Run the container:
```bash
docker run -p 80:80 joelwembo/frontend_app_demo:latest
```

### 3. Kubernetes Deployment

1. Create Docker Hub secret in Kubernetes:
```bash
kubectl create secret docker-registry dockerhub-secret \
  --docker-server=https://index.docker.io/v1/ \
  --docker-username=<your-dockerhub-username> \
  --docker-password=<your-dockerhub-token> \
  --docker-email=<your-email> \
  -n default
```

2. Apply Kubernetes configurations:
```bash
kubectl apply -f deployment.yml
kubectl apply -f service.yml
```

### 4. GitHub Secrets

Add the following secrets to your GitHub repository:
- `DOCKERHUB_USERNAME`: Your Docker Hub username
- `DOCKERHUB_TOKEN`: Your Docker Hub access token
- `DOCKERHUB_EMAIL`: Your Docker Hub email
- `UPCLOUD_USERNAME`: Your UpCloud username
- `UPCLOUD_PASSWORD`: Your UpCloud password
- `UPCLOUD_KUBECONFIG`: Your UpCloud Kubernetes configuration

## CI/CD Pipeline

The pipeline automatically:
1. Builds the React application
2. Creates a Docker image
3. Pushes to Docker Hub
4. Deploys to UpCloud Kubernetes cluster
5. Verifies the deployment

### Workflow Triggers

The pipeline runs on:
- Push to main/master/dev branches
- Pull requests to main/master/dev branches
- Changes to:
  - `.github/workflows/deploy-upcloud.yaml`
  - `deployment.yml`
  - `service.yml`

## Monitoring and Maintenance

### Checking Deployment Status

```bash
# Check pods
kubectl get pods -n default

# Check services
kubectl get svc -n default

# Check deployments
kubectl get deployment -n default

# View pod logs
kubectl logs -l app=frontend -n default
```

### Updating the Application

1. Make changes to the React application
2. Commit and push to the repository
3. The GitHub Actions workflow will automatically:
   - Build the new version
   - Deploy to Kubernetes
   - Verify the deployment

## Troubleshooting

### Common Issues

1. Docker Build Failures
   - Check Dockerfile syntax
   - Verify all required files are present
   - Check .dockerignore configuration

2. Kubernetes Deployment Issues
   - Verify Docker Hub credentials
   - Check pod logs for errors
   - Ensure namespace exists
   - Verify resource limits

3. GitHub Actions Workflow Failures
   - Check GitHub Secrets configuration
   - Verify UpCloud credentials
   - Check workflow file syntax

## Security Considerations

1. Docker Hub credentials are stored as Kubernetes secrets
2. UpCloud credentials are stored as GitHub Secrets
3. Sensitive information is never exposed in logs
4. All deployments use HTTPS
5. Regular security updates through npm audit

## Contributing

1. Fork the repository
2. Create a feature branch
3. Make your changes
4. Submit a pull request

## License

[Your License Here]
