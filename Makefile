.PHONY: help init-s3 plan-s3 apply-s3 destroy-s3 init-eks plan-eks apply-eks destroy-eks clean

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

# S3 + CloudFront targets
init-s3: ## Initialize Terraform for S3+CloudFront
	terraform -chdir=terraform/s3-cloudfront init

plan-s3: ## Plan S3+CloudFront infrastructure
	terraform -chdir=terraform/s3-cloudfront plan

apply-s3: ## Apply S3+CloudFront infrastructure
	terraform -chdir=terraform/s3-cloudfront apply
	@echo "Uploading website files..."
	@BUCKET_NAME=$$(terraform -chdir=terraform/s3-cloudfront output -raw bucket_name) && \
	aws s3 sync website/ s3://$$BUCKET_NAME
	@echo "Invalidating CloudFront cache..."
	@DISTRIBUTION_ID=$$(terraform -chdir=terraform/s3-cloudfront output -raw cloudfront_distribution_id) && \
	aws cloudfront create-invalidation --distribution-id $$DISTRIBUTION_ID --paths "/*"
	@echo "Website URL: $$(terraform -chdir=terraform/s3-cloudfront output -raw website_url)"

destroy-s3: ## Destroy S3+CloudFront infrastructure
	@echo "Emptying S3 bucket..."
	@BUCKET_NAME=$$(terraform -chdir=terraform/s3-cloudfront output -raw bucket_name) && \
	aws s3 rm s3://$$BUCKET_NAME --recursive || true
	terraform -chdir=terraform/s3-cloudfront destroy

# EKS targets
init-eks: ## Initialize Terraform for EKS
	terraform -chdir=terraform/eks init

plan-eks: ## Plan EKS infrastructure
	terraform -chdir=terraform/eks plan

apply-eks: ## Apply EKS infrastructure and deploy application
	terraform -chdir=terraform/eks apply
	@echo "Updating kubeconfig..."
	@CLUSTER_NAME=$$(terraform -chdir=terraform/eks output -raw cluster_name) && \
	aws eks update-kubeconfig --region us-east-1 --name $$CLUSTER_NAME
	@echo "Deploying Kubernetes resources..."
	kubectl apply -f kubernetes/
	@echo "Waiting for deployment..."
	kubectl rollout status deployment/static-website -n static-website --timeout=300s
	@echo "Getting Load Balancer URL..."
	@kubectl get service static-website-service -n static-website

destroy-eks: ## Destroy EKS infrastructure
	@echo "Deleting Kubernetes resources..."
	kubectl delete -f kubernetes/ || true
	terraform -chdir=terraform/eks destroy

# Utility targets
clean: ## Clean Terraform files
	find . -name ".terraform" -type d -exec rm -rf {} + || true
	find . -name "terraform.tfstate*" -delete || true
	find . -name ".terraform.lock.hcl" -delete || true

validate: ## Validate all Terraform configurations
	terraform -chdir=terraform/s3-cloudfront validate
	terraform -chdir=terraform/eks validate

format: ## Format all Terraform files
	terraform fmt -recursive .

check-tools: ## Check if required tools are installed
	@command -v aws >/dev/null 2>&1 || { echo "AWS CLI is required but not installed."; exit 1; }
	@command -v terraform >/dev/null 2>&1 || { echo "Terraform is required but not installed."; exit 1; }
	@command -v kubectl >/dev/null 2>&1 || { echo "kubectl is required but not installed."; exit 1; }
	@echo "All required tools are installed."