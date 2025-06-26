# Terraform Test Infrastructure

This repository contains test Terraform configurations for testing deployment automation.

## Structure

- `backend/` - Creates S3 bucket and DynamoDB table for Terraform state management
- `main/` - Main Terraform project that uses remote state and creates test AWS resources

## Usage

### 1. Deploy Backend Infrastructure

First, deploy the backend infrastructure to create the S3 bucket for state storage:

```bash
cd backend
terraform init
terraform plan
terraform apply
```

After applying, note the outputs, especially `state_bucket_id`.

### 2. Configure Main Project Backend

Update the backend configuration in `main/main.tf` with the values from the backend outputs:

```hcl
backend "s3" {
  bucket         = "terraform-state-xxxxxxxx"  # From backend output
  key            = "terraform.tfstate"
  region         = "us-east-1"
  dynamodb_table = "terraform-state-lock-xxxxxxxx"  # From backend output
}
```

### 3. Deploy Main Infrastructure

```bash
cd main
terraform init
terraform plan
terraform apply
```

## Resources Created

### Backend Project
- S3 bucket for Terraform state with versioning and encryption
- DynamoDB table for state locking
- Proper security configurations

### Main Project
- S3 bucket (fast to create)
- CloudWatch log group (fast to create)
- SSM parameter (fast to create)
- IAM role and policy (fast to create)

All resources are designed to be quick to create and destroy for testing purposes.

## Cleanup

To destroy resources:

```bash
# Destroy main infrastructure first
cd main
terraform destroy

# Then destroy backend infrastructure
cd ../backend
terraform destroy
```
