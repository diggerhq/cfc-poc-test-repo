terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
  
  backend "s3" {
    bucket         = "terraform-state-afe8302486d87e0d"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    dynamodb_table = "terraform-state-lock-afe8302486d87e0d"
  }
}

provider "aws" {
  region = var.aws_region
}

resource "random_id" "suffix" {
  byte_length = 4
}

# Quick resources that are fast to create/destroy
resource "aws_s3_bucket" "test_bucket" {
  bucket = "test-bucket-${random_id.suffix.hex}"
}

resource "aws_cloudwatch_log_group" "test_log_group" {
  name              = "/test/log-group-${random_id.suffix.hex}"
  retention_in_days = 7
}

resource "aws_ssm_parameter" "test_parameter" {
  name  = "/test/parameter-${random_id.suffix.hex}"
  type  = "String"
  value = "test-value-${random_id.suffix.hex}"
}

resource "aws_iam_role" "test_role" {
  name = "test-role-${random_id.suffix.hex}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Principal = {
          Service = "lambda.amazonaws.com"
        }
      }
    ]
  })
}

resource "aws_iam_policy" "test_policy" {
  name = "test-policy-${random_id.suffix.hex}"

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]
        Resource = "arn:aws:logs:*:*:*"
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "test_attachment" {
  role       = aws_iam_role.test_role.name
  policy_arn = aws_iam_policy.test_policy.arn
}
