output "access_logs_bucket_name" {
  description = "Access logs bucket name."
  value       = aws_s3_bucket.access_logs.id
}
output "access_logs_bucket_arn" {
  description = "Access logs bucket ARN."
  value       = aws_s3_bucket.access_logs.arn
}
output "access_logs_bucket_policy_id" {
  description = "Access logs bucket policy ID."
  value       = aws_s3_bucket_policy.access_logs.id
}
output "vpc_flow_log_group_name" {
  description = "VPC flow log group name."
  value       = aws_cloudwatch_log_group.vpc_flow.name
}
output "cloudtrail_arn" {
  description = "CloudTrail ARN."
  value       = aws_cloudtrail.this.arn
}

