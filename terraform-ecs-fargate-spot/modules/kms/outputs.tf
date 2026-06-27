output "s3_key_id" {
  description = "S3 KMS key ID."
  value       = aws_kms_key.this["s3"].key_id
}
output "s3_key_arn" {
  description = "S3 KMS key ARN."
  value       = aws_kms_key.this["s3"].arn
}
output "aurora_key_id" {
  description = "Aurora KMS key ID."
  value       = aws_kms_key.this["aurora"].key_id
}
output "aurora_key_arn" {
  description = "Aurora KMS key ARN."
  value       = aws_kms_key.this["aurora"].arn
}
output "secrets_key_id" {
  description = "Secrets Manager KMS key ID."
  value       = aws_kms_key.this["secrets"].key_id
}
output "secrets_key_arn" {
  description = "Secrets Manager KMS key ARN."
  value       = aws_kms_key.this["secrets"].arn
}
output "cloudwatch_key_id" {
  description = "CloudWatch KMS key ID."
  value       = aws_kms_key.this["cloudwatch"].key_id
}
output "cloudwatch_key_arn" {
  description = "CloudWatch KMS key ARN."
  value       = aws_kms_key.this["cloudwatch"].arn
}
output "key_arns" {
  description = "All KMS key ARNs."
  value       = [for key in aws_kms_key.this : key.arn]
}

