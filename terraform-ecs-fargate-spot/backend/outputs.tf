output "state_bucket_name" {
  description = "Terraform state S3 bucket name."
  value       = aws_s3_bucket.state.id
}

output "state_bucket_arn" {
  description = "Terraform state S3 bucket ARN."
  value       = aws_s3_bucket.state.arn
}
