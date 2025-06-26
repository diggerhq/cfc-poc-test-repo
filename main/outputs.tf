output "test_bucket_name" {
  description = "Name of the test S3 bucket"
  value       = aws_s3_bucket.test_bucket.id
}

output "log_group_name" {
  description = "Name of the test CloudWatch log group"
  value       = aws_cloudwatch_log_group.test_log_group.name
}

output "ssm_parameter_name" {
  description = "Name of the test SSM parameter"
  value       = aws_ssm_parameter.test_parameter.name
}

output "iam_role_arn" {
  description = "ARN of the test IAM role"
  value       = aws_iam_role.test_role.arn
}

output "resource_summary" {
  description = "Summary of created resources"
  value = {
    bucket_name      = aws_s3_bucket.test_bucket.id
    log_group       = aws_cloudwatch_log_group.test_log_group.name
    parameter_name  = aws_ssm_parameter.test_parameter.name
    role_arn        = aws_iam_role.test_role.arn
  }
}
