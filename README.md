# Q-CTRL Static Website

A secure static website deployed on AWS using Terraform and GitHub Actions, displaying personalized content for Wilberto's Q-CTRL test flight.

## 🌐 Live Website

**Production URL:** https://q-ctrl.arbitra.io

## 🏗️ Current Architecture

### Infrastructure Components
- **S3 Bucket** (Sydney - ap-southeast-2): Hosts static website files
- **CloudFront Distribution**: Global CDN with SSL/TLS termination
- **Route53**: DNS management for q-ctrl.arbitra.io subdomain
- **ACM**: SSL certificate management (wildcard *.arbitra.io)
- **Origin Access Control (OAC)**: Secure S3 access

### Security Features
- HTTPS-only access with TLS 1.2+
- CloudFront Origin Access Control prevents direct S3 access
- Secure S3 bucket policies
- SSL certificate with SNI support

### Deployment Pipeline
- **GitHub Actions**: Automated CI/CD pipeline
- **Terraform**: Infrastructure as Code
- **S3 Backend**: Terraform state management
- **Automatic Deployment**: Triggered on main branch commits

## 🚀 Deployment

The website is automatically deployed via GitHub Actions when changes are pushed to the main branch.

### Manual Deployment
```bash
cd terraform
terraform init
terraform plan
terraform apply
```

### File Upload
```bash
aws s3 sync . s3://q-ctrl.arbitra.io --exclude "terraform/*" --exclude ".git/*"
aws cloudfront create-invalidation --distribution-id <DISTRIBUTION_ID> --paths "/*"
```

## 📁 Project Structure

```
q-ctrl/
├── index.html              # Main website page
├── error.html              # 404 error page
├── terraform/              # Infrastructure as Code
│   ├── main.tf             # Provider and backend configuration
│   ├── variables.tf        # Input variables
│   ├── s3-cloudfront.tf    # S3 and CloudFront resources
│   ├── waf.tf              # Security rules (disabled)
│   └── outputs.tf          # Output values
├── .github/workflows/
│   └── deploy.yml          # CI/CD pipeline
└── README.md               # This file
```

## 🔧 Local Development

1. Make changes to `index.html` or `error.html`
2. Commit and push to main branch
3. GitHub Actions will deploy automatically
4. Website updates appear at https://q-ctrl.arbitra.io

## ⚙️ Configuration

### AWS Resources
- **Region**: ap-southeast-2 (Sydney) for S3
- **Global**: CloudFront, ACM, Route53
- **Domain**: q-ctrl.arbitra.io
- **SSL**: Wildcard certificate (*.arbitra.io)

### Environment Variables
Set in GitHub Secrets:
- `AWS_ACCESS_KEY_ID`
- `AWS_SECRET_ACCESS_KEY`

## 🔮 Alternative Architecture

### Future State: Kubernetes + ArgoCD GitOps

For enhanced scalability and enterprise-grade deployment capabilities, the following alternative architecture could be implemented:

#### **Alternative Deployment: Container-Based**
- **Container Runtime**: Docker containers for application packaging
- **Kubernetes Cluster**: Amazon EKS for orchestration and scaling
- **Service Mesh**: Istio for advanced traffic management and security
- **Ingress Controller**: AWS Load Balancer Controller with SSL termination

#### **Alternative Infrastructure: Cloud-Native Stack**
- **Compute**: EKS worker nodes with auto-scaling groups
- **Storage**: EFS for persistent volumes, S3 for static assets
- **Networking**: VPC with private/public subnets, NAT gateways
- **Security**: IAM roles, security groups, network policies
- **Monitoring**: CloudWatch, Prometheus, Grafana stack

#### **Alternative Deployment Pipeline: GitOps with ArgoCD**

```yaml
# Future GitOps Architecture
GitOps Workflow:
  1. Developer commits to main branch
  2. GitHub Actions builds and pushes container image
  3. ArgoCD detects changes in Git repository
  4. ArgoCD automatically syncs desired state to EKS cluster
  5. Kubernetes deploys updated application pods
  6. Istio manages traffic routing and canary deployments
```

**Benefits of GitOps Approach:**
- **Declarative Configuration**: Infrastructure and applications defined as code
- **Automated Synchronization**: ArgoCD ensures cluster state matches Git
- **Rollback Capabilities**: Easy reversion to previous working states
- **Multi-Environment Support**: Dev, staging, production environments
- **Enhanced Security**: Git-based audit trail and access controls
- **Scalability**: Horizontal pod autoscaling based on metrics

**Implementation Path:**
1. Containerize static website with Nginx
2. Create Kubernetes manifests (Deployment, Service, Ingress)
3. Set up EKS cluster with ArgoCD installation
4. Configure ArgoCD applications for automated deployment
5. Implement monitoring and alerting stack
6. Establish multi-environment promotion pipeline

This GitOps architecture would provide enterprise-grade deployment capabilities while maintaining the simplicity and reliability of the current static website approach.

---

**Current Status**: Production-ready static website with automated deployment
**Future Vision**: Cloud-native GitOps platform for scalable applications
