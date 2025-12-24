# Q-CTRL Static Website

A secure static website deployed on AWS using Terraform and GitHub Actions.

## Architecture

- **S3 Bucket**: Hosts static website files
- **CloudFront**: CDN with SSL/TLS termination
- **Route53**: DNS management for q-ctrl.arbitra.io
- **WAF**: Web Application Firewall for security
- **ACM**: SSL certificate management

## Deployment

The website is automatically deployed via GitHub Actions when changes are pushed to the main branch.

## Security Features

- CloudFront Origin Access Control (OAC)
- WAF with rate limiting and AWS managed rules
- HTTPS-only access with TLS 1.2+
- Secure S3 bucket policies

## Local Development

1. Make changes to `index.html`
2. Commit and push to main branch
3. GitHub Actions will deploy automatically

## Infrastructure

All infrastructure is defined in the `terraform/` directory and includes:
- S3 bucket configuration
- CloudFront distribution
- SSL certificate
- DNS records
- Security policies
